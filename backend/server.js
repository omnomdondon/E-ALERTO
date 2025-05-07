const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
const axios = require('axios');
const multer = require('multer');
require('dotenv').config({ path: './backend/.env' });

const app = express();
const PORT = process.env.PORT || 5000;
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
const SECRET_KEY = process.env.SECRET_KEY;

const upload = multer({ storage: multer.memoryStorage() });

app.use(express.json({ limit: '10mb' }));
app.use(cors());

// Health check route
app.get('/', (req, res) => {
    res.send('Server is running!');
});

// --- MongoDB Connection
mongoose.connect(process.env.MONGO_URI, { dbName: 'account' })
    .then(() => console.log('✅ Connected to MongoDB'))
    .catch((err) => console.error('❌ MongoDB connection error:', err));

// --- User Schema
const userSchema = new mongoose.Schema({
    username: { type: String, required: true, unique: true },
    full_name: { type: String, default: '' },
    email: { type: String, required: true, unique: true },
    password: { type: String },
    phone: { type: String, required: true },
    created_at: { type: Date, default: Date.now },
    googleId: { type: String },
    otpToken: { type: String, default: null },
    otpExpiresAt: { type: Date, default: null },
    verified: { type: Boolean, default: false },
});

const User = mongoose.model('User', userSchema, 'users');

// --- Report Schema
const reportSchema = new mongoose.Schema({
    reportID: { type: String, required: true, unique: true },
    classification: { type: String, required: true },
    measurement: { type: String },
    location: { type: String, required: true },
    status: { type: String, default: 'Submitted' },
    username: { type: String, required: true },
    description: { type: String },
    timestamp: { type: Date, default: Date.now },
    image_file: { type: String },
});

const Report = mongoose.model('Report', reportSchema, 'reports');

// --- Rating Schema
const ratingSchema = new mongoose.Schema({
    userID: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    report_ID: { type: String, required: true },
    overall: { type: Number, min: 1, max: 5, required: true },
    service: { type: Number, min: 1, max: 5, required: true },
    speed: { type: Number, min: 1, max: 5, required: true },
    feedback: { type: String, required: true },
    timestamp: { type: Date, default: Date.now },
});

const Rating = mongoose.model('Rating', ratingSchema, 'ratings');

// --- Helper
function generateOTP() {
    return Math.floor(100000 + Math.random() * 900000).toString();
}

async function sendSMSToPhone(phone, otp) {
    console.log(`📱 [DEV MODE] OTP for ${phone}: ${otp}`);
}

// --- Auth Routes
app.post('/api/register', async (req, res) => {
    const { username, email, password, full_name, phone } = req.body;

    try {
        const existingUser = await User.findOne({ email });
        if (existingUser) return res.status(400).json({ message: 'Email already exists.' });

        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = new User({
            username,
            email,
            password: hashedPassword,
            full_name,
            phone,
        });

        await newUser.save();

        return res.status(201).json({ success: true, message: 'User registered successfully!' });
    } catch (err) {
        console.error('❌ Registration error:', err);
        return res.status(500).json({ success: false, message: 'Server error.' });
    }
});

app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;

    try {
        const user = await User.findOne({ email });
        if (!user || !user.password) return res.status(400).json({ message: 'Invalid credentials.' });

        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) return res.status(400).json({ message: 'Invalid credentials.' });

        const token = jwt.sign({ id: user._id }, SECRET_KEY, { expiresIn: '1d' });

        return res.status(200).json({
            token,
            username: user.username,
            full_name: user.full_name,
            email: user.email,
        });
    } catch (err) {
        console.error('❌ Login error:', err);
        return res.status(500).json({ message: 'Server error.' });
    }
});

app.post('/api/google-login', async (req, res) => {
    const { idToken } = req.body;

    try {
        const ticket = await client.verifyIdToken({
            idToken,
            audience: process.env.GOOGLE_CLIENT_ID,
        });

        const payload = ticket.getPayload();
        const { email, name, sub } = payload;

        let user = await User.findOne({ email });
        if (!user) {
            user = new User({
                username: email.split('@')[0],
                email,
                full_name: name,
                googleId: sub,
                password: '',
                phone: '',
            });
            await user.save();
        }

        const token = jwt.sign({ id: user._id }, SECRET_KEY, { expiresIn: '1d' });

        return res.status(200).json({
            token,
            username: user.username,
            full_name: user.full_name,
            email: user.email,
        });
    } catch (err) {
        console.error('❌ Google login error:', err);
        return res.status(400).json({ message: 'Invalid Google token.' });
    }
});

// --- Profile Info
app.get('/api/profile', async (req, res) => {
    try {
        const authHeader = req.headers.authorization;
        if (!authHeader?.startsWith('Bearer ')) return res.status(401).json({ message: 'Unauthorized' });

        const token = authHeader.split(' ')[1];
        const decoded = jwt.verify(token, SECRET_KEY);
        const user = await User.findById(decoded.id).select('username email phone verified');

        if (!user) return res.status(404).json({ message: 'User not found' });

        res.status(200).json(user);
    } catch (err) {
        console.error('Profile fetch error:', err);
        res.status(401).json({ message: 'Invalid token' });
    }
});

// --- OTP Routes
app.post('/api/send-otp', async (req, res) => {
    const { email, phone } = req.body;
    const otp = generateOTP();

    try {
        const expiresAt = new Date(Date.now() + 60 * 1000);
        const user = await User.findOneAndUpdate(
            { email },
            { otpToken: otp, otpExpiresAt: expiresAt },
            { new: true }
        );

        if (!user) return res.status(404).json({ message: 'User not found' });

        await sendSMSToPhone(phone, otp);

        return res.status(200).json({ success: true, message: 'OTP sent via Brevo!' });
    } catch (err) {
        console.error('Send OTP error:', err);
        return res.status(500).json({ message: 'Failed to send OTP' });
    }
});

