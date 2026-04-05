import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/root_nav.dart';
import 'core/quantum_design.dart';
import 'core/favorites_provider.dart';
import 'core/ai_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => AIProvider()),
      ],
      child: const RecifyQuantumApp(),
    ),
  );
}

class RecifyQuantumApp extends StatelessWidget {
  const RecifyQuantumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Recify Quantum',
      theme: QuantumDesign.darkTheme,
      home: const RootNav(),
    );
  }
}