const mongoose = require("mongoose");
const dotenv = require("dotenv");
const Location = require("./models/location_model");
const User = require("./models/user_model");

dotenv.config({ path: "./config/config.env" });
mongoose.connect(process.env.LOCAL_DATABASE_URI);

const locations = [
  { areaName: "Kathmandu", deliveryCharge: 50 },
  { areaName: "Lalitpur", deliveryCharge: 60 },
];

const importData = async () => {
  try {
    await Location.deleteMany();
    await User.deleteMany();
    await Location.create(locations);
    console.log("Data Imported...");
    process.exit();
  } catch (err) { console.error(err); }
};

if (process.argv[2] === "-i") {
  importData();
}