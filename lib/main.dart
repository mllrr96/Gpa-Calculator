import 'package:flutter/material.dart';
import 'package:gpa_calculator/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GPA Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF002956),
          secondary: const Color(0xFFC89601),
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return const Color(0xFFF0F0F0); // light unselected
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.selected)
                  ? Colors.black
                  : Colors.grey[700];
            }),
            textStyle: WidgetStateProperty.resolveWith((states) {
              return TextStyle(
                fontWeight:
                    states.contains(WidgetState.selected)
                        ? FontWeight.bold
                        : FontWeight.normal,
              );
            }),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF002956),
          secondary: const Color(0xFFC89601),
          brightness: Brightness.dark,
        ),
        segmentedButtonTheme: SegmentedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Theme.of(
                  context,
                ).colorScheme.primary.withValues(alpha: 0.5);
              }
              return const Color(0xFF1C1C1E);
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              return states.contains(WidgetState.selected)
                  ? Colors.white
                  : Colors.grey[300];
            }),
            textStyle: WidgetStateProperty.resolveWith((states) {
              return TextStyle(
                fontWeight:
                    states.contains(WidgetState.selected)
                        ? FontWeight.bold
                        : FontWeight.normal,
              );
            }),
            shape: WidgetStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            padding: WidgetStateProperty.all(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            ),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(title: 'GPA Calculator'),
    );
  }
}
