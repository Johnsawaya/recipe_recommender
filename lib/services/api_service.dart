import 'dart:convert';
import 'package:http/http.dart' as http;

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

  // Fetch Recipes
  static Future<List<dynamic>> getRecipes() async {
    final response = await http.get(Uri.parse("$baseUrl/recipes"));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch recipes");
    }
  }
}
