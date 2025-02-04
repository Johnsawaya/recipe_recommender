import 'package:flutter/material.dart';
import 'Design.dart';
import 'detail.dart';
import 'data.dart';
import 'services/api_service.dart';

class Explore extends StatefulWidget {
  final String username;
  Explore({required this.username});
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  List<Recipe> recipes = [];
  User? _user;
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchRecipes();
    _fetchUserInfo();
  }

  void fetchRecipes() async {
    List<Recipe> fetchedRecipes = await ApiService.getRecipes();
    setState(() {
      recipes = fetchedRecipes;
    });
  }

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

  // Function to check whether the image source is from the network or assets
  ImageProvider<Object> _getImageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);  // For URLs
    } else {
      return AssetImage(path);  // For local assets
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextTitleVariation1('Explore Recipes'),
                  buildTextSubTitleVariation1('Find your next meal idea'),
                ],
              ),
            ),
            SizedBox(height: 24),
            // First part: Show only the first 5 items horizontally
            Container(
              height: 350,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: recipes.length < 5 ? recipes.length : 5, // Show only 5 items
                itemBuilder: (context, index) {
                  return buildRecipe(recipes[index], index);
                },
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  buildTextTitleVariation2('Popular', false),
                  SizedBox(width: 8),
                  buildTextTitleVariation2('Food', true),
                ],
              ),
            ),
            // Second part: Show all the recipes vertically
            Container(
              height: 190,
              child: PageView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: recipes.length, // Show all recipes
                itemBuilder: (context, index) {
                  return buildPopular(recipes[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildRecipe(Recipe recipe, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Detail(recipe: recipe, userId: _user!.auth_id)),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [kBoxShadow],
        ),
        margin: EdgeInsets.only(right: 16, left: index == 0 ? 16 : 0, bottom: 16, top: 8),
        padding: EdgeInsets.all(16),
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Hero(
                tag: recipe.image,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _getImageProvider(recipe.image),  // Use the new function
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            buildRecipeTitle(recipe.title),
            buildTextSubTitleVariation2("${recipe.calories} Kcal | ${recipe.protein}g Protein | ${recipe.prepTime} min"),
          ],
        ),
      ),
    );
  }

  Widget buildPopular(Recipe recipe) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Detail(recipe: recipe, userId: _user!.auth_id)),
        );
      },
      child: Container(
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [kBoxShadow],
        ),
        child: Row(
          children: [
            Container(
              height: 160,
              width: 160,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: _getImageProvider(recipe.image),  // Use the new function
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRecipeTitle(recipe.title),
                    buildTextSubTitleVariation2("${recipe.calories} Kcal | ${recipe.protein}g Protein | ${recipe.prepTime} min"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
