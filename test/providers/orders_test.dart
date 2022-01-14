import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/providers/products.dart';

void main() {
  group("Testing Orders", () {
    final products = Products();
    final cart = Cart();
    final order = Orders();
    test('Add product to cart', () async {
      try {
        await products.fetchSetProduct();

        for (var e in products.items) {
          cart.addItem(e.id, e.price, e.title);
        }
      } catch (e) {
        debugPrint(e.toString());
        throw e;
      } finally {
        expect(cart.items.isEmpty, false);
      }
    }, skip: true);

    test('Add Cart to Product', () async {
      var status = 0;
      try {
        debugPrint(cart.items.toString());
        await order.addOrder(cart.items.values.toList(), cart.totalAmount);

        status = 200;
      } catch (e) {
        debugPrint(e.toString());
        status = 404;
        throw e;
      } finally {
        expect(status, 200);
      }
    }, skip: true);
    test('Get Orders from firebase', () async {
      try {
        await order.fetchAndSetOrders();
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        debugPrint(order.toString());
        expect(order.orders.isNotEmpty, true);
      }
    });
  }, skip: false);
}
