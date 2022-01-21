import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_overview_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text("hello friend!"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text("Shop"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(ProductOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text("Orders"),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.production_quantity_limits),
            title: Text("Product"),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
              Scaffold.of(context).openEndDrawer();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout_outlined),
            title: Text("Sign Out"),
            onTap: () async {
              try {
                Scaffold.of(context).openEndDrawer();
                await Provider.of<Auth>(context, listen: false).logout();
                Navigator.of(context).pushNamed(AuthScreen.routeName);
              } catch (e) {
                debugPrint(e.toString());
              }
            },
          )
        ],
      ),
    );
  }
}
