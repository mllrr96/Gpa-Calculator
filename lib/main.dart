import 'package:flutter/material.dart';
import 'package:gpa_calculator/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gpa Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF002956),
          secondary: Color(0xFFC89601),
        ),
      ),
      home: HomePage(title: 'GPA Calculator'),
    );
  }
}
