import 'package:flutter/material.dart';
import 'screens/dashboard.dart';

void main() {
  runApp(const NexusAiApp());
}

class NexusAiApp extends StatelessWidget {
  const NexusAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexus AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0F172A), // Slate 900
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF6366F1), // Indigo 500
          secondary: Color(0xFF06B6D4), // Cyan 500
          surface: Color(0xFF1E293B), // Slate 800
        ),
        cardTheme: const CardThemeData(
          color: Color(0xFF1E293B),
          elevation: 0,
          margin: EdgeInsets.symmetric(vertical: 8),
        ),
      ),
      home: const MainDashboard(),
    );
  }
}