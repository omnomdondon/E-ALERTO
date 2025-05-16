// ✅ E-ALERTO server.js (Fully functional with ES modules)
import fs from "fs";
import NodeCache from "node-cache";
import express from "express";
import mongoose from "mongoose";
import cors from "cors";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import { OAuth2Client } from "google-auth-library";
import multer from "multer";
import compression from "compression";
import dotenv from "dotenv";
import path from "path";
import { fileURLToPath } from "url";
import { GridFSBucket } from "mongodb";
import { Readable } from "stream";
import { spawn } from "child_process";

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Load .env
dotenv.config({ path: path.join(__dirname, "./.env") });
console.log("🌍 Loaded MONGO_URI:", process.env.MONGO_URI);

const reportsCache = new NodeCache({ stdTTL: 30 });
const upload = multer({ storage: multer.memoryStorage() });
const app = express();
const PORT = process.env.PORT || 3000;
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);
const SECRET_KEY = process.env.SECRET_KEY;

// Middleware
app.use(compression());
app.use(express.json({ limit: "10mb" }));
app.use(cors());

app.get("/", (req, res) => {
  res.send("Server is running!");
});

// Connect MongoDB
mongoose
  .connect(process.env.MONGO_URI, {
    dbName: "account",
    maxPoolSize: 10,
    socketTimeoutMS: 30000,
    connectTimeoutMS: 10000,
  })
  .then(() => console.log("✅ Connected to MongoDB"))
  .catch((err) => console.error("❌ MongoDB connection error:", err));

let gfs;
let gridFSBucket;

mongoose.connection.once("open", () => {
  gridFSBucket = new GridFSBucket(mongoose.connection.db, {
    bucketName: "reportImages",
  });
  console.log("🗂️ GridFSBucket initialized");
});

// ==================== SCHEMAS ====================
const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  full_name: { type: String, default: "" },
  email: { type: String, required: true, unique: true },
  password: { type: String },
  phone: { type: String, required: true },
  created_at: { type: Date, default: Date.now },
  googleId: { type: String },
  otpToken: { type: String, default: null },
  otpExpiresAt: { type: Date, default: null },
  verified: { type: Boolean, default: false },
});

const reportSchema = new mongoose.Schema({
  reportID: { type: String, required: true, unique: true },
  classification: { type: String, required: true },
  measurement: { type: String },
  location: { type: String, required: true },
  status: { type: String, default: "Submitted" },
  username: { type: String, required: true },
  description: { type: String },
  timestamp: { type: Date, default: Date.now },
  image_file: { type: String },
  assignedTo: { type: String, default: null },
  isRated: { type: Boolean, default: false },
});
reportSchema.index({ timestamp: -1 });
reportSchema.index({ username: 1 });

const ratingSchema = new mongoose.Schema({
  userID: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  report_ID: { type: String, required: true },
  overall: { type: Number, min: 1, max: 5, required: true },
  service: { type: Number, min: 1, max: 5, required: true },
  speed: { type: Number, min: 1, max: 5, required: true },
  feedback: { type: String, required: true },
  timestamp: { type: Date, default: Date.now },
});

const User = mongoose.model("User", userSchema, "users");
const Report = mongoose.model("Report", reportSchema, "reports");
const Rating = mongoose.model("Rating", ratingSchema, "ratings");

userSchema.pre("remove", async function (next) {
  try {
    await Report.deleteMany({ username: this.username });
    await Rating.deleteMany({ userID: this._id });
    next();
  } catch (err) {
    next(err);
  }
});

function generateOTP() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

async function sendSMSToPhone(phone, otp) {
  console.log(`📱 [DEV MODE] OTP for ${phone}: ${otp}`);
}

function validateImage(req, res, next) {
  if (!req.file)
    return res.status(400).json({ message: "No image file provided" });
  const allowedTypes = ["image/jpeg", "image/png", "image/gif"];
  if (!allowedTypes.includes(req.file.mimetype)) {
    return res.status(400).json({ message: "Invalid image type" });
  }
  next();
}

// ================= ROUTES =================
// --- Delete User Account
app.delete("/api/delete-account", async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, SECRET_KEY);
    const user = await User.findById(decoded.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    // Remove the user (this will trigger the cascade delete of reports and ratings)
    await user.remove();

    res.status(200).json({
      message: "Account and all associated data deleted successfully.",
    });
  } catch (err) {
    console.error("❌ Deletion error:", err);
    res.status(500).json({ message: "Server error during account deletion" });
  }
});

