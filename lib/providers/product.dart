import 'dart:convert';
import '../utilities/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shop_app/providers/products.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String img;
  bool isFavorite;

  Product(
      {required this.id,
      required this.title,
      required this.desc,
      required this.price,
      required this.img,
      this.isFavorite = false});

  Future<void> toggleFavoriteState() async {
    var url = Uri.parse(Firebase.urlFirebase + '/products/$id.json');
    try {
      isFavorite = !isFavorite;
      await http.patch(url,
          body: jsonEncode(Products.productToJson(Product(
              id: id,
              title: title,
              desc: desc,
              img: img,
              price: price,
              isFavorite: isFavorite))));
    } catch (e) {
      isFavorite = !isFavorite;
      throw e;
    } finally {
      notifyListeners();
    }
  }

  bool get getFavorite {
    return isFavorite;
  }
}
