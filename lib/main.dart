import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

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
      title: 'Tanvir Kitchen', // YOUR app name (used by the system)
      debugShowCheckedModeBanner: false, // hides the red DEBUG banner
      // ThemeData sets the colors of the whole app.
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const MainScreen(),
    );
  }
}