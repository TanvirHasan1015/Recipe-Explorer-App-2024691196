import 'package:flutter/material.dart';

// A simple screen with no changing data, so it is a StatelessWidget.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // CircleAvatar shows the photo inside a circle.
            // AssetImage reads the photo from the "assets" folder.
            const CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
            const SizedBox(height: 16),
            // CHANGE these two lines to your real name and student ID.
            const Text(
              'Your Full Name',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text('Student ID: Your Student ID'),
            const SizedBox(height: 8),
            const Text('Tanvir Kitchen - Mobile App Design Final Project'),
          ],
        ),
      ),
    );
  }
}