// --- Auth Routes
app.post("/api/register", async (req, res) => {
  const { username, email, password, full_name, phone } = req.body;

  try {
    const existingUser = await User.findOne({ email });
    if (existingUser)
      return res.status(400).json({ message: "Email already exists." });

    const hashedPassword = await bcrypt.hash(password, 10);

    const newUser = new User({
      username,
      email,
      password: hashedPassword,
      full_name,
      phone,
    });

    await newUser.save();

    return res
      .status(201)
      .json({ success: true, message: "User registered successfully!" });
  } catch (err) {
    console.error("❌ Registration error:", err);
    return res.status(500).json({ success: false, message: "Server error." });
  }
});

app.post("/api/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user || !user.password)
      return res.status(400).json({ message: "Invalid credentials." });

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid)
      return res.status(400).json({ message: "Invalid credentials." });

    const token = jwt.sign({ id: user._id }, SECRET_KEY, { expiresIn: "1d" });

    return res.status(200).json({
      token,
      username: user.username,
      full_name: user.full_name,
      email: user.email,
    });
  } catch (err) {
    console.error("❌ Login error:", err);
    return res.status(500).json({ message: "Server error." });
  }
});

app.post("/api/google-login", async (req, res) => {
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
        username: email.split("@")[0],
        email,
        full_name: name,
        googleId: sub,
        password: "",
        phone: "",
      });
      await user.save();
    }

    const token = jwt.sign({ id: user._id }, SECRET_KEY, { expiresIn: "1d" });

    return res.status(200).json({
      token,
      username: user.username,
      full_name: user.full_name,
      email: user.email,
    });
  } catch (err) {
    console.error("❌ Google login error:", err);
    return res.status(400).json({ message: "Invalid Google token." });
  }
});

// --- Profile Info
app.get("/api/profile", async (req, res) => {
  try {
    const authHeader = req.headers.authorization;
    if (!authHeader?.startsWith("Bearer "))
      return res.status(401).json({ message: "Unauthorized" });

    const token = authHeader.split(" ")[1];
    const decoded = jwt.verify(token, SECRET_KEY);
    const user = await User.findById(decoded.id).select(
      "username email phone verified"
    );

    if (!user) return res.status(404).json({ message: "User not found" });

    res.status(200).json(user);
  } catch (err) {
    console.error("Profile fetch error:", err);
    res.status(401).json({ message: "Invalid token" });
  }
});

// --- OTP Routes
app.post("/api/send-otp", async (req, res) => {
  const { email, phone } = req.body;
  const otp = generateOTP();

  try {
    const expiresAt = new Date(Date.now() + 60 * 1000);
    const user = await User.findOneAndUpdate(
      { email },
      { otpToken: otp, otpExpiresAt: expiresAt },
      { new: true }
    );

    if (!user) return res.status(404).json({ message: "User not found" });

    await sendSMSToPhone(phone, otp);

    return res
      .status(200)
      .json({ success: true, message: "OTP sent via Brevo!" });
  } catch (err) {
    console.error("Send OTP error:", err);
    return res.status(500).json({ message: "Failed to send OTP" });
  }
});

app.post("/api/verify-otp", async (req, res) => {
  const { email, otp } = req.body;

  try {
    const user = await User.findOne({ email });

    if (!user || user.otpToken !== otp) {
      return res.status(400).json({ message: "Invalid OTP" });
    }

    if (user.otpExpiresAt < new Date()) {
      return res.status(400).json({ message: "OTP expired" });
    }

    user.otpToken = null;
    user.otpExpiresAt = null;
    user.verified = true;
    await user.save();

    return res.status(200).json({ success: true, message: "OTP verified!" });
  } catch (err) {
    console.error("OTP verify error:", err);
    return res.status(500).json({ message: "Server error" });
  }
});

