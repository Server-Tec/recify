import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import '../domain/models.dart';

class AIService {
  final FlutterTts _flutterTts = FlutterTts();
  final ImageLabeler _imageLabeler = GoogleMlKit.vision.imageLabeler();

  // Zutaten-Erkennung aus Bild
  Future<List<String>> detectIngredients(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final labels = await _imageLabeler.processImage(inputImage);

      // Filtere nach Lebensmittel-bezogenen Labels
      final foodLabels = labels
          .where((label) => _isFoodRelated(label.label.toLowerCase()))
          .map((label) => label.label)
          .toList();

      return foodLabels;
    } catch (e) {
      print('Fehler bei Zutaten-Erkennung: $e');
      return [];
    }
  }

  // Prüft ob ein Label lebensmittelbezogen ist
  bool _isFoodRelated(String label) {
    final foodKeywords = [
      'food', 'fruit', 'vegetable', 'meat', 'dairy', 'grain', 'spice',
      'apple', 'banana', 'carrot', 'tomato', 'chicken', 'beef', 'milk',
      'rice', 'bread', 'cheese', 'egg', 'onion', 'garlic', 'potato'
    ];
    return foodKeywords.any((keyword) => label.contains(keyword));
  }

  // Rezept-Empfehlungen basierend auf Zutaten
  List<Recipe> recommendRecipes(List<String> availableIngredients, List<Recipe> allRecipes) {
    return allRecipes.where((recipe) {
      final recipeIngredients = recipe.ingredients
          .map((ing) => ing.toLowerCase())
          .toList();

      // Zähle übereinstimmende Zutaten
      final matches = availableIngredients.where((available) =>
          recipeIngredients.any((recipeIng) =>
              recipeIng.contains(available.toLowerCase()) ||
              available.toLowerCase().contains(recipeIng)
          )
      ).length;

      // Empfehle Rezepte mit mindestens 50% Zutaten-Übereinstimmung
      return matches >= (recipe.ingredients.length * 0.5);
    }).toList();
  }

  // Sprachausgabe für Kochanweisungen
  Future<void> speakRecipeInstructions(Recipe recipe) async {
    await _flutterTts.setLanguage("de-DE");
    await _flutterTts.setSpeechRate(0.8);
    await _flutterTts.setVolume(1.0);

    final instructions = '''
      Rezept: ${recipe.name}.
      Kategorie: ${recipe.category}.
      Zubereitungszeit: ${recipe.durationMinutes} Minuten.
      Zutaten: ${recipe.ingredients.join(', ')}.
      Beschreibung: ${recipe.description}.
      Gesundheitliche Vorteile: ${recipe.benefits.join(', ')}.
    ''';

    await _flutterTts.speak(instructions);
  }

  // Nährwert-Analyse und Empfehlungen
  Map<String, dynamic> analyzeNutrition(Recipe recipe) {
    final macros = recipe.macros;
    final protein = macros['protein'] ?? 0;
    final carbs = macros['carbs'] ?? 0;
    final fat = macros['fat'] ?? 0;

    final totalCalories = (protein * 4) + (carbs * 4) + (fat * 9);

    // Berechne Makro-Verteilung
    final proteinPercent = (protein * 4 / totalCalories) * 100;
    final carbsPercent = (carbs * 4 / totalCalories) * 100;
    final fatPercent = (fat * 9 / totalCalories) * 100;

    // KI-basierte Bewertung
    String rating;
    String recommendation;

    if (proteinPercent >= 25 && proteinPercent <= 35) {
      rating = 'Ausgezeichnet';
      recommendation = 'Optimale Protein-Verteilung für Muskelaufbau';
    } else if (proteinPercent >= 20) {
      rating = 'Gut';
      recommendation = 'Gute Protein-Quelle, aber achte auf Balance';
    } else {
      rating = 'Verbesserung möglich';
      recommendation = 'Erhöhe den Protein-Anteil für bessere Sättigung';
    }

    return {
      'totalCalories': totalCalories.round(),
      'proteinPercent': proteinPercent.round(),
      'carbsPercent': carbsPercent.round(),
      'fatPercent': fatPercent.round(),
      'rating': rating,
      'recommendation': recommendation,
      'insights': _generateNutritionInsights(recipe)
    };
  }

  // KI-basierte Nährwert-Einblicke
  List<String> _generateNutritionInsights(Recipe recipe) {
    final insights = <String>[];
    final macros = recipe.macros;
    final benefits = recipe.benefits;

    // Protein-Analyse
    if ((macros['protein'] ?? 0) > 20) {
      insights.add('Hoher Proteingehalt unterstützt Muskelaufbau und Sättigung');
    }

    // Kohlenhydrate-Analyse
    if ((macros['carbs'] ?? 0) < 30) {
      insights.add('Niedriger Kohlenhydratgehalt eignet sich für Low-Carb-Ernährung');
    }

    // Fett-Analyse
    if ((macros['fat'] ?? 0) > 15) {
      insights.add('Gesunde Fettquellen für Hormonproduktion und Zellgesundheit');
    }

    // Benefit-basierte Insights
    if (benefits.any((b) => b.toLowerCase().contains('brain'))) {
      insights.add('Dieses Rezept unterstützt die Gehirnfunktion durch BDNF-Boost');
    }

    if (benefits.any((b) => b.toLowerCase().contains('inflammation'))) {
      insights.add('Anti-entzündliche Eigenschaften für optimale Gesundheit');
    }

    return insights;
  }

  // Persönliche Mahlzeiten-Empfehlungen
  List<Recipe> getPersonalizedRecommendations(
    List<String> userPreferences,
    List<Recipe> allRecipes,
    List<String> favoriteCategories
  ) {
    return allRecipes.where((recipe) {
      final matchesPreferences = userPreferences.any((pref) =>
          recipe.benefits.any((benefit) =>
              benefit.toLowerCase().contains(pref.toLowerCase())
          )
      );

      final matchesCategories = favoriteCategories.contains(recipe.category);

      return matchesPreferences || matchesCategories;
    }).toList();
  }

  void dispose() {
    _imageLabeler.close();
  }
}