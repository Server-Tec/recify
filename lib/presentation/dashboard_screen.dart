import 'package:flutter/material.dart';
import '../core/quantum_design.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 60),
        const Text("SYSTEM STATUS: OPTIMAL", style: TextStyle(letterSpacing: 4, color: QuantumDesign.primary)),
        const SizedBox(height: 30),

        // Stat-Balken mit reinen Widgets
        _buildStatBar("INSULIN SENSITIVITY", 0.85),
        _buildStatBar("GENETIC MATCH RATE", 0.94),
        _buildStatBar("CELLULAR HYDRATION", 0.72),

        const SizedBox(height: 40),
        AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                height: 150,
                decoration: QuantumDesign.glassNode.copyWith(
                  boxShadow: [
                    BoxShadow(
                      color: QuantumDesign.primary.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bolt, size: 50, color: QuantumDesign.primary),
                      SizedBox(height: 10),
                      Text(
                        "QUANTUM SYNC",
                        style: TextStyle(
                          color: QuantumDesign.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 30),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: QuantumDesign.glassNode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Biohacking Insights",
                style: TextStyle(
                  color: QuantumDesign.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "• Optimale Insulin-Sensitivität erreicht\n• Genetische Übereinstimmung bei 94%\n• Zelluläre Hydratation stabil\n• Mitochondrien-Effizienz maximiert",
                style: TextStyle(color: Colors.white70, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatBar(String title, double factor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.white38)),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(height: 4, width: double.infinity, color: Colors.white10),
              AnimatedContainer(
                duration: const Duration(seconds: 1),
                height: 4,
                width: 300 * factor,
                color: QuantumDesign.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}