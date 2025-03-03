require("dotenv").config();
const { Pool } = require("pg");
DATABASE_URL=postgres://recipe_recommendationdb_zsvn_user:2UhvPlyf1rTCzkyVrA2oCAEhwl22ZMru@dpg-cv2m8oan91rc73bvc3og-a:5432/recipe_recommendationdb_zsvn;
const pool = new Pool({
  connectionString: process.env.DATABASE_URL
, // Use environment variable
  ssl: {
    rejectUnauthorized: false, // Required for Render's managed PostgreSQL
  },
});

pool
  .connect()
  .then(() => console.log("Connected to PostgreSQL"))
  .catch((err) => console.error("Error connecting to PostgreSQL:", err));

module.exports = { pool };





