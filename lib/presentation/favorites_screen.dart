import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/favorites_provider.dart';
import 'recipe_detail.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favorites, child) {
        final favoriteRecipes = favorites.getFavorites();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: const Color(0xFF0A0A0A),
            title: const Text('Favoriten'),
          ),
          backgroundColor: const Color(0xFF020202),
          body: favoriteRecipes.isEmpty
              ? const Center(
                  child: Text(
                    'Keine Favoriten gespeichert',
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: favoriteRecipes.length,
                  itemBuilder: (context, index) {
                    final recipe = favoriteRecipes[index];
                    return Card(
                      color: const Color(0xFF0A0A0A),
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      child: ListTile(
                        title: Text(recipe.name, style: const TextStyle(color: Colors.white)),
                        subtitle: Text(recipe.category, style: const TextStyle(color: Colors.white70)),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RecipeDetailScreen(recipe: recipe),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}
