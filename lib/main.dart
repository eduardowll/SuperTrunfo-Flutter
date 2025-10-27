import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const SuperTrunfoApp());
}

class SuperTrunfoApp extends StatelessWidget {
  const SuperTrunfoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
