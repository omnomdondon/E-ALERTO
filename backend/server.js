// server.js
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { OAuth2Client } = require('google-auth-library');
require('dotenv').config({ path: './backend/.env' });

const app = express();
const PORT = process.env.PORT || 3000;

const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

app.use(express.json());
app.use(cors());

// MongoDB Connection
mongoose.connect(process.env.MONGO_URI)
    .then(() => console.log('Connected to MongoDB'))
    .catch(err => console.error('MongoDB connection error:', err));

// User Schema
const userSchema = new mongoose.Schema({
    username: { type: String, required: true, unique: true },
    full_name: { type: String, default: '' },
    email: { type: String, required: true, unique: true },
    password: { type: String },
    created_at: { type: Date, default: Date.now },
    googleId: { type: String }, // Add Google ID
});

const User = mongoose.model('User', userSchema);
const SECRET_KEY = process.env.SECRET_KEY;

// --- ROUTES ---

// Registration
app.post('/api/register', async (req, res) => {
    const { username, email, password, full_name } = req.body;
    try {
        const existingUser = await User.findOne({ email });
        if (existingUser) {
            return res.status(400).json({ message: 'Email already exists.' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = new User({
            username,
            email,
            password: hashedPassword,
            full_name,
        });

        await newUser.save();

        return res.status(201).json({ success: true, message: 'User registered successfully!' });
    } catch (err) {
        console.error('Registration error:', err);
        return res.status(500).json({ success: false, message: 'Server error.' });
    }
});

// Login
app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;
    try {
        const user = await User.findOne({ email });
        if (!user) {
            return res.status(400).json({ message: 'Invalid credentials.' });
        }

        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
            return res.status(400).json({ message: 'Invalid credentials.' });
        }

        const token = jwt.sign({ id: user._id }, SECRET_KEY, { expiresIn: '1d' });

        return res.status(200).json({
            token,
            username: user.username,
            full_name: user.full_name,
            email: user.email,
        });
    } catch (err) {
        console.error('Login error:', err);
        return res.status(500).json({ message: 'Server error.' });
    }
});

// --- Google Sign-In Login Route ---
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
            // If user does not exist, create it
            user = new User({
                username: email.split('@')[0], // Auto-generate username
                email,
                full_name: name,
                googleId: sub,
                password: '', // No password (optional)
            });
            await user.save();
        }

        const token = jwt.sign({ id: user._id }, SECRET_KEY, { expiresIn: '1d' });

        res.status(200).json({
            token,
            username: user.username,
            full_name: user.full_name,
            email: user.email,
        });

    } catch (error) {
        console.error('Google login error:', error);
        res.status(400).json({ message: 'Invalid Google token.' });
    }
});

// Start server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});