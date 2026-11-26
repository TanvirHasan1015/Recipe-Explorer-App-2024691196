import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_api.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final MealApi _api = MealApi();

  // The controller lets us read the text the user typed.
  final TextEditingController _controller = TextEditingController();

  List<Meal> _meals = [];
  bool _isLoading = false;
  bool _hasSearched = false; // false until the user searches for the first time
  String? _errorMessage;

  // dispose runs when the screen closes. We free the controller here.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final query = _controller.text.trim(); // trim removes extra spaces
    if (query.isEmpty) return;             // do nothing if the box is empty

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _errorMessage = null;
    });

    try {
      final result = await _api.searchMeals(query);
      setState(() {
        _meals = result;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not search.\nCheck your internet connection.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          // The text box at the top.
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _search(), // search when the user presses Enter
              decoration: InputDecoration(
                hintText: 'Type a meal name, e.g. chicken',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _search, // search when the user taps the icon
                ),
              ),
            ),
          ),
          // Expanded gives the results all the remaining space.
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
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
            ElevatedButton(onPressed: _search, child: const Text('Retry')),
          ],
        ),
      );
    }

    // Before the first search, show a hint.
    if (!_hasSearched) {
      return const Center(child: Text('Search for a meal above.'));
    }

    // Searched, but nothing found -> clear message (required by the professor).
    if (_meals.isEmpty) {
      return const Center(child: Text('No meals found. Try another name.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _meals.length,
      itemBuilder: (context, index) {
        final meal = _meals[index];
        return MealCard(
          meal: meal,
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
    );
  }
}