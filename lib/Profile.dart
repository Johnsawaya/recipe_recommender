import 'package:flutter/material.dart';
import 'package:recipe_recommender/services/api_service.dart';  // Import the API service
import 'package:recipe_recommender/data.dart';  // Import the User and other necessary data models
import 'login.dart';

class Profile extends StatefulWidget {
  final String username;
  Profile({required this.username});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? _user;
  String _errorMessage = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  // Fetch user info from the API
  Future<void> _fetchUserInfo() async {
    try {
      User userData = await ApiService.getUserInfo(widget.username);
      setState(() {
        _user = userData;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        _errorMessage = "Failed to load user info";
        isLoading = false;
      });
    }
  }

  // Logout function to navigate to the Login page
  void _logout() {
    // You can clear any saved login data or authentication tokens here if necessary
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),  // Navigate to LoginPage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text("Your Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            isLoading
                ? Center(child: CircularProgressIndicator()) // Show loading indicator
                : _user == null
                ? Center(child: Text(_errorMessage)) // Show error message if user data is not available
                : Column(
              children: [
                Center(child: Icon(Icons.account_circle, size: 80, color: Colors.orangeAccent)),
                SizedBox(height: 12),
                Text("Name: ${_user!.name}", style: TextStyle(fontSize: 18)),


                Text("Health Goal: ${_user!.healthGoal}", style: TextStyle(fontSize: 18)),
                Text("Age: ${_user!.age}", style: TextStyle(fontSize: 18)),
                Text("Height: ${_user!.height}", style: TextStyle(fontSize: 18)),
                Text("Weight: ${_user!.weight}", style: TextStyle(fontSize: 18)),
                Text("Diet: ${_user!.dietaryPreferences}", style: TextStyle(fontSize: 18)),
              ],
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                child: Text("Logout", style: TextStyle(color: Colors.white)), // Set the text color to white
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

