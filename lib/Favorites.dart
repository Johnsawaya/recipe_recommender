import 'package:flutter/material.dart';
import 'package:recipe_recommender/services/api_service.dart';
import 'package:recipe_recommender/data.dart';
import 'package:recipe_recommender/card_widget.dart';
import 'package:recipe_recommender/detail.dart';  // Import the Detail screen

class Favorites extends StatefulWidget {
  final String username;
  Favorites({required this.username});

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  User? _user;
  String _errorMessage = '';
  List<Recipe> favoriteRecipes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  // Fetch user info and favorite recipes
  Future<void> _fetchUserInfo() async {
    try {
      User userData = await ApiService.getUserInfo(widget.username);
      setState(() {
        _user = userData;
        isLoading = false;
      });

      // Fetch favorite recipes after user data is available
      fetchFavoriteRecipes(userData);
    } catch (error) {
      setState(() {
        _errorMessage = "Failed to load user info";
        isLoading = false;
      });
    }
  }

  // Fetch favorite recipes from API
  void fetchFavoriteRecipes(User user) async {
    try {
      List<Recipe> recipes = await ApiService.fetchFavorites(user.auth_id);
      setState(() {
        favoriteRecipes = recipes;
      });
    } catch (e) {
      print("Error fetching favorites: $e");
      setState(() {
        _errorMessage = "Error fetching favorites";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Your Favorites"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Saved Recipes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),

            isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : favoriteRecipes.isEmpty
                ? Center(child: Text("No favorites yet!"))
                : Expanded(
              child: ListView.builder(
                itemCount: favoriteRecipes.length,
                itemBuilder: (context, index) {
                  Recipe recipe = favoriteRecipes[index];
                  return GestureDetector(
                    onTap: () {
                      if (_user != null) {
                        // Navigate to the detail screen with recipe and userId
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Detail(
                              recipe: recipe,
                              userId: _user!.auth_id,  // Passing user ID to the Detail screen
                            ),
                          ),
                        );
                      }
                    },
                    child: card_widget(
                      title: recipe.title,
                      calories: "${recipe.calories} kcal",
                      protein: "${recipe.protein} g",
                      prep_time: "${recipe.prepTime} min",
                      image_url: recipe.image,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

