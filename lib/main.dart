import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const FoodJournalApp());
}

class FoodJournalApp extends StatelessWidget {
  const FoodJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Food Journal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const HomePage(),
    );
  }
}