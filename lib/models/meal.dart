// Holds the data of ONE meal.
class Meal {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String area;
  final String instructions;
  final List<String> ingredients; // measure + name, e.g. "3/4 cup soy sauce"

  Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.category = '',
    this.area = '',
    this.instructions = '',
    this.ingredients = const [],
  });

  // Builds a Meal from the JSON data of the API.
  factory Meal.fromJson(Map<String, dynamic> json) {
    // The API gives 20 separate ingredient fields.
    // We loop from 1 to 20 and keep only the ones that are not empty.
    final ingredients = <String>[];
    for (int i = 1; i <= 20; i++) {
      final name = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (name != null && name.toString().trim().isNotEmpty) {
        ingredients.add('${measure ?? ''} $name'.trim());
      }
    }

    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      imageUrl: json['strMealThumb'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      instructions: json['strInstructions'] ?? '',
      ingredients: ingredients,
    );
  }

  // NEW: turns a Meal into data we can save on the phone.
  // We save only id, name and image, because the Favorites list needs only those.
  // We use the same key names as the API, so fromJson can read it back.
  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': imageUrl,
    };
  }
}