import 'package:flutter/material.dart';
import 'services/api_service.dart'; // Import the API service
import 'Design.dart'; // If you have custom design functions like buildTextTitleVariation1
import 'Login.dart';
const TextStyle kTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

class NewUser extends StatefulWidget {
  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String? selectedDiet;
  String? selectedGoal;

  bool _isLoading = false;

  List<String> dietOptions = ["Vegetarian", "Vegan", "Keto", "No Preference"];
  List<String> goalOptions = ["Weight Loss", "Muscle Gain", "Healthy Eating"];

  Future<void> registerUser() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty || _nameController.text.isEmpty || selectedDiet == null || selectedGoal == null || _ageController.text.isEmpty || _heightController.text.isEmpty || _weightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill in all fields")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Call the API to register the user (you will need to implement the API service)
      final response = await ApiService.registerUser(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        selectedDiet!,
        selectedGoal!,
        int.parse(_ageController.text),
        double.parse(_heightController.text),
        int.parse(_weightController.text),
      );

      print("Registration successful: $response");

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration Successful")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()),);

    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration failed")));
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
              buildTextTitleVariation1("Welcome to Recipe Recommender"),
              buildTextSubTitleVariation1("Let’s personalize your experience!"),
              SizedBox(height: 24),

              Text("Username", style: TextStyle(color: Colors.white)),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter your Username",
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
              SizedBox(height: 16),

              Text("Your Name", style: TextStyle(color: Colors.white)),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter your name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 16),

              Text("Age", style: TextStyle(color: Colors.white)),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter your age",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),

              Text("Height (cm)", style: TextStyle(color: Colors.white)),
              TextField(
                controller: _heightController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter your height in cm",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),

              Text("Body Weight",style: TextStyle(color: Colors.white)),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Enter your body weight",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),

              Text("Dietary Preference", style: TextStyle(color: Colors.white)),
              DropdownButtonFormField<String>(
                value: selectedDiet,
                items: dietOptions.map((diet) {
                  return DropdownMenuItem(
                    value: diet,
                    child: Text(diet),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDiet = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 16),

              Text("Health Goal", style: TextStyle(color: Colors.white)),
              DropdownButtonFormField<String>(
                value: selectedGoal,
                items: goalOptions.map((goal) {
                  return DropdownMenuItem(
                    value: goal,
                    child: Text(goal),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGoal = value;
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              SizedBox(height: 24),

              Center(
                child: ElevatedButton(
                  onPressed: _isLoading ? null : registerUser, // Disable button when loading
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text("Register", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
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
