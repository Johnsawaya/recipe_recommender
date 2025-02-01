import 'package:flutter/material.dart';

import 'Design.dart';  // Assuming you have your design text styles in this file

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(Icons.menu, color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Notification click action
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              buildTextTitleVariation1("Welcome back!"),
              buildTextSubTitleVariation1("Ready to discover new recipes?"),
              SizedBox(height: 24),

              // Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for recipes...',
                    prefixIcon: Icon(Icons.search, color: kPrimaryColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.all(12),
                  ),
                ),
              ),
              SizedBox(height: 24),

              // Featured Recipe Section
              buildSectionTitle("Featured Recipes"),
              SizedBox(height: 16),
              _buildFeaturedRecipeCard("Spaghetti Bolognese", "assets/spaghetti.jpg", "Italian", "500 calories", "15 mins"),
              SizedBox(height: 24),

              // Recommended Recipe Section
              buildSectionTitle("Recommended For You"),
              SizedBox(height: 16),
              _buildRecommendedRecipeCard("Avocado Toast", "assets/avocado.jpg", "Vegan", "300 calories", "10 mins"),
              _buildRecommendedRecipeCard("Grilled Chicken Salad", "assets/grilled_chicken.jpg", "Low Carb", "400 calories", "20 mins"),
              SizedBox(height: 24),

              // Categories Section
              buildSectionTitle("Browse Categories"),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryCard("Vegan", "assets/vegan.jpg"),
                  _buildCategoryCard("Keto", "assets/keto.jpg"),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCategoryCard("Desserts", "assets/dessert.jpg"),
                  _buildCategoryCard("Healthy", "assets/healthy.jpg"),
                ],
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Widget for Section Titles
  Widget buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  // Custom Widget for Featured Recipe Card
  Widget _buildFeaturedRecipeCard(String title, String imageUrl, String category, String calories, String time) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imageUrl, width: 120, height: 120, fit: BoxFit.cover),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(category, style: TextStyle(fontSize: 14, color: Colors.grey)),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(time, style: TextStyle(fontSize: 14, color: Colors.grey)),
                  SizedBox(width: 16),
                  Icon(Icons.fastfood, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(calories, style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Custom Widget for Recommended Recipe Card
  Widget _buildRecommendedRecipeCard(String title, String imageUrl, String category, String calories, String time) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imageUrl, width: 100, height: 100, fit: BoxFit.cover),
          ),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text(category, style: TextStyle(fontSize: 14, color: Colors.grey)),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(time, style: TextStyle(fontSize: 14, color: Colors.grey)),
                  SizedBox(width: 16),
                  Icon(Icons.fastfood, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(calories, style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Custom Widget for Category Card
  Widget _buildCategoryCard(String category, String imageUrl) {
    return Container(
      width: (MediaQuery.of(context).size.width - 32) / 2 - 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(imageUrl, width: double.infinity, height: 100, fit: BoxFit.cover),
          ),
          SizedBox(height: 8),
          Text(category, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
