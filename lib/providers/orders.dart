import 'package:flutter/material.dart';
import './cart.dart';

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

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        produtItems: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
