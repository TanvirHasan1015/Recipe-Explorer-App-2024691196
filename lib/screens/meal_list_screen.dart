import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_api.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class MealListScreen extends StatefulWidget {
  // The category the user tapped, passed from the Home screen.
  final String categoryName;

  const MealListScreen({super.key, required this.categoryName});

  @override
  State<MealListScreen> createState() => _MealListScreenState();
}

class _MealListScreenState extends State<MealListScreen> {
  final MealApi _api = MealApi();

  // Same 3 state variables as the Home screen.
  List<Meal> _meals = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // "widget.categoryName" reads the value passed into this screen.
      final result = await _api.fetchMealsByCategory(widget.categoryName);
      setState(() {
        _meals = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not load meals.\nCheck your internet connection.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The app bar shows the category name, e.g. "Seafood".
      appBar: AppBar(title: Text(widget.categoryName)),
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
            ElevatedButton(onPressed: _loadMeals, child: const Text('Retry')),
          ],
        ),
      );
    }

    // A scrolling list of meals. Pulling it down loads the meals again.
    return RefreshIndicator(
      onRefresh: _loadMeals,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        itemCount: _meals.length,
        itemBuilder: (context, index) {
          final meal = _meals[index];
          return MealCard(
            meal: meal,
            // When the user taps a meal, open its detail screen.
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MealDetailScreen(mealId: meal.id, mealName: meal.name),
                ),
              );
            },
          );
        },
      ),
    );
  }
}