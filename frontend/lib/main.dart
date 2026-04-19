
import 'package:flutter/material.dart';
import 'package:frontend/welcomepage.dart';
import 'package:provider/provider.dart'; 
import 'providers/favorites_provider.dart'; 
import 'welcomepage.dart'; 

void main() {
  runApp(

    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}