import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Import the API service
import 'Design.dart';
import 'HomeScreen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> loginUser() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await ApiService.login(_usernameController.text, _passwordController.text);
      final username = _usernameController.text;
      print("Login successful: $response");

      // Navigate to home page or show success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(username: username)),); // Ensure you have a '/home' route defined

    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login failed")));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: back,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              buildTextTitleVariation1("Welcome "),
              buildTextSubTitleVariation1("Login to continue"),
              SizedBox(height: 24),

              Text("UserName", style: TextStyle(color: Colors.white)),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter your UserName",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),

              Text("Password", style: TextStyle(color: Colors.white)),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter your password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : loginUser, // Disable button when loading
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Login", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to registration page
                    Navigator.pushNamed(context, '/NewUser');
                  },
                  child: Text("Don't have an account? Register", style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

