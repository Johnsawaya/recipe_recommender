import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_recommender/data.dart';





class ApiService {
  static const String baseUrl = "https://recipe-recommender-backend-hfxt.onrender.com";

  // User Authentication
  static Future<Map<String, dynamic>> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to login");
    }
  }

  // Fetch User Info
// Fetch user info by userId
  static Future<User> getUserInfo(String username) async {
    final response = await http.get(Uri.parse("$baseUrl/api/user/$username"));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      return User.fromJson(jsonData);
    } else {
      throw Exception("Failed to fetch user info");
    }
  }
  // Register user (post to the backend)
  static Future<String> registerUser(
      String username,
      String password,
      String name,
      String dietPreference,
      String healthGoal,
      int age,
      double height,
      int weight) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/register"),
      body: json.encode({
        'username': username,
        'password': password,
        'name': name,
        'dietary_preferences': dietPreference,
        'health_goal': healthGoal,
        'age': age,
        'height': height,
        'weight': weight,
      }),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      return "User registered successfully";
    } else {
      throw Exception("Failed to register user");
    }
  }

  static Future<List<Recipe>> getRecipes() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/recipes"));
      print("API Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Decode the response body as a list of dynamic (since it's an array)
        List<dynamic> jsonData = jsonDecode(response.body);

        // Print the decoded JSON data to debug
        print("Decoded JSON: $jsonData");

        // Map the decoded data to a list of Recipe objects
        List<Recipe> recipes = jsonData.map((data) {
          return Recipe(
            data['id']??0,
            data['title'] ?? '',          // Handle null values
            data['description'] ?? '',
            data['image_url'] ?? '',      // Use 'image_url' based on the response format
            data['calories'] ?? 0,
            data['protein'] ?? 0,
            data['prep_time'] ?? 0,
            data['ingredients']?.join(", ") ?? '',  // Join ingredients list into a string
            data['steps']?.join("\n") ?? '',       // Join steps list into a string
          );
        }).toList();

        return recipes;
      } else {
        throw Exception("Failed to fetch recipes, Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching recipes: $e");
      return [];  // Return an empty list in case of error
    }
  }



  // Check if recipe is in favorites
  static Future<bool> isFavorite(int userId, int recipeId) async {
    final response = await http.get(Uri.parse("$baseUrl/api/favorites/$userId"));

    if (response.statusCode == 200) {
      List<dynamic> favorites = jsonDecode(response.body);
      return favorites.any((recipe) => recipe['id'] == recipeId);
    } else {
      print("Failed to fetch favorites: ${response.body}");
      return false;
    }
  }
// Fetch all favorite recipes for a user
  static Future<List<Recipe>> fetchFavorites(int userId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/favorites/$userId"));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        // Convert JSON data to a list of Recipe objects
        List<Recipe> favorites = jsonData.map((data) {
          return Recipe(
            data['id'] ?? 0,
            data['title'] ?? '',
            data['description'] ?? '',
            data['image_url'] ?? '',
            data['calories'] ?? 0,
            data['protein'] ?? 0,
            data['prep_time'] ?? 0,

            data['ingredients']?.join(", ") ?? '',
            data['steps']?.join("\n") ?? '',
          );
        }).toList();

        return favorites;
      } else {
        print("Failed to fetch favorites: ${response.body}");
        return [];
      }
    } catch (e) {
      print("Error fetching favorites: $e");
      return [];
    }
  }
  // Toggle favorite (Add/Remove)
  static Future<bool> toggleFavorite(int userId, int recipeId, bool isFavorite) async {
    final String url = "$baseUrl/api/favorites/$userId/$recipeId";

    try {
      final response = isFavorite
          ? await http.delete(Uri.parse(url)) // Remove from favorites
          : await http.post(                  // Add to favorites
        Uri.parse("$baseUrl/api/favorites"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"userId": userId, "recipeId": recipeId}),
      );

      if (response.statusCode == 200) {
        return true; // Success
      } else {
        print("Failed to toggle favorite: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error toggling favorite: $e");
      return false;
    }
  }



// Fetch Recommended Recipes
  static Future<List<Recipe>> fetchRecommendedRecipes(int userId) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api/recommended-recipes/$userId"));
      print("API Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        print("Decoded Recommended Recipes JSON: $jsonData");

        List<Recipe> recommendedRecipes = jsonData.map((data) {
          return Recipe(
            data['id']?? 0,
            data['title'] ?? '',
            data['description'] ?? '',
            data['image_url'] ?? '',
            data['calories'] ?? 0,
            data['protein'] ?? 0,
            data['prep_time'] ?? 0,
            data['ingredients']?.join(", ") ?? '',
            data['steps']?.join("\n") ?? '',
          );
        }).toList();

        return recommendedRecipes;
      } else {
        throw Exception("Failed to fetch recommended recipes, Status Code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching recommended recipes: $e");
      return [];
    }
  }
}

class User {
  final int auth_id;

  final String name;
  final String dietaryPreferences;
  final String healthGoal;
  final int age;
  final double height;
  final int weight;

  User({
    required this.auth_id,

    required this.name,
    required this.dietaryPreferences,
    required this.healthGoal,
    required this.age,
    required this.height,
    required this.weight,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      auth_id: json['auth_id']??0,

      name: json['name'] ?? '',
      dietaryPreferences: json['dietary_preferences'] ?? '',
      healthGoal: json['health_goal'] ?? '',
      age: json['age'] ?? 0,
      height: (json['height'] ?? 0).toDouble(),
      weight: json['weight'] ?? 0,
    );
  }
}

