import 'package:flutter/material.dart';
import 'package:petprojectsbookingapp/src/features/auth/presentation/pages/login_page.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LogRegScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/jihc.jpeg', width: 120, height: 120),
            SizedBox(height: 20),
            Text(
              'Booking app',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Book and use time for happy',
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(color: Colors.blue),
          ],
        ),
      ),
    );
  }
}
