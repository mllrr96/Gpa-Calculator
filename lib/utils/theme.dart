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
            return Color(0xffF3F3FA);
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? Colors.black
                  : Colors.grey[700],
        ),
        textStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight:
                states.contains(WidgetState.selected)
                    ? FontWeight.bold
                    : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        side: WidgetStateProperty.resolveWith<BorderSide>(
          (states) => BorderSide(color: Colors.grey[300]!),
        ),
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
            // return Color(0xFF002956).withValues(alpha: 0.5);
            return const Color(0xFF181C20);
          }
          return Colors.transparent;
        }),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) =>
              states.contains(WidgetState.selected)
                  ? Colors.white
                  : Colors.grey[300],
        ),
        textStyle: WidgetStateProperty.resolveWith(
          (states) => TextStyle(
            fontWeight:
                states.contains(WidgetState.selected)
                    ? FontWeight.bold
                    : FontWeight.normal,
            fontSize: 16,
          ),
        ),
        side: WidgetStateProperty.resolveWith<BorderSide>(
          (states) => BorderSide(color: const Color(0xFF181C20)),
        ),
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
