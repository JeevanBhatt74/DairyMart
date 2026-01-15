const asyncHandler = require("../middleware/async");
const Location = require("../models/location_model");

// @desc    Get all locations
// @route   GET /api/v1/locations
exports.getAllLocations = asyncHandler(async (req, res) => {
  const locations = await Location.find();
  res.status(200).json({ success: true, count: locations.length, data: locations });
});

// @desc    Create location
// @route   POST /api/v1/locations
exports.createLocation = asyncHandler(async (req, res) => {
  const location = await Location.create(req.body);
  res.status(201).json({ success: true, data: location });
});