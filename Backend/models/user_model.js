const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const userSchema = new mongoose.Schema({
fullName: { type: String, required: true, trim: true },
email: { 
    type: String, 
    required: [true, "Please add an email"], 
    unique: true, 
    match: [/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/, "Please add a valid email"]
},
    phoneNumber: { type: String, required: true },
    password: { type: String, required: true, minlength: 6, select: false },

  // Link User to a Delivery Location
locationId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "Location",
    required: true,
},

  address: { type: String, required: true }, // Specific address (e.g., "House 12, Street 5")
    role: { type: String, enum: ["user", "admin"], default: "user" },
    createdAt: { type: Date, default: Date.now },
});

// Encrypt password
userSchema.pre("save", async function (next) {
    if (!this.isModified("password")) next();
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
});

// Sign JWT
userSchema.methods.getSignedJwtToken = function () {
    return jwt.sign({ id: this._id }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRE });
};

// Match password
userSchema.methods.matchPassword = async function (enteredPassword) {
    return await bcrypt.compare(enteredPassword, this.password);
};

module.exports = mongoose.model("User", userSchema);