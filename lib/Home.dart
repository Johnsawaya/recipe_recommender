import 'package:flutter/material.dart';
import 'services/api_service.dart';
import 'package:recipe_recommender/data.dart';
import 'card_widget.dart';

class Home extends StatefulWidget {
  final String username; // Pass the logged-in username

  Home({required this.username});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? _user;
  bool _isLoading = true;
  String _errorMessage = '';
  late Future<List<Recipe>> recommendedRecipes;

  @override
  void initState() {
    print(widget.username);
    super.initState();

    _fetchUserInfo();


  }
  // Fetch user info from API
  Future<void> _fetchUserInfo() async {
    try {
      User userData = await ApiService.getUserInfo(widget.username);
      setState(() {
        _user = userData;
        _isLoading = false;
        recommendedRecipes = ApiService.fetchRecommendedRecipes(userData.auth_id);
      });
    } catch (error) {
      setState(() {
        _errorMessage = "Failed to load user info";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Welcome Back!"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Personalized Recipes",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Recipe>>(
                future: recommendedRecipes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error fetching recipes"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No recommended recipes found"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final recipe = snapshot.data![index];
                      return card_widget(
                        title: recipe.title,
                        calories: "${recipe.calories} kcal",
                        protein: "${recipe.protein} g",
                        prep_time: "${recipe.prepTime} mins",
                        image_url: recipe.image,
                      );
                    },
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
