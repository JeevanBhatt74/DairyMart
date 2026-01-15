const express = require("express");
const { getAllLocations, createLocation } = require("../controllers/location_controller");
const router = express.Router();

router.route("/").get(getAllLocations).post(createLocation);

module.exports = router;