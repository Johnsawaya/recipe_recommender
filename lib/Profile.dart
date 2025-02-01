import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
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
            Center(child: Icon(Icons.account_circle, size: 80, color: Colors.orangeAccent)),
            SizedBox(height: 12),

            Text("Name: John Doe", style: TextStyle(fontSize: 18)),
            Text("Email: johndoe@gmail.com", style: TextStyle(fontSize: 18)),
            Text("Diet: Vegan", style: TextStyle(fontSize: 18)),
            Text("Health Goal: Muscle Gain", style: TextStyle(fontSize: 18)),

            Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logout function
                },
                child: Text("Logout"),
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
