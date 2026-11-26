// Holds the data of ONE meal.
// The API gives different amounts of data in different places:
//  - the meal LIST gives only id, name and image
//  - the meal DETAIL gives everything (category, area, ingredients, instructions)
// So the extra fields use empty text ('') when the API doesn't send them.
class Meal {
  final String id;
  final String name;
  final String imageUrl;
  final String category;
  final String area;
  final String instructions;
  final List<String> ingredients; // already combined with measures, e.g. "3/4 cup soy sauce"

  Meal({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.category = '',     // optional, empty by default
    this.area = '',
    this.instructions = '',
    this.ingredients = const [],
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    // The API gives 20 separate ingredient fields (strIngredient1 ... strIngredient20).
    // We loop from 1 to 20 and keep only the ones that are not empty.
    final ingredients = <String>[];
    for (int i = 1; i <= 20; i++) {
      final name = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      // Unused fields are null or empty text, so we skip them.
      if (name != null && name.toString().trim().isNotEmpty) {
        // Join measure + name into one text, e.g. "1/2 cup water".
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
}