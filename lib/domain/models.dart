class Recipe {
  final String name;
  final String category;
  final Map<String, double> macros; // Protein, Carbs, Fat
  final List<String> benefits;
  final List<String> ingredients;
  final String description;
  final int durationMinutes;

  const Recipe({
    required this.name,
    required this.category,
    required this.macros,
    required this.benefits,
    required this.ingredients,
    required this.description,
    required this.durationMinutes,
  });
}
