import 'package:flutter/material.dart';
import '../models/meal.dart';

// One row showing a meal: thumbnail + name.
// It is a widget on its own so we don't repeat the same code on 3 screens.
class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap; // what to do when the user taps the row

  const MealCard({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        // "leading" is the left side of the row: the thumbnail.
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8), // rounded corners
          child: Image.network(
            meal.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover, // fills the square without stretching
          ),
        ),
        title: Text(meal.name),
        onTap: onTap,
      ),
    );
  }
}