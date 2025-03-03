require("dotenv").config();
const { Pool } = require("pg");

const pool = new Pool({
  connectionString: process.env.dpg-cv2m8oan91rc73bvc3og-a.oregon-postgres.render.com, // Use environment variable
  ssl: {
    rejectUnauthorized: false, // Required for Render's managed PostgreSQL
  },
});

pool
  .connect()
  .then(() => console.log("Connected to PostgreSQL"))
  .catch((err) => console.error("Error connecting to PostgreSQL:", err));

module.exports = { pool };





