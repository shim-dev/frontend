import 'package:flutter/material.dart';
import 'home_screen.dart'; 

void main() {
  runApp(const ShimApp());
}

class ShimApp extends StatelessWidget {
  const ShimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shim Project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
