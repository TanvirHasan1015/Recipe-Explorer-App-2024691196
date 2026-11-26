import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/favorites_storage.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final FavoritesStorage _storage = FavoritesStorage();

  List<Meal> _meals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Reads the saved favorites from the phone.
  Future<void> _loadFavorites() async {
    final result = await _storage.getFavorites();
    setState(() {
      _meals = result;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // No favorites saved yet -> friendly message.
    if (_meals.isEmpty) {
      return const Center(child: Text('No favorites yet. Tap the heart on a recipe.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _meals.length,
      itemBuilder: (context, index) {
        final meal = _meals[index];
        return MealCard(
          meal: meal,
          // "async/await" here: wait until the user comes BACK from the detail
          // screen, then reload the list (in case they removed the heart).
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    MealDetailScreen(mealId: meal.id, mealName: meal.name),
              ),
            );
            _loadFavorites();
          },
        );
      },
    );
  }
}