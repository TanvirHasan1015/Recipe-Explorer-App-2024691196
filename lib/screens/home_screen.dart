import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/meal_api.dart';
import 'about_screen.dart';
import 'meal_list_screen.dart';

// StatefulWidget because the screen CHANGES: loading -> data, or loading -> error.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MealApi _api = MealApi();

  // These 3 variables are the "state" of the screen.
  List<Category> _categories = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await _api.fetchCategories();
      setState(() {
        _categories = result;
        _isLoading = false;
      });
    } catch (e) {
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
        centerTitle: true, // puts the title in the center
        // "leading" is the LEFT side of the app bar, so the icon goes there.
        leading: IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () {
            // Open the About screen.
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutScreen()),
            );
          },
        ),
        title: const Text('Tanvir Kitchen'), // YOUR app name
      ),
      body: _buildBody(),
    );
  }

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
              onPressed: _loadCategories,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // 3) Success -> grid of categories
    // RefreshIndicator: pulling the list down runs onRefresh (loads the data again).
    return RefreshIndicator(
      onRefresh: _loadCategories,
      child: GridView.builder(
        // Lets the user pull down even when everything fits on the screen.
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // number of columns
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return Card(
            child: InkWell(
              onTap: () {
                // Open the meal list and pass the category name.
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
      ),
    );
  }
}