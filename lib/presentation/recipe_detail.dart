import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/favorites_provider.dart';
import '../core/quantum_design.dart';
import '../domain/models.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: QuantumDesign.cardBg,
        title: Text(recipe.name),
        actions: [
          Consumer<FavoritesProvider>(
            builder: (context, favorites, child) {
              final isFav = favorites.isFavorite(recipe);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.white70,
                ),
                onPressed: () => favorites.toggleFavorite(recipe),
              );
            },
          ),
        ],
      ),
      backgroundColor: QuantumDesign.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(recipe.category.toUpperCase(), style: const TextStyle(color: Colors.white38, letterSpacing: 1.5)),
            const SizedBox(height: 14),
            Text(recipe.description, style: const TextStyle(fontSize: 16, height: 1.4)),
            const SizedBox(height: 24),
            Text('Macros', style: TextStyle(color: QuantumDesign.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 12,
              children: recipe.macros.entries.map((entry) {
                return Chip(
                  backgroundColor: QuantumDesign.cardBg,
                  label: Text('${entry.key}: ${entry.value.toStringAsFixed(0)}g', style: const TextStyle(color: Colors.white)),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            Text('Health Benefits', style: TextStyle(color: QuantumDesign.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: recipe.benefits.map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(tag, style: const TextStyle(color: Colors.white70)),
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            Text('Ingredients', style: TextStyle(color: QuantumDesign.primary, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...recipe.ingredients.map((ingredient) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(color: QuantumDesign.primary)),
                  Expanded(child: Text(ingredient, style: const TextStyle(color: Colors.white70))),
                ],
              ),
            )),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.timer, color: QuantumDesign.primary, size: 18),
                const SizedBox(width: 8),
                Text('${recipe.durationMinutes} Minuten', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