app.post('/api/verify-otp', async (req, res) => {
    const { email, otp } = req.body;

    try {
        const user = await User.findOne({ email });

        if (!user || user.otpToken !== otp) {
            return res.status(400).json({ message: 'Invalid OTP' });
        }

        if (user.otpExpiresAt < new Date()) {
            return res.status(400).json({ message: 'OTP expired' });
        }

        user.otpToken = null;
        user.otpExpiresAt = null;
        user.verified = true;
        await user.save();

        return res.status(200).json({ success: true, message: 'OTP verified!' });
    } catch (err) {
        console.error('OTP verify error:', err);
        return res.status(500).json({ message: 'Server error' });
    }
});

// ✅ Submit Report
app.post('/api/reports', upload.single('image_file'), async (req, res) => {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) return res.status(401).json({ message: 'Unauthorized' });

    const token = authHeader.split(' ')[1];

    try {
        const decoded = jwt.verify(token, SECRET_KEY);
        const user = await User.findById(decoded.id);
        if (!user) return res.status(404).json({ message: 'User not found' });

        const {
            classification,
            measurement,
            location,
            timestamp,
            description
        } = req.body;

        const imageBuffer = req.file?.buffer;
        const imageBase64 = imageBuffer ? imageBuffer.toString('base64') : '';

        const report = new Report({
            reportID: Date.now().toString(),
            classification,
            measurement,
            location,
            description,
            timestamp: timestamp ? new Date(timestamp) : new Date(),
            image_file: imageBase64,
            status: 'Submitted',
            username: user.username,
        });

        await report.save();

        res.status(201).json({ success: true, message: 'Report saved successfully!' });
    } catch (err) {
        console.error('❌ Report save error:', err);
        res.status(500).json({ success: false, message: 'Failed to save report' });
    }
});

// ✅ Get All Reports
app.get('/api/reports', async (req, res) => {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
        return res.status(401).json({ message: 'Unauthorized' });
    }

    const token = authHeader.split(' ')[1];

    try {
        const decoded = jwt.verify(token, SECRET_KEY);
        const user = await User.findById(decoded.id);
        if (!user) return res.status(404).json({ message: 'User not found' });

        const reports = await Report.find().sort({ timestamp: -1 });

        return res.status(200).json({ success: true, reports });
    } catch (err) {
        console.error('❌ Fetch reports error:', err);
        return res.status(500).json({ success: false, message: 'Failed to fetch reports' });
    }
});

// Get Single Report by reportID for HomeDetail
app.get('/api/reports/:reportID', async (req, res) => {
    const { reportID } = req.params;  // Use reportID from URL parameter

    try {
        const report = await Report.findOne({ reportID: reportID }); // Query by reportID
        if (!report) {
            return res.status(404).json({ message: 'Report not found' });
        }
        return res.status(200).json({ success: true, report });
    } catch (err) {
        console.error('❌ Fetch single report error:', err);
        return res.status(500).json({ success: false, message: 'Failed to fetch report' });
    }
});

// Get Report by reportID for Profile Rating
app.get('/api/reports/rating/:reportID', async (req, res) => {
    const { reportID } = req.params;  // Use reportID from URL parameter

    try {
        const report = await Report.findOne({ reportID: reportID }); // Query by reportID
        if (!report) {
            return res.status(404).json({ message: 'Report not found' });
        }
        return res.status(200).json({ success: true, report });
    } catch (err) {
        console.error('❌ Fetch profile rating report error:', err);
        return res.status(500).json({ success: false, message: 'Failed to fetch report for rating' });
    }
});

// --- Detect Route for Image Processing 
app.post('/detect', upload.single('image'), async (req, res) => {
    try {
        const imageBuffer = req.file?.buffer;
        if (!imageBuffer) {
            return res.status(400).json({ message: 'No image file uploaded.' });
        }

        // Here you would process the image (e.g., object detection)
        // For now, let's mock the response with dummy detections and image
        const detections = [
            { label: 'Object1', confidence: 0.98 },
            { label: 'Object2', confidence: 0.85 }
        ];

        // Mock base64 image response (your backend logic will generate the image)
        const outputImage = imageBuffer.toString('base64');  // Converting image buffer to base64 for the response

        res.status(200).json({
            detections: detections,
            image: outputImage
        });

    } catch (err) {
        console.error('❌ Image detection error:', err);
        return res.status(500).json({ message: 'Failed to process image' });
    }
});

// --- Submit Rating API
app.post('/api/submit-rating', async (req, res) => {
    const { reportID, overall, service, speed, feedback } = req.body;
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith('Bearer ')) {
        return res.status(401).json({ message: 'Unauthorized' });
    }

    const token = authHeader.split(' ')[1];

    try {
        const decoded = jwt.verify(token, SECRET_KEY);
        const user = await User.findById(decoded.id);
        if (!user) return res.status(404).json({ message: 'User not found' });

        // Check if the user has already rated the report
        const existingRating = await Rating.findOne({ userID: user._id, report_ID: reportID });
        if (existingRating) {
            return res.status(400).json({ message: 'You have already rated this report.' });
        }

        const rating = new Rating({
            userID: user._id,
            report_ID: reportID,
            overall,
            service,
            speed,
            feedback,
        });

        await rating.save();

        return res.status(201).json({ success: true, message: 'Rating submitted successfully!' });
    } catch (err) {
        console.error('❌ Rating submission error:', err);
        return res.status(500).json({ message: 'Failed to submit rating' });
    }
});

// --- Start Server
app.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});