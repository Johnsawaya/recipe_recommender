import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:recipe_recommender/data.dart';

class ApiService {
  static const String baseUrl = "https://recipe-recommender-backend-hfxt.onrender.com";

  // User Authentication
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to login");
    }
  }

  // Fetch User Info

  // Register user (post to the backend)
  static Future<String> registerUser(
      String email,
      String password,
      String name,
      String dietPreference,
      String healthGoal,
      int age,
      double height,
      int dailyCalories) async {
    final response = await http.post(
      Uri.parse("$baseUrl/api/register"),
      body: json.encode({
        'email': email,
        'password': password,
        'name': name,
        'dietary_preferences': dietPreference,
        'health_goal': healthGoal,
        'age': age,
        'height': height,
        'daily_calories': dailyCalories,
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




}
