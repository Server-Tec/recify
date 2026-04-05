import 'package:flutter/material.dart';
import '../domain/models.dart';
import '../data/recipe_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  final Set<String> _favorites = {};
  final List<Recipe> _allRecipes = RecipeRepository.getItems();

  List<Recipe> get allRecipes => _allRecipes;

  bool isFavorite(Recipe recipe) => _favorites.contains(recipe.name);

  void toggleFavorite(Recipe recipe) {
    if (isFavorite(recipe)) {
      _favorites.remove(recipe.name);
    } else {
      _favorites.add(recipe.name);
    }
    notifyListeners();
  }

  List<Recipe> getFavorites() {
    return _allRecipes.where((recipe) => isFavorite(recipe)).toList();
  }

  List<String> getFavoriteCategories() {
    final favoriteRecipes = getFavorites();
    return favoriteRecipes.map((recipe) => recipe.category).toSet().toList();
  }
}
