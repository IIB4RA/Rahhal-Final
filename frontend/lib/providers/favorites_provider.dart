import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
 
  final List<Map<String, dynamic>> _savedItems = [];

  List<Map<String, dynamic>> get savedItems => _savedItems;

  void toggleFavorite(Map<String, dynamic> attraction) {
   
    bool isExist = _savedItems.any((item) => item['name'] == attraction['name']);

    if (isExist) {
      _savedItems.removeWhere((item) => item['name'] == attraction['name']);
    } else {
      _savedItems.add(attraction);
    }
    
    
    notifyListeners();
  }

  bool isFavorite(String name) {
    return _savedItems.any((item) => item['name'] == name);
  }
}