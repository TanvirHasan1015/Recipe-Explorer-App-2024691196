import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';

// All saving and loading of favorites is in this one class.
class FavoritesStorage {
  // The "name of the drawer" where we keep the favorites on the phone.
  static const String _key = 'favorites';

  // Gets the list of saved favorite meals.
  Future<List<Meal>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    // If nothing is saved yet, we get null, so "?? []" gives an empty list.
    final List<String> saved = prefs.getStringList(_key) ?? [];
    // Each saved text is turned back into a Meal.
    return saved.map((text) => Meal.fromJson(jsonDecode(text))).toList();
  }

  // Saves the WHOLE list of favorites on the phone.
  Future<void> _saveAll(List<Meal> meals) async {
    final prefs = await SharedPreferences.getInstance();
    // Each Meal is turned into text, then the list of texts is saved.
    final texts = meals.map((meal) => jsonEncode(meal.toJson())).toList();
    await prefs.setStringList(_key, texts);
  }

  // Is this meal already a favorite? Returns true or false.
  Future<bool> isFavorite(String id) async {
    final favorites = await getFavorites();
    return favorites.any((meal) => meal.id == id);
  }

  // Adds a meal to favorites.
  Future<void> addFavorite(Meal meal) async {
    final favorites = await getFavorites();
    favorites.add(meal);
    await _saveAll(favorites);
  }

  // Removes a meal from favorites.
  Future<void> removeFavorite(String id) async {
    final favorites = await getFavorites();
    favorites.removeWhere((meal) => meal.id == id);
    await _saveAll(favorites);
  }
}