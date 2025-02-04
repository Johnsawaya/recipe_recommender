import 'package:flutter/material.dart';
import 'Design.dart';
import 'data.dart';
import 'services/api_service.dart';  // Import API service

class Detail extends StatefulWidget {
  final Recipe recipe;
  final int userId; // Pass userId to track favorites

  Detail({required this.recipe, required this.userId});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  bool isFavorite = false; // Track favorite status

  @override
  void initState() {
    super.initState();
    checkIfFavorite();
  }

  // Check if recipe is already a favorite
  void checkIfFavorite() async {
    bool favoriteStatus = await ApiService.isFavorite(widget.userId, widget.recipe.id);
    setState(() {
      isFavorite = favoriteStatus;
    });
  }

  // Toggle favorite status (Add/Remove)
  void toggleFavorite() async {
    bool success = await ApiService.toggleFavorite(widget.userId, widget.recipe.id, isFavorite);
    if (success) {
      setState(() {
        isFavorite = !isFavorite; // Toggle state on success
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: toggleFavorite,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextTitleVariation1(widget.recipe.title),
                  buildTextSubTitleVariation1(widget.recipe.description),
                ],
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 310,
              padding: EdgeInsets.only(left: 16),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildTextTitleVariation2('Nutritions', false),
                      SizedBox(height: 16),
                      buildNutrition(widget.recipe.calories, "Calories", "Kcal"),
                      SizedBox(height: 16),
                      buildNutrition(widget.recipe.prepTime, "Time", "min"),
                      SizedBox(height: 16),
                      buildNutrition(widget.recipe.protein, "Protein", "g"),
                    ],
                  ),
                  Positioned(
                    right: -80,
                    child: Hero(
                      tag: widget.recipe.image,
                      child: Container(
                        height: 310,
                        width: 310,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: _getImageProvider(widget.recipe.image), // Use our custom image provider
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildTextTitleVariation2('Ingredients', false),
                  buildTextSubTitleVariation1(widget.recipe.Ingredients),
                  SizedBox(height: 16),
                  buildTextTitleVariation2('Recipe Description', false),
                  buildTextSubTitleVariation1(widget.recipe.description),
                  SizedBox(height: 16),
                  buildTextTitleVariation2('Recipe preparation', false),
                  buildTextSubTitleVariation1(widget.recipe.steps),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNutrition(int value, String title, String subTitle) {
    return Container(
      height: 60,
      width: 150,
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.all(Radius.circular(50)),
        boxShadow: [kBoxShadow],
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [kBoxShadow],
            ),
            child: Center(
              child: Text(
                value.toString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text(subTitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[400])),
            ],
          ),
        ],
      ),
    );
  }

  // Function to check whether the image source is from the network or assets
  ImageProvider<Object> _getImageProvider(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);  // For URLs
    } else {
      return AssetImage(path);  // For local assets
    }
  }
}
