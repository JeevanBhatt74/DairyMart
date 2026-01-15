const mongoose = require("mongoose");

const locationSchema = new mongoose.Schema({
  areaName: {
    type: String,
    required: [true, "Area name is required"],
    trim: true,
    unique: true,
  },
  deliveryCharge: {
    type: Number,
    default: 0,
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("Location", locationSchema);