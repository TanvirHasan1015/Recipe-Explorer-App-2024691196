// A "model" is a class that holds the data of ONE thing.
// Here: one meal category (Beef, Chicken, Seafood...).
// Widgets will use this class instead of raw JSON, as the professor requires.
class Category {
  final String id;
  final String name;
  final String imageUrl;
  final String description;

  // "required" means we must give every value when creating a Category.
  Category({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  // A "factory constructor" builds a Category from JSON data.
  // The API gives us a Map (key -> value), and we pick the keys we need.
  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['idCategory'],
      name: json['strCategory'],
      imageUrl: json['strCategoryThumb'],
      // "?? ''" means: if the value is null, use an empty text instead.
      // This protects the app from crashing on null.
      description: json['strCategoryDescription'] ?? '',
    );
  }
}