const { Pool } = require("pg");

const pool = new Pool({
  user: "recipe_recommendationdb_zsvn_user",
  host: "dpg-cv2m8oan91rc73bvc3og-a.oregon-postgres.render.com", // Ensure this is correct
  database: "recipe_recommendationdb_zsvn",
  password: "2UhvPlyf1rTCzkyVrA2oCAEhwl22ZMru",
  port: 5432, // PostgreSQL default port
  ssl: {
    rejectUnauthorized: false, // Required for managed databases like Render
  },
});

pool
  .connect()
  .then(() => console.log("✅ Connected to PostgreSQL"))
  .catch((err) => console.error("❌ Error connecting to PostgreSQL:", err));

module.exports = { pool };





