import 'dart:convert'; // gives us jsonDecode, to turn text into a Map/List

import 'package:http/http.dart' as http; // the package that makes web requests

import '../models/category.dart';
import '../models/meal.dart';

// All internet calls live in this one class (professor's rule),
// so the screens never contain API code.
class MealApi {
  // The start of every URL. We add the end part for each request.
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // Gets all the categories (Beef, Chicken, Seafood...).
  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));

    // 200 means success. Anything else is a problem, so we throw an error.
    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }

    final data = jsonDecode(response.body);
    final List list = data['categories'];
    return list.map((json) => Category.fromJson(json)).toList();
  }

  // Gets the meals of ONE category, e.g. "Seafood".
  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response =
    await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load meals');
    }

    final data = jsonDecode(response.body);

    // If nothing is found, the API gives {"meals": null}.
    // We must check for null, otherwise the app crashes.
    final List? list = data['meals'];
    if (list == null) {
      return [];
    }

    return list.map((json) => Meal.fromJson(json)).toList();
  }

  // Gets ALL the details of ONE meal using its id.
  Future<Meal> fetchMealDetail(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/lookup.php?i=$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to load meal');
    }

    final data = jsonDecode(response.body);
    final List? list = data['meals'];

    if (list == null || list.isEmpty) {
      throw Exception('Meal not found');
    }

    // The API gives a list with only 1 meal, so we take the first one.
    return Meal.fromJson(list[0]);
  }

  // NEW: searches meals by name, e.g. "chicken".
  Future<List<Meal>> searchMeals(String query) async {
    // encodeComponent makes the text safe for a URL (a space becomes %20).
    final response = await http
        .get(Uri.parse('$baseUrl/search.php?s=${Uri.encodeComponent(query)}'));

    if (response.statusCode != 200) {
      throw Exception('Failed to search meals');
    }

    final data = jsonDecode(response.body);

    // Nothing found -> {"meals": null}. We return an empty list.
    final List? list = data['meals'];
    if (list == null) {
      return [];
    }

    return list.map((json) => Meal.fromJson(json)).toList();
  }
}