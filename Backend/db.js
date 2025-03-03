require("dotenv").config();
const { Pool } = require("pg");

const pool = new Pool({
  user: "recipe_recommendationdb_zsvn_user",
  host: "dpg-cv2m8oan91rc73bvc3og-a",
  database: "recipe_recommendationdb_zsvn",
  password: "2UhvPlyf1rTCzkyVrA2oCAEhwl22ZMru",
  port: process.env.DB_PORT || 5432,
});

pool
  .connect()
  .then(() => console.log("Connected to PostgreSQL"))
  .catch((err) => console.error("Error connecting to PostgreSQL:", err));

module.exports = { pool };




