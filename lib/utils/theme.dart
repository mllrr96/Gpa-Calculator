import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static final lightTheme = ThemeData(
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
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF002956),
      secondary: const Color(0xFFC89601),
      brightness: Brightness.dark,
    ),
    segmentedButtonTheme: SegmentedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Color(0xFF002956).withValues(alpha: 0.5);
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
  );
}
