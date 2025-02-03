
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/api_service.dart';
import 'package:recipe_recommender/data.dart';
import 'card_widget.dart';
import 'Design.dart';
import 'detail.dart';

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
  Future<List<Recipe>>? recommendedRecipes;

  @override
  void initState() {
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
      });
    } catch (error) {
      setState(() {
        _errorMessage = "Failed to load user info";
        _isLoading = false;
      });
    }
  }

  // Function to calculate the user's daily calorie intake based on age, height, weight, and goal


  int _calculateCalories(User user) {
    double bmr;
    double calorieIntake;

    bmr = 10 * user.weight + 6.25 * user.height - 5 * user.age + 5;

    bmr = 10 * user.weight + 6.25 * user.height - 5 * user.age - 161;
    double TDEE = bmr * 1.55;
    if (user.healthGoal == "Weight Loss") {
      calorieIntake = TDEE - 500;
    } else if (user.healthGoal == "Muscle Gain") {
      calorieIntake = TDEE + 500;
    } else {
      calorieIntake = TDEE;
    }
    // Add activity level factor (for simplicity, we assume moderate activity level here)
    // Assuming moderate activity
    return calorieIntake.round();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      appBar: AppBar(
        title: Text("Welcome Back!!",textAlign: TextAlign.center,style: GoogleFonts.breeSerif(

          fontSize: 36,
          fontWeight: FontWeight.w900,
          color: Colors.white,
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Displaying User's Name and Goal with updated design
            _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Centered white container with bigger width
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9, // Set width to 90% of the screen
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 3,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildTextTitleVariation1("Hello ${widget.username}!"),
                        buildTextSubTitleVariation1(
                            "Your Health Goal: ${_user?.healthGoal ?? 'N/A'}"),
                        SizedBox(height: 12),
                        buildTextSubTitleVariation1(
                            "Your Calorie Intake: ${_calculateCalories(_user!)} kcal/day"),
                        SizedBox(height: 15),
                        buildTextSubTitleVariation1(
                            "Stay focused, eat clean, and crush your goals! 💪"),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
            // Button to generate meal plan
            Center(
              child: ElevatedButton(
                onPressed: () {
                  if (_user != null) {
                    setState(() {
                      recommendedRecipes =
                          ApiService.fetchRecommendedRecipes(_user!.auth_id);
                    });
                  }
                },
                child: Text("Generate Your Meal Plan", style: TextStyle(fontSize: 18,color: Colors.white)),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                  textStyle: MaterialStateProperty.all(TextStyle(fontSize: 18)),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Displaying Recommended Recipes
            Expanded(
              child: FutureBuilder<List<Recipe>>(
                future: recommendedRecipes,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error fetching recipes", style: TextStyle(color: Colors.red)));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("No recommended recipes found"));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final recipe = snapshot.data![index];
                      return GestureDetector(
                        onTap: () {
                          // Navigate to the Detail screen and pass the recipe data
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detail(recipe: recipe),
                            ),
                          );
                        },
                        child: card_widget(
                          title: recipe.title,
                          calories: "${recipe.calories} kcal",
                          protein: "${recipe.protein} g",
                          prep_time: "${recipe.prepTime} mins",
                          image_url: recipe.image,
                        ),
                      );
                    },
                  );
                },
              ),
            )

          ],
        ),
      ),
    );
  }

}
