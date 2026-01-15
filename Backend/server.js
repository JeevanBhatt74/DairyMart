const express = require("express");
const colors = require("colors"); // <--- This was missing!
const dotenv = require("dotenv");
const morgan = require("morgan");
const connectDB = require("./config/db");
const cors = require("cors");
const cookieParser = require("cookie-parser");
const errorHandler = require("./middleware/errorHandler");

// Load env vars
dotenv.config({ path: "./config/config.env" });

// Connect to database
connectDB();

const app = express();

// Middleware
app.use(express.json());
app.use(cookieParser());
app.use(morgan("dev"));
app.use(cors());

// Mount Routes
const locationRoutes = require("./routes/location_route");
const userRoutes = require("./routes/user_route");

app.use("/api/v1/locations", locationRoutes);
app.use("/api/v1/users", userRoutes);

// Error Handler
app.use(errorHandler);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`.yellow.bold);
});