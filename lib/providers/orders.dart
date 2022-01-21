import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/utilities/firebase.dart';

class OrderItem {
  final String id;
  final double totalAmount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {required this.id,
      required this.totalAmount,
      required this.products,
      required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String? token;

  Orders({this.token});

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    final url = Uri.parse(Firebase.urlFirebase + "/orders.json?auth=$token");
    debugPrint("uri = $token");
    try {
      final response = await http.get(url);

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _orders.clear();
      if (data.isEmpty) {
        return;
      }
      data.forEach((orderId, value) => _orders.add(OrderItem(
          id: orderId,
          dateTime: DateTime.parse(value["dateTime"]),
          totalAmount: value["amount"],
          products: (value["products"] as List<dynamic>)
              .map((e) => CartItem(
                  id: e["id"],
                  title: e["title"],
                  quantity: e["quantity"],
                  price: e["price"]))
              .toList())));
    } catch (e) {
      debugPrint(e.toString());
      throw e;
    } finally {
      notifyListeners();
    }

    //_orders = data.values.map((e) => OrderItem(id: data["name"], dateTime: e["dateTime"])).toList();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    var url = Uri.parse(Firebase.urlFirebase + "/orders.json?auth=$token");
    try {
      final response = await http.post(url,
          body: jsonEncode({
            "amount": total,
            "dateTime": timeStamp.toIso8601String(),
            "products": cartProducts
                .map((e) => {
                      "id": e.id,
                      "title": e.title,
                      "quantity": e.quantity,
                      "price": e.price
                    })
                .toList()
          }));
      _orders.insert(
          0,
          OrderItem(
              id: jsonDecode(response.body)["name"],
              dateTime: timeStamp,
              products: cartProducts,
              totalAmount: total));
    } catch (e) {
      throw e;
    } finally {
      notifyListeners();
    }
  }

  void clear() {
    _orders.clear();
    notifyListeners();
  }
}
