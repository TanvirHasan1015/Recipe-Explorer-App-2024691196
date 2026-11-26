import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/meal_api.dart';
import 'meal_list_screen.dart';
import 'search_screen.dart';

// StatefulWidget because the screen CHANGES: loading -> data, or loading -> error.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MealApi _api = MealApi();

  // These 3 variables are the "state" of the screen.
  List<Category> _categories = [];   // the data we loaded
  bool _isLoading = true;            // true while waiting for the internet
  String? _errorMessage;             // null = no error. "?" means it can be null.

  // initState runs ONCE when the screen is first created.
  // It is the right place to start loading data.
  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    // Show the loading spinner and clear any old error.
    // setState tells Flutter: "my data changed, redraw the screen".
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Wait for the API. If the internet is off, this line throws an error.
      final result = await _api.fetchCategories();
      setState(() {
        _categories = result;
        _isLoading = false;
      });
    } catch (e) {
      // "catch" stops the app from crashing and lets us show a friendly message.
      setState(() {
        _errorMessage = 'Could not load categories.\nCheck your internet connection.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Explorer'),
        actions: [
          // TEMPORARY: opens Search. We remove this in Step 9.
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  // We choose what to show depending on the state.
  Widget _buildBody() {
    // 1) Still loading -> spinner
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2) Error -> message + Retry button
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadCategories, // try again
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // 3) Success -> grid of categories
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      // 2 columns. Spacing is the gap between the items.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: _categories.length,
      // itemBuilder is called once for each item in the grid.
      itemBuilder: (context, index) {
        final category = _categories[index];
        return Card(
          child: InkWell(
            // InkWell makes the card tappable. We will open the meal list in Step 5.
            onTap: () {
              // Navigator.push opens a NEW screen on top of this one.
              // We pass the category name so the next screen knows what to load.
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MealListScreen(categoryName: category.name),
                ),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image.network shows a picture from a URL.
                Image.network(category.imageUrl, height: 90),
                const SizedBox(height: 8),
                Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}