require("dotenv").config();
const express = require("express");
const cors = require("cors");
const { pool } = require("./db");  // Import pool from db.js

const app = express();
app.use(cors());
app.use(express.json());

// Example Route for Database Test
app.get("/", async (req, res) => {
  try {
    const result = await pool.query("SELECT NOW()");  // Example query to get the current time
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
    // Query the auth_users table to find the user by email
    const result = await pool.query('SELECT * FROM auth_users WHERE email = $1', [email]);

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    // Compare the entered password with the one stored in the database (plain text comparison)
    const storedPassword = result.rows[0].password;

    if (storedPassword === password) {
      // Passwords match, return user info and success message
      return res.status(200).json({
        message: "Login successful",
        user: result.rows[0], // Include user info from auth_users table
      });
    } else {
      // Passwords don't match
      return res.status(401).json({ message: "Invalid password" });
    }
  } catch (err) {
    console.error("Error during login: ", err.message);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});

// REGISTrTION
app.post('/api/register', async (req, res) => {
  const { email, password, name, dietary_preferences, health_goal, age, height, daily_calories } = req.body;

  try {
    // Insert into the auth_users table (credentials)
    const authResult = await pool.query(
      'INSERT INTO auth_users (email, password) VALUES ($1, $2) RETURNING id',
      [email, password]
    );
    const authUserId = authResult.rows[0].id;

    // Insert into the users table (personal info)
    await pool.query(
      'INSERT INTO users (auth_id, name, dietary_preferences, health_goal, age, height, daily_calories) VALUES ($1, $2, $3, $4, $5, $6, $7)',
      [authUserId, name, dietary_preferences, health_goal, age, height, daily_calories]
    );

    res.status(200).send("User registered successfully");
  } catch (err) {
    console.error(err);
    res.status(500).send("Failed to register user");
  }
});



// Fetch Recipes
app.get("/api/recipes", async (req, res) => {
  try {
    const result = await pool.query(
      "SELECT id, title, image, calories, protein, prep_time FROM recipes"
    );
    res.status(200).json(result.rows);
  } catch (err) {
    console.error("Error fetching recipes:", err.message);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});


// Start the Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});



