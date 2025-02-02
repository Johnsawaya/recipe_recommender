
require("dotenv").config();
const axios = require('axios');
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
        userId: userId, // Include the user ID
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
      "SELECT * FROM recipes"
    );
    res.status(200).json(result.rows);
  } catch (err) {
    console.error("Error fetching recipes:", err.message);
    res.status(500).json({ message: "Server error", error: err.message });
  }
});




// Fetch user data from the database
async function fetchUserData(userId) {
  const query = 'SELECT age, height, weight, health_goal FROM users WHERE auth_id = $1';
  const result = await pool.query(query, [userId]);
  return result.rows[0];
}

// Fetch recipes from the database
async function fetchRecipesFromDatabase() {
  const query = 'SELECT title, calories, protein, ingredients, steps FROM recipes';
  const result = await pool.query(query);
  return result.rows;
}




// Helper function to implement exponential backoff
async function retryRequest(fn, retries = 5, delay = 1000) {
  try {
    return await fn(); // Try the API request
  } catch (err) {
    if (retries <= 0) {
      throw err; // If no retries left, throw error
    }

    if (err.response && err.response.status === 429) {
      // If rate limit is exceeded (status code 429), retry with exponential backoff
      console.log(`Rate limit exceeded, retrying in ${delay}ms...`);
      await new Promise(resolve => setTimeout(resolve, delay));
      return retryRequest(fn, retries - 1, delay * 2); // Double the delay for each retry
    } else {
      throw err; // Throw other errors immediately
    }
  }
}


// Generate meal plan using ChatGPT with retry logic
async function generateMealPlan(userData, recipes) {
  const { age, height, weight, health_goal } = userData;

  // Calculate calorie intake
  const bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5; // For men
  const calorieIntake = bmr * 1.5;

  // Prepare API call
  const apiCall = async () => {
    return axios.post(
      'https://api.openai.com/v1/chat/completions',
      {
        model: 'gpt-3.5-turbo',
        messages: [
          {
            role: 'system',
            content: 'You are a nutritionist and meal planner.',
          },
          {
            role: 'user',
            content: `Create a meal plan for a user with the following data: Age: ${age}, Height: ${height}, Weight: ${weight}, Health Goal: ${health_goal}, Daily Calorie Intake: ${calorieIntake}. Recipes: ${JSON.stringify(recipes)}`,
          },
        ],
      },
      {
        headers: {
          'Authorization': `Bearer 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`,

        },
      }
    );
  };

  try {
    // Retry the API call if rate limit errors occur
    const chatGPTResponse = await retryRequest(apiCall);
    return chatGPTResponse.data.choices[0].message.content;
  } catch (error) {
    console.error('Error generating meal plan:', error);
    throw new Error('Failed to generate meal plan');
  }
}



// API endpoint to generate meal plan
app.post('/meal-plan', async (req, res) => {
  const { userId } = req.body;

  try {
    // Fetch user data from the database
    const userData = await fetchUserData(userId);
    console.log('User Data:', userData);
    if (!userData) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Fetch recipes from the database
    const recipes = await fetchRecipesFromDatabase();

    // Generate meal plan using ChatGPT
    const mealPlan = await generateMealPlan(userData, recipes);

    // Return the meal plan
    res.json({ mealPlan });
  } catch (error) {
    console.error('Error generating meal plan:', error);
    res.status(500).json({ error: 'Failed to generate meal plan' });
  }


  console.log('ChatGPT Response:', chatGPTResponse.data);
});




// Start the Server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});



