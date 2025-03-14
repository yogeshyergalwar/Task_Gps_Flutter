import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mil/screens/landing_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.teal,
        secondaryHeaderColor: Colors.blue.shade900,
        fontFamily: 'Georgia',
        textTheme: TextTheme(
          //For App Bar
          labelSmall: GoogleFonts.poppins(
            color: Colors.white,
            // fontFamily: 'Raleway',
            fontSize: 17.0,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),

          displayLarge: GoogleFonts.poppins(
            color: Colors.black,
            // fontFamily: 'Roboto-Light',
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            height: 2,
          ),
          //Need to use for Sub Headings
          displayMedium: GoogleFonts.poppins(
            color: Colors.black,
            // fontFamily: 'Roboto-Light',
            fontSize: 16.0,
            letterSpacing: 1,
            // fontWeight: FontWeight.w800,
            height: 1.5,
          ),
          // Using for Profile Card Page 2
          displaySmall: GoogleFonts.poppins(
            color: Colors.black,
            // fontFamily: 'Roboto-Light',
            fontSize: 16.0,
            // fontWeight: FontWeight.w500,
            height: 1.5,
          ),
          // For Drop Down
          headlineMedium: GoogleFonts.poppins(
            color: Colors.black,
            // fontFamily: 'Roboto-Light',
            fontSize: 14.0,
            // fontWeight: FontWeight.w800,
            height: 1.5,
          ),
          // For List Items
          headlineSmall: GoogleFonts.poppins(
            color: Colors.grey,
            // fontFamily: 'Roboto-Light',
            fontSize: 16.0,
            // fontWeight: FontWeight.w700,
            height: 1.5,
          ),
          labelLarge: GoogleFonts.poppins(
            color: Colors.white,
            // fontFamily: 'Roboto-Light',
            fontSize: 14.0,
            // fontWeight: FontWeight.w800,
            height: 1.5,
          ),
          bodyLarge: GoogleFonts.poppins(
              fontSize: 16.0,
              height: 1.5,
              letterSpacing: 1.0,
              color: Colors.blue),
          bodyMedium: GoogleFonts.poppins(
              fontSize: 16.0,
              height: 1.5,
              letterSpacing: 1.0,
              color: Colors.black),
          titleLarge: GoogleFonts.poppins(
            color: Colors.white,
            // fontFamily: 'Roboto-Light',
            fontSize: 14.0,
            // fontWeight: FontWeight.w800,
            height: 1.5,
          ),
        ),
        appBarTheme: ThemeData.light().appBarTheme.copyWith(
              backgroundColor: Color(0xffc3a952),
            ),
      ),
      home: LandingScreen(),
    );
  }
}
