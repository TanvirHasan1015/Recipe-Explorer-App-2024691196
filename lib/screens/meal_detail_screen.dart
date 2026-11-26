import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_api.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;   // used to ask the API for the full recipe
  final String mealName; // shown in the app bar while loading

  const MealDetailScreen({
    super.key,
    required this.mealId,
    required this.mealName,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final MealApi _api = MealApi();

  Meal? _meal;            // null until the data arrives
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMeal();
  }

  Future<void> _loadMeal() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _api.fetchMealDetail(widget.mealId);
      setState(() {
        _meal = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not load the recipe.\nCheck your internet connection.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.mealName)),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loadMeal, child: const Text('Retry')),
          ],
        ),
      );
    }

    final meal = _meal!; // "!" means: we know it is not null here

    // SingleChildScrollView lets the screen scroll when the text is long.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(meal.imageUrl),
          const SizedBox(height: 12),
          Text(meal.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text('Category: ${meal.category}'),
          Text('Area: ${meal.area}'),
          const SizedBox(height: 16),
          const Text('Ingredients',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          // This "for" shows one Text for each ingredient.
          for (final item in meal.ingredients) Text('• $item'),
          const SizedBox(height: 16),
          const Text('Instructions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(meal.instructions),
        ],
      ),
    );
  }
}