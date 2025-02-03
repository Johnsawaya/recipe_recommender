require("dotenv").config();
const express = require("express");
const cors = require("cors");
const { pool } = require("./db"); // Import pool from db.js

const app = express();
app.use(cors());
app.use(express.json());

// Example Route for Database Test
app.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");
    res.json({ message: "Connected to PostgreSQL", time: result.rows[0].now });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Login Route
app.post("/login", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ message: "Email and password are required." });
  }

  try {
    const result = await pool.query("SELECT * FROM auth_users WHERE email = $1", [email]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    const storedPassword = result.rows[0].password;

    if (storedPassword === password) {
      return res.status(200).json({
        message: "Login successful",
        user: result.rows[0], // User info
        userId: result.rows[0].id, // Corrected user ID retrieval
      });
    } else {
      return res.status(401).json({ message: "Invalid password" });
    }
  } catch (err) {
    console.error("Error during login: ", err.message);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});

// Registration Route
app.post("/api/register", async (req, res) => {
  const { email, password, name, dietary_preferences, health_goal, age, height, weight } = req.body;

  try {
    const authResult = await pool.query(
      "INSERT INTO auth_users (email, password) VALUES ($1, $2) RETURNING id",
      [email, password]
    );
    const authUserId = authResult.rows[0].id;

    await pool.query(
      "INSERT INTO users (auth_id, name, dietary_preferences, health_goal, age, height, weight) VALUES ($1, $2, $3, $4, $5, $6, $7)",
      [authUserId, name, dietary_preferences, health_goal, age, height, weight]
    );

    res.status(200).send("User registered successfully");
  } catch (err) {
    console.error(err);
    res.status(500).send("Failed to register user");
  }
});

// Fetch All Recipes
app.get("/api/recipes", async (req, res) => {
  try {
    const result = await pool.query("SELECT * FROM recipes");
    res.status(200).json(result.rows);
  } catch (err) {
    console.error("Error fetching recipes:", err.message);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});

// Function to Calculate Daily Calorie Needs (Mifflin-St Jeor)
function calculateCalories(age, height, weight, health_goal) {
  let BMR = 10 * weight + 6.25 * height - 5 * age + 5; // Assuming male
  let TDEE = BMR * 1.55; // Moderate activity factor

  let targetCalories;
  if (health_goal === "weight loss") {
    targetCalories = TDEE - 500;
  } else if (health_goal === "weight gain") {
    targetCalories = TDEE + 500;
  } else {
    targetCalories = TDEE;
  }

  return targetCalories;
}

// Fetch Recommended Recipes Based on User's Goal
app.get("/api/recommended-recipes/:userId", async (req, res) => {
  const { userId } = req.params;

  try {
    const userResult = await pool.query(
      "SELECT age, height, weight, health_goal FROM users WHERE auth_id = $1",
      [userId]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    const { age, height, weight, health_goal } = userResult.rows[0];

    const targetCalories = calculateCalories(age, height, weight, health_goal);
    const minCalories = targetCalories * 0.9;
    const maxCalories = targetCalories * 1.1;

    const recipeResult = await pool.query(
      `SELECT * FROM recipes
       WHERE calories BETWEEN $1 AND $2
       ORDER BY RANDOM()
       LIMIT 5`,
      [minCalories, maxCalories]
    );

    res.status(200).json(recipeResult.rows);
  } catch (err) {
    console.error("Error fetching recommended recipes:", err.message);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});

// Start the Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});










// Start the Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});



