import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom_route.dart';
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
              // Navigator.of(context)
              //     .pushReplacementNamed(ProductOverviewScreen.routeName);
              Navigator.of(context).pushReplacement(CustomRoute(
                builder: (ctx) => ProductOverviewScreen(),
              ));
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
                await context.read<Auth>().logout();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    AuthScreen.routeName, (Route route) => false);
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