// --- Submit Report (Improved image handling)
app.post("/api/reports", upload.single("image_file"), async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer "))
    return res.status(401).json({ message: "Unauthorized" });

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, SECRET_KEY);
    const user = await User.findById(decoded.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    const { classification, measurement, location, timestamp, description } =
      req.body;

    let imageFileId = null;

    // ✅ Use existing GridFS image ID if no file was uploaded
    if (req.file && gridFSBucket) {
      const fileName = `report_${Date.now()}.jpeg`;

      const readableStream = Readable.from(req.file.buffer);
      const uploadStream = gridFSBucket.openUploadStream(fileName, {
        contentType: req.file.mimetype,
      });

      await new Promise((resolve, reject) => {
        readableStream
          .pipe(uploadStream)
          .on("error", reject)
          .on("finish", () => {
            imageFileId = uploadStream.id.toString();
            resolve();
          });
      });
    } else if (req.body.image_file) {
      // 🧠 Assume it's a GridFS ID string passed from client
      imageFileId = req.body.image_file;
    }

    const report = new Report({
      reportID: Date.now().toString(),
      classification,
      measurement,
      location,
      description,
      timestamp: timestamp ? new Date(timestamp) : new Date(),
      image_file: imageFileId?.toString(), // Store ObjectId as string
      status: "Submitted",
      username: user.username,
    });

    await report.save();

    res.status(201).json({
      success: true,
      message: "Report saved successfully!",
      shouldRedirect: true,
    });
  } catch (err) {
    console.error("❌ Report save error:", err);
    res.status(500).json({
      success: false,
      message: "Failed to save report",
      shouldRedirect: false,
    });
  }
});

app.get("/api/image/:id", async (req, res) => {
  try {
    const fileId = new mongoose.Types.ObjectId(req.params.id);
    const downloadStream = gridFSBucket.openDownloadStream(fileId);

    downloadStream.on("error", (err) => {
      console.error("❌ GridFS image error:", err);
      res.status(404).send("Image not found");
    });

    res.set("Content-Type", "image/jpeg");
    downloadStream.pipe(res).on("error", () => {
      res.status(404).sendFile(path.join(__dirname, "fallback.jpg"));
    });
  } catch (err) {
    console.error("❌ Invalid image ID:", err);
    res.status(400).send("Invalid image ID");
  }
});

// ✅ Get All Reports with pagination
app.get("/api/reports", async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const [reports, total] = await Promise.all([
      Report.find(
        {},
        {
          reportID: 1,
          classification: 1,
          location: 1,
          status: 1,
          timestamp: 1,
          username: 1,
        }
      )
        .sort({ timestamp: -1 })
        .skip(skip)
        .limit(limit)
        .lean(),

      Report.countDocuments(),
    ]);

    res.status(200).json({
      success: true,
      reports,
      pagination: {
        currentPage: page,
        totalPages: Math.ceil(total / limit),
        totalReports: total,
      },
    });
  } catch (err) {
    console.error("Fetch reports error:", err);
    res
      .status(500)
      .json({ success: false, message: "Failed to fetch reports" });
  }
});

// Cached reports endpoint
app.get("/api/reports/cached", async (req, res) => {
  try {
    const cacheKey = "all-reports";
    const cached = reportsCache.get(cacheKey);

    if (cached) {
      return res.json({
        success: true,
        reports: cached,
        fromCache: true,
      });
    }

    const reports = await Report.find({})
      .sort({ timestamp: -1 })
      .limit(100)
      .lean();

    reportsCache.set(cacheKey, reports);
    res.json({
      success: true,
      reports,
      fromCache: false,
    });
  } catch (err) {
    console.error("Cached reports error:", err);
    res.status(500).json({ success: false, message: "Server error" });
  }
});

// Get single report with proper image handling
app.get("/api/reports/:reportID", async (req, res) => {
  try {
    const report = await Report.findOne({
      reportID: req.params.reportID,
    }).lean();
    if (!report) {
      return res.status(404).json({ message: "Report not found" });
    }

    res.status(200).json({ success: true, report });
  } catch (err) {
    console.error("Fetch report error:", err);
    res.status(500).json({ success: false, message: "Server error" });
  }
});

// Get Report by reportID for Profile Rating
app.get("/api/reports/rating/:reportID", async (req, res) => {
  const { reportID } = req.params; // Use reportID from URL parameter

  try {
    const report = await Report.findOne({ reportID: reportID }); // Query by reportID
    if (!report) {
      return res.status(404).json({ message: "Report not found" });
    }
    return res.status(200).json({ success: true, report });
  } catch (err) {
    console.error("❌ Fetch profile rating report error:", err);
    return res
      .status(500)
      .json({ success: false, message: "Failed to fetch report for rating" });
  }
});

