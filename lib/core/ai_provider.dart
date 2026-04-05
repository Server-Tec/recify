import 'package:flutter/foundation.dart';
import 'ai_service.dart';
import '../domain/models.dart';

class AIProvider with ChangeNotifier {
  final AIService _aiService = AIService();

  List<String> _detectedIngredients = [];
  List<Recipe> _recommendedRecipes = [];
  bool _isAnalyzingImage = false;
  Map<String, dynamic>? _nutritionAnalysis;

  // Getter
  List<String> get detectedIngredients => _detectedIngredients;
  List<Recipe> get recommendedRecipes => _recommendedRecipes;
  bool get isAnalyzingImage => _isAnalyzingImage;
  Map<String, dynamic>? get nutritionAnalysis => _nutritionAnalysis;

  // Zutaten aus Bild erkennen
  Future<void> analyzeImageForIngredients(String imagePath) async {
    _isAnalyzingImage = true;
    notifyListeners();

    try {
      _detectedIngredients = await _aiService.detectIngredients(imagePath);
      notifyListeners();
    } catch (e) {
      print('Fehler bei Bildanalyse: $e');
    } finally {
      _isAnalyzingImage = false;
      notifyListeners();
    }
  }

  // Rezepte basierend auf erkannten Zutaten empfehlen
  void recommendRecipesFromIngredients(List<Recipe> allRecipes) {
    if (_detectedIngredients.isNotEmpty) {
      _recommendedRecipes = _aiService.recommendRecipes(_detectedIngredients, allRecipes);
      notifyListeners();
    }
  }

  // Nährwert-Analyse für ein Rezept
  void analyzeRecipeNutrition(Recipe recipe) {
    _nutritionAnalysis = _aiService.analyzeNutrition(recipe);
    notifyListeners();
  }

  // Sprachausgabe für Rezept
  Future<void> speakRecipe(Recipe recipe) async {
    await _aiService.speakRecipeInstructions(recipe);
  }

  // Persönliche Empfehlungen
  void getPersonalizedRecommendations(
    List<String> userPreferences,
    List<Recipe> allRecipes,
    List<String> favoriteCategories
  ) {
    _recommendedRecipes = _aiService.getPersonalizedRecommendations(
      userPreferences,
      allRecipes,
      favoriteCategories
    );
    notifyListeners();
  }

  // Zutaten zurücksetzen
  void clearDetectedIngredients() {
    _detectedIngredients.clear();
    _recommendedRecipes.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _aiService.dispose();
    super.dispose();
  }
}