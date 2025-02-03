import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login.dart';
import 'NewUser.dart';
import 'HomeScreen.dart';
void main() {
runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Flutter Demo',
theme: ThemeData(
primarySwatch: Colors.blue,
visualDensity: VisualDensity.adaptivePlatformDensity,
textTheme: GoogleFonts.montserratTextTheme(),
),
debugShowCheckedModeBanner: false,
  initialRoute: '/',
  routes: {
     // Login page route
    '/NewUser': (context) => NewUser(), // New user registration route
     // Home page route
    //'/HomeScreen':(context)=>HomeScreen(),
  },
home: Login(),
);
}
}