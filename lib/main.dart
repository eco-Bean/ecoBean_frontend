import 'package:ecobean_frontend/screens/main_screen.dart';
import 'package:ecobean_frontend/screens/recycling_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFFFFCF8),
      ),
      home: RecyclingScreen(),
    );
  }
}