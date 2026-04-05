import 'package:flutter/material.dart';
import '../core/quantum_design.dart';
import '../data/recipe_repository.dart';
import '../domain/models.dart';
import 'recipe_card.dart';
import 'recipe_detail.dart';

class RecipeScreen extends StatefulWidget {
  const RecipeScreen({super.key});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  String _query = '';
  String _selectedCategory = 'Alle';
  late final List<Recipe> _recipes;
  late final List<String> _categories;

  @override
  void initState() {
    super.initState();
    _recipes = RecipeRepository.getItems();
    _categories = ['Alle', ...{..._recipes.map((r) => r.category)}];
  }

  List<Recipe> get _filteredRecipes {
    return _recipes.where((recipe) {
      final matchesQuery = recipe.name.toLowerCase().contains(_query.toLowerCase()) || recipe.description.toLowerCase().contains(_query.toLowerCase());
      final matchesCategory = _selectedCategory == 'Alle' || recipe.category == _selectedCategory;
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Rezeptsuche', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Finde gesunde Rezepte, kategorisiert nach Ziel, Geschmack und Wirkung.', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 18),
                TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white10,
                    hintText: 'Suchen nach Name, Wirkung oder Kategorie',
                    hintStyle: const TextStyle(color: Colors.white38),
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 38,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final selected = category == _selectedCategory;
                      return ChoiceChip(
                        label: Text(category),
                        selected: selected,
                        selectedColor: QuantumDesign.primary.withOpacity(0.24),
                        labelStyle: TextStyle(color: selected ? QuantumDesign.primary : Colors.white70),
                        backgroundColor: Colors.white10,
                        onSelected: (_) => setState(() => _selectedCategory = category),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredRecipes.isEmpty
                ? const Center(child: Text('Keine Rezepte gefunden', style: TextStyle(color: Colors.white70)))
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: _filteredRecipes.length,
                    itemBuilder: (context, index) {
                      final recipe = _filteredRecipes[index];
                      return RecipeCard(
                        recipe: recipe,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe)));
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
