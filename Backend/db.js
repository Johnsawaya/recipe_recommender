require("dotenv").config();
const { Pool } = require("pg");

const pool = new Pool({
  user: "recipe_recommendationdb_user",
  host: "dpg-cueabr1opnds738erc0g-a",
  database: "recipe_recommendationdb",
  password: "fWbabdmI4vt2ao12Jqu4ZnQgVCT0BB2N",
  port: process.env.DB_PORT || 5432,
});

pool
  .connect()
  .then(() => console.log("Connected to PostgreSQL"))
  .catch((err) => console.error("Error connecting to PostgreSQL:", err));

module.exports = { pool };




