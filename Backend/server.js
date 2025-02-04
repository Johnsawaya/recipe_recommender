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
  const { username, password } = req.body;

  if (!username || !password) {
    return res.status(400).json({ message: "username and password are required." });
  }

  try {
    const result = await pool.query("SELECT * FROM auth_users WHERE username = $1", [username]);

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
// get user info


app.get("/api/user/:username", async (req, res) => {
  const { username } = req.params;

  try {
    // Step 1: Get auth_id from auth_users table
    const authResult = await pool.query(
      "SELECT id FROM auth_users WHERE username = $1",
      [username]
    );

    if (authResult.rows.length === 0) {
      return res.status(404).json({ message: "User not found" });
    }

    const authId = authResult.rows[0].id;

    // Step 2: Get user info from users table using auth_id
    const userResult = await pool.query(
      "SELECT auth_id, name, dietary_preferences, health_goal, age, height, weight FROM users WHERE auth_id = $1",
      [authId]
    );

    if (userResult.rows.length === 0) {
      return res.status(404).json({ message: "User details not found" });
    }

    res.status(200).json(userResult.rows[0]);
  } catch (err) {
    console.error("Error fetching user info:", err.message);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});


// Registration Route
app.post("/api/register", async (req, res) => {
  const { username, password, name, dietary_preferences, health_goal, age, height, weight } = req.body;

  try {
    const authResult = await pool.query(
      "INSERT INTO auth_users (username, password) VALUES ($1, $2) RETURNING id",
      [username, password]
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
  if (health_goal === "Weight Loss") {
    targetCalories = TDEE - 500;
  } else if (health_goal === "Muscle Gain") {
    targetCalories = TDEE + 500;
  } else {
    targetCalories = TDEE;
  }

  console.log("Target Calories:", targetCalories);  // Log the calculated target calories
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

    // Calculate target calories (for goal personalization)
    const targetCalories = calculateCalories(parseInt(age), parseFloat(height), parseFloat(weight), health_goal);
    console.log("Target Calories:", targetCalories);

    // Calculate min and max calorie range
    const minCalories = targetCalories * 0.9;
    const maxCalories = targetCalories * 1.1;
    console.log("Min Calories:", minCalories);
    console.log("Max Calories:", maxCalories);

    // Function to fetch and check the sum of random recipes
    const getValidRecipes = async () => {
      const recipeResult = await pool.query(
        `SELECT * FROM recipes
         ORDER BY RANDOM()
         LIMIT 5`
      );

      const totalCalories = recipeResult.rows.reduce((sum, recipe) => sum + parseFloat(recipe.calories), 0);


      // If the sum of calories is within the range, return the recipes
      if (totalCalories >= minCalories && totalCalories <= maxCalories) {
        return recipeResult.rows;
      }

      // If not, try fetching a new set of 5 recipes
      return null;
    };

    // Attempt to get valid recipes
    let validRecipes = null;
    while (!validRecipes) {
      validRecipes = await getValidRecipes();
    }


    res.status(200).json(validRecipes);
  } catch (err) {
    console.error("Error fetching recommended recipes:", err.message);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});






app.post("/api/favorites", async (req, res) => {
  const { userId, recipeId } = req.body;

  if (!userId || !recipeId) {
    return res.status(400).json({ message: "User ID and Recipe ID are required." });
  }

  try {
    // Insert the favorite recipe into the user_recipes table
    await pool.query(
      "INSERT INTO user_recipes (user_id, recipe_id) VALUES ($1, $2)",
      [userId, recipeId]
    );

    res.status(200).json({ message: "Recipe added to favorites" });
  } catch (err) {
    console.error("Error saving favorite:", err.message);
    res.status(500).json({ message: "Failed to add favorite", error: err.message });
  }
});

app.get("/api/favorites/:userId", async (req, res) => {
  const { userId } = req.params;

  try {
    // Query to get the favorite recipes of the user
    const result = await pool.query(
      `SELECT r.* FROM recipes r
       JOIN user_recipes ur ON r.id = ur.recipe_id
       WHERE ur.user_id = $1`,
      [userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: "No favorites found" });
    }

    res.status(200).json(result.rows);
  } catch (err) {
    console.error("Error fetching favorites:", err.message);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});
// delete fav
app.delete("/api/favorites/:userId/:recipeId", async (req, res) => {
  const { userId, recipeId } = req.params;

  try {
    // Delete the favorite if it exists
    const result = await pool.query(
      `DELETE FROM user_recipes WHERE user_id = $1 AND recipe_id = $2 RETURNING *`,
      [userId, recipeId]
    );

    if (result.rowCount === 0) {
      return res.status(404).json({ message: "Favorite not found" });
    }

    res.status(200).json({ message: "Favorite removed successfully" });
  } catch (err) {
    console.error("Error removing favorite:", err.message);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});






// Start the Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});



