const asyncHandler = require("../middleware/async");
const User = require("../models/user_model");
const Location = require("../models/location_model");

// @desc    Register User
// @route   POST /api/v1/users/register
exports.registerUser = asyncHandler(async (req, res, next) => {
  const { fullName, email, phoneNumber, password, locationId, address } = req.body;

  // Validate Location
  const location = await Location.findById(locationId);
  if (!location) {
    return res.status(404).json({ success: false, message: "Location not found" });
  }

  // Create User
  const user = await User.create({
    fullName,
    email,
    phoneNumber,
    password,
    locationId,
    address
  });

  sendTokenResponse(user, 201, res);
});

// @desc    Login User
// @route   POST /api/v1/users/login
exports.loginUser = asyncHandler(async (req, res, next) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ success: false, message: "Please provide email and password" });
  }

  // Check for user
  const user = await User.findOne({ email }).select("+password");
  if (!user) {
    return res.status(401).json({ success: false, message: "Invalid credentials" });
  }

  // Check password
  const isMatch = await user.matchPassword(password);
  if (!isMatch) {
    return res.status(401).json({ success: false, message: "Invalid credentials" });
  }

  sendTokenResponse(user, 200, res);
});

// Helper to send Token
const sendTokenResponse = (user, statusCode, res) => {
  const token = user.getSignedJwtToken();
  const options = {
    expires: new Date(Date.now() + process.env.JWT_COOKIE_EXPIRE * 24 * 60 * 60 * 1000),
    httpOnly: true,
  };
  res.status(statusCode).cookie("token", token, options).json({ success: true, token });
};