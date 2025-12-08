import 'package:flutter/material.dart';
import 'package:weather_app/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0F1F),
        cardColor: const Color(0xFF11172B),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7ED2FF), // sky blue
          secondary: Color(0xFFC084FC), // purple glow
        ),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFFEAF4FF)),
          bodyLarge: TextStyle(color: Color(0xFFEAF4FF)),
        ),
      ),

      home: const WeatherScreen(),
    );
  }
}
