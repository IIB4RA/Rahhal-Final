// main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/favorites_provider.dart';
import 'welcomepage.dart';        
import 'main_wrapper.dart';       
import 'explorPage.dart';         
import 'hotelBoookingPage.dart';  
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rahhal Jordan',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey
      ),
      home: const MainWrapper(),
    );
  }
}

