import 'dart:convert';

import 'package:flutter/material.dart';
import './cart.dart';
import "package:http/http.dart" as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> produtItems;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.produtItems,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    final url = Uri.parse(
        "https://flutter-shop-app-66e9d-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json");
    final res = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(res.body) as Map<String, dynamic>;

    if (extractedData == null) return;

    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData["amount"],
          dateTime: DateTime.parse(orderData["dateTime"]),
          produtItems: (orderData["produtItems"] as List<dynamic>)
              .map((item) => CartItem(
                  id: item["id"],
                  title: item["title"],
                  quantity: item["quantity"],
                  price: item["price"]))
              .toList(),
        ),
      );
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        "https://flutter-shop-app-66e9d-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json");
    try {
      final timestamp = DateTime.now();
      final response = await http.post(url,
          body: json.encode({
            "amount": total,
            "produtItems": cartProducts
                .map((cp) => {
                      "id": cp.id,
                      "title": cp.title,
                      "quantity": cp.quantity,
                      "price": cp.price,
                    })
                .toList(),
            "dateTime": timestamp.toIso8601String(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)["name"],
          amount: total,
          produtItems: cartProducts,
          dateTime: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (e) {}
  }
}
