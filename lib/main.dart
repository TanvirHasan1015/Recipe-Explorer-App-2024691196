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
      // ThemeData sets the colors of the whole app.
      // colorSchemeSeed: ONE color, and Flutter makes all the other colors from it.
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const MainScreen(),
    );
  }
}