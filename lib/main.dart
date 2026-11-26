import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

// main() is where every Flutter app starts.
void main() {
  runApp(const MyApp());
}

// The root of the app. It has no changing data, so it is a StatelessWidget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Explorer',
      // ThemeData sets the colors. We will personalize it in Step 10.
      theme: ThemeData(colorSchemeSeed: Colors.orange, useMaterial3: true),
      home: const HomeScreen(), // the first screen shown
    );
  }
}