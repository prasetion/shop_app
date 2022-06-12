import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.desc,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavoritesValue(bool val) {
    isFavorite = val;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        "https://flutter-shop-app-66e9d-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json");
    try {
      final response = await http.patch(
        url,
        body: json.encode({
          "isFavorite": isFavorite,
        }),
      );

      if (response.statusCode >= 400) {
        _setFavoritesValue(oldStatus);
      }
    } catch (e) {
      _setFavoritesValue(oldStatus);
    }
  }
}
