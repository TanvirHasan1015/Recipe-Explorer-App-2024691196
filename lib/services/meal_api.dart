import 'dart:convert'; // gives us jsonDecode, to turn text into a Map/List
import 'package:http/http.dart' as http; // the package that makes web requests
import '../models/category.dart';

// All internet calls live in this one class (professor's rule),
// so the screens never contain API code.
class MealApi {
  // The start of every URL. We add the end part for each request.
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  // "Future<List<Category>>" means: "later, I will give you a list of Categories".
  // "async" lets us use "await" to wait for the internet without freezing the app.
  Future<List<Category>> fetchCategories() async {
    // Send a GET request and WAIT for the answer.
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));

    // 200 means success. Anything else is a problem, so we throw an error.
    // The screen will catch it and show the error message + Retry button.
    if (response.statusCode != 200) {
      throw Exception('Failed to load categories');
    }

    // Turn the JSON text into a Map we can read.
    final data = jsonDecode(response.body);

    // The categories are inside the key "categories".
    final List list = data['categories'];

    // Turn each JSON item into a Category object, then make a list.
    return list.map((json) => Category.fromJson(json)).toList();
  }
}