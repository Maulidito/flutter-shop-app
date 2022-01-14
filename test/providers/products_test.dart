import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';

import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

void main() {
  group("Add and delete product to Firebase", () {
    var prodClass = Products();
    final prod = Product(
        id: DateTime.now().toString(),
        title: "Gambar yang akan dimasukan",
        desc: "ini merupakan percobaan pemasukan data",
        price: 6.00,
        isFavorite: false,
        img:
            "https://images.unsplash.com/photo-1640622308122-b1b0f3cd5a7f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80.jpg");
    test('add product data to Firebase', () async {
      var status = 0;

      var response = await prodClass.addProduct(prod).then((_) {
        status = 200;
      }).catchError((err) {
        status = 400;
      });
      expect(status, 200);
      // TODO: Implement test
    }, skip: true);

    test('Delete Products from firebase', () async {
      try {
        var prodId = prodClass.items.firstWhere((e) =>
            e.title == prod.title &&
            e.price == prod.price &&
            e.desc == prod.desc);

        await prodClass.deleteProduct(prodId.id);
      } catch (e) {
        debugPrint(e.toString());
      }
    });
  }, skip: true);

  test('Get Product From Firebase', () async {
    var prod = Products();
    var status = 0;
    try {
      await prod.fetchSetProduct();
    } catch (e) {
      debugPrint(e.toString());
      status = 400;
    }

    expect(prod.items.isEmpty, false);
  }, skip: true);

  test('Update Product From Firebase', () async {
    var prod = Products();
    await prod.fetchSetProduct();
    var updated = prod.items[0];

    updated.isFavorite = !updated.isFavorite;

    try {
      await prod.updateProduct(updated);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      await prod.fetchSetProduct();
    }

    expect(prod.items[0].isFavorite, updated.isFavorite);
  }, skip: true);

  test('Push Favorite Product From Firebase', () async {
    var products = Products();
    await products.fetchSetProduct();
    var update = products.items[0];

    try {
      await update.toggleFavoriteState();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      await products.fetchSetProduct();
    }

    expect(products.items[0].isFavorite, update.isFavorite);
  }, skip: true);
}
