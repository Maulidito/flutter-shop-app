import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart' as widget;

class OrdersScreen extends StatelessWidget {
  static const routeName = "/orders";
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: const AppDrawer(),
        appBar: AppBar(
          title: const Text("Your Order"),
        ),
        body: FutureBuilder(
            future:
                Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
            builder: (_, dataSnapshot) {
              debugPrint(dataSnapshot.toString());
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator.adaptive(),
                );
              } else {
                if (dataSnapshot.error != null) {
                  //! handle error
                  return Center(
                    child: Text("Something went wrong"),
                  );
                } else {
                  return Consumer<Orders>(builder: (context, orderData, child) {
                    return ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (_, i) => widget.OrderItem(
                              item: orderData.orders[i],
                            ));
                  });
                }
              }
            }));
  }
}