// Place this below your /api/reports route or near /detect
app.post(
  "/api/upload-detected-image",
  upload.single("image_file"),
  validateImage,
  async (req, res) => {
    try {
      if (!req.file) {
        return res.status(400).json({ message: "No image file uploaded" });
      }

      const fileName = `detected_${Date.now()}.jpeg`;

      const readableStream = Readable.from(req.file.buffer);
      const uploadStream = gridFSBucket.openUploadStream(fileName, {
        contentType: req.file.mimetype,
      });

      uploadStream.on("error", (err) => {
        console.error("❌ GridFS upload error:", err);
        return res.status(500).json({ message: "Upload failed" });
      });

      uploadStream.on("finish", () => {
        const imageId = uploadStream.id.toString();
        console.log(`✅ Detected image stored with ID: ${imageId}`);
        return res.status(201).json({ image: imageId });
      });

      readableStream.pipe(uploadStream);
    } catch (err) {
      console.error("❌ Upload error:", err);
      res.status(500).json({ message: "Server error during image upload" });
    }
  }
);

// --- Detect Route for Image Processing
app.post("/detect", upload.single("image"), async (req, res) => {
  try {
    const imageBuffer = req.file?.buffer;
    if (!imageBuffer) {
      return res.status(400).json({ message: "No image file uploaded." });
    }

    // Save image to GridFS
    const fileName = `detect_${Date.now()}.jpeg`;
    const readableStream = Readable.from(imageBuffer);
    const uploadStream = gridFSBucket.openUploadStream(fileName, {
      contentType: req.file.mimetype,
    });

    let imageId;
    await new Promise((resolve, reject) => {
      readableStream
        .pipe(uploadStream)
        .on("error", reject)
        .on("finish", () => {
          imageId = uploadStream.id.toString();
          resolve();
        });
    });

    // Spawn Python detection process
    const python = spawn("python3", ["detect.py"]); // your detection script

    python.stdin.write(imageBuffer);
    python.stdin.end();

    let result = "";
    python.stdout.on("data", (data) => {
      result += data.toString();
    });

    python.stderr.on("data", (data) => {
      console.error(`stderr: ${data}`);
    });

    python.on("close", (code) => {
      if (code !== 0) {
        return res.status(500).json({ message: "Detection script failed." });
      }

      const parsed = JSON.parse(result);
      res.status(200).json({
        detections: parsed.detections,
        image: imageId,
      });
    });
  } catch (err) {
    console.error("❌ Image detection error:", err);
    return res.status(500).json({ message: "Failed to process image" });
  }
});

// --- Submit Rating API
app.post("/api/submit-rating", async (req, res) => {
  const { reportID, overall, service, speed, feedback } = req.body;
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, SECRET_KEY);
    const user = await User.findById(decoded.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    // Check if the user has already rated the report
    const existingRating = await Rating.findOne({
      userID: user._id,
      report_ID: reportID,
    });
    if (existingRating) {
      return res
        .status(400)
        .json({ message: "You have already rated this report." });
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

    // 🔁 Update report status to "Rated"
    await Report.findOneAndUpdate({ reportID }, { isRated: true });

    return res
      .status(201)
      .json({ success: true, message: "Rating submitted and status updated!" });
  } catch (err) {
    console.error("❌ Rating submission error:", err);
    return res.status(500).json({ message: "Failed to submit rating" });
  }
});

app.get("/api/ratings", async (req, res) => {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) {
    return res.status(401).json({ message: "Unauthorized" });
  }

  const token = authHeader.split(" ")[1];
  try {
    const decoded = jwt.verify(token, SECRET_KEY);
    const user = await User.findById(decoded.id);
    if (!user) return res.status(404).json({ message: "User not found" });

    const ratings = await Rating.find({ userID: user._id }).select("report_ID");
    const ratedReportIDs = ratings.map((r) => r.report_ID);

    res.status(200).json({ success: true, ratedReportIDs });
  } catch (err) {
    console.error("❌ Fetch ratings error:", err);
    res.status(500).json({ success: false, message: "Server error" });
  }
});

// --- Start Server
app.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
});
