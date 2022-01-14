import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';

import '../widgets/cart_item.dart' as widgetUi;

class CartScreen extends StatelessWidget {
  static const routeName = "/cart";
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context, listen: true);
    final addOrder = Provider.of<Orders>(context, listen: false).addOrder;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart List"),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total", style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                      label: Consumer<Cart>(
                        builder: (ctx, cart, widget) {
                          return Text(
                            '\$${cart.totalAmount.toString()}',
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .color),
                          );
                        },
                      ),
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.9)),
                  OrderButton(addOrder: addOrder, cartData: cartData)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: cartData.getQuantity(),
            itemBuilder: (_, id) => widgetUi.CartItem(
                id: cartData.items.values.toList()[id].id,
                productId: cartData.items.keys.toList()[id],
                title: cartData.items.values.toList()[id].title,
                price: cartData.items.values.toList()[id].price,
                quantity: cartData.items.values.toList()[id].quantity),
          ))
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.addOrder,
    required this.cartData,
  }) : super(key: key);

  final Future<void> Function(List<CartItem> cartProducts, double total)
      addOrder;
  final Cart cartData;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: widget.cartData.items.isEmpty
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await widget.addOrder(widget.cartData.items.values.toList(),
                    widget.cartData.totalAmount);
                widget.cartData.clear();
                setState(() {
                  _isLoading = false;
                });
              },
        child: Text(
          "ORDER NOW",
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ));
  }
}
