import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../core/ai_provider.dart';
import '../core/favorites_provider.dart';
import '../domain/models.dart';
import 'recipe_detail.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  State<AIScreen> createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI-Assistent'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<AIProvider>(
        builder: (context, aiProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureCard(
                  'Zutaten-Erkennung',
                  'Mache ein Foto deiner Zutaten und erhalte Rezeptvorschläge',
                  Icons.camera_alt,
                  () => _pickImageAndAnalyze(aiProvider),
                  aiProvider.isAnalyzingImage,
                ),
                const SizedBox(height: 16),

                if (aiProvider.detectedIngredients.isNotEmpty) ...[
                  _buildDetectedIngredients(aiProvider),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => aiProvider.recommendRecipesFromIngredients(
                      context.read<FavoritesProvider>().allRecipes,
                    ),
                    child: const Text('Rezepte empfehlen'),
                  ),
                ],

                if (aiProvider.recommendedRecipes.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  const Text(
                    'Empfohlene Rezepte',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ...aiProvider.recommendedRecipes.map((recipe) =>
                    _buildRecipeCard(recipe, context)
                  ),
                ],

                const SizedBox(height: 24),
                _buildFeatureCard(
                  'Nährwert-Analyse',
                  'Erhalte detaillierte Nährwert-Informationen zu Rezepten',
                  Icons.analytics,
                  () => _showNutritionDialog(context),
                  false,
                ),

                const SizedBox(height: 16),
                _buildFeatureCard(
                  'Sprachausgabe',
                  'Lass dir Rezepte vorlesen',
                  Icons.volume_up,
                  () => _showVoiceDialog(context, aiProvider),
                  false,
                ),

                const SizedBox(height: 16),
                _buildFeatureCard(
                  'Persönliche Empfehlungen',
                  'Erhalte maßgeschneiderte Rezeptvorschläge',
                  Icons.recommend,
                  () => _showPersonalizedDialog(context, aiProvider),
                  false,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeatureCard(String title, String description, IconData icon,
      VoidCallback onTap, bool isLoading) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(icon, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetectedIngredients(AIProvider aiProvider) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Erkannte Zutaten:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: aiProvider.detectedIngredients.map((ingredient) =>
                Chip(
                  label: Text(ingredient),
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                )
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe, BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        title: Text(recipe.name),
        subtitle: Text('${recipe.category} • ${recipe.durationMinutes} min'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipe),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickImageAndAnalyze(AIProvider aiProvider) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      await aiProvider.analyzeImageForIngredients(image.path);
    }
  }

  void _showNutritionDialog(BuildContext context) {
    final allRecipes = context.read<FavoritesProvider>().allRecipes;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nährwert-Analyse'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allRecipes.length,
            itemBuilder: (context, index) {
              final recipe = allRecipes[index];
              return ListTile(
                title: Text(recipe.name),
                subtitle: Text(recipe.category),
                onTap: () {
                  context.read<AIProvider>().analyzeRecipeNutrition(recipe);
                  Navigator.pop(context);
                  _showNutritionResult(context);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  void _showNutritionResult(BuildContext context) {
    final analysis = context.read<AIProvider>().nutritionAnalysis;
    if (analysis == null) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nährwert-Analyse'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Kalorien: ${analysis['totalCalories']} kcal'),
              const SizedBox(height: 8),
              Text('Protein: ${analysis['proteinPercent']}%'),
              Text('Kohlenhydrate: ${analysis['carbsPercent']}%'),
              Text('Fett: ${analysis['fatPercent']}%'),
              const SizedBox(height: 16),
              Text('Bewertung: ${analysis['rating']}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(analysis['recommendation']),
              const SizedBox(height: 16),
              const Text('KI-Einblicke:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...List<String>.from(analysis['insights']).map((insight) =>
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('• $insight'),
                )
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  void _showVoiceDialog(BuildContext context, AIProvider aiProvider) {
    final allRecipes = context.read<FavoritesProvider>().allRecipes;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sprachausgabe'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: allRecipes.length,
            itemBuilder: (context, index) {
              final recipe = allRecipes[index];
              return ListTile(
                title: Text(recipe.name),
                subtitle: Text(recipe.category),
                onTap: () async {
                  Navigator.pop(context);
                  await aiProvider.speakRecipe(recipe);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Rezept wird vorgelesen...')),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }

  void _showPersonalizedDialog(BuildContext context, AIProvider aiProvider) {
    final favoriteCategories = context.read<FavoritesProvider>().getFavoriteCategories();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Persönliche Empfehlungen'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Basierend auf deinen Favoriten:'),
            const SizedBox(height: 8),
            Text(favoriteCategories.join(', ')),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                aiProvider.getPersonalizedRecommendations(
                  ['brain', 'energy', 'muscle'], // Beispiel-Präferenzen
                  context.read<FavoritesProvider>().allRecipes,
                  favoriteCategories,
                );
                Navigator.pop(context);
              },
              child: const Text('Empfehlungen generieren'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
        ],
      ),
    );
  }
}