import 'package:flutter/material.dart';
import 'welcomepage.dart';

void main() {
  runApp(const MyApp()
  
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
     
      home: WelcomePage(), 
    );
  }
}

