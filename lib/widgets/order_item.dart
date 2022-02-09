import 'dart:math';

import 'package:flutter/material.dart';
import '../providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem item;
  const OrderItem({Key? key, required this.item}) : super(key: key);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expandState = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${widget.item.totalAmount}'),
            subtitle:
                Text(DateFormat('dd / MM / yyyy').format(widget.item.dateTime)),
            trailing: IconButton(
              icon: Icon(_expandState == false
                  ? Icons.expand_more
                  : Icons.expand_less),
              onPressed: () {
                setState(() {
                  _expandState = !_expandState;
                });
              },
            ),
          ),
          (AnimatedContainer(
            curve: Curves.fastOutSlowIn,
            duration: Duration(milliseconds: 500),
            height: _expandState ? widget.item.products.length * 20 + 50 : 0,
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: widget.item.products
                  .map((prod) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prod.title,
                                  style: const TextStyle(fontFamily: "Anton"),
                                ),
                                Text('${prod.quantity} x \$${prod.price}')
                              ],
                            ),
                            const Divider(
                              height: 20,
                              indent: 50,
                              endIndent: 50,
                            )
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ))
        ],
      ),
    );
  }
}
