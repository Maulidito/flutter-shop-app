import 'package:flutter/material.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/orders.dart';
import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/orders_screen.dart';
import 'package:shop_app/screens/product_full_screen.dart';
import 'package:shop_app/screens/user_products_screen.dart';

import './screens/product_overview_screen.dart';
import './screens/product_detail_screen.dart';
import 'package:provider/provider.dart'; //register the provider
import 'package:firebase_core/firebase_core.dart';
import './providers/products.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => Auth()),
          ChangeNotifierProvider(create: (_) => Products()),
          ChangeNotifierProvider(create: (_) => Cart()),
          ChangeNotifierProvider(
            create: (_) => Orders(),
          )
        ],
        child: MaterialApp(
          theme: ThemeData(
              fontFamily: "Lato",
              textTheme:
                  const TextTheme(headline1: TextStyle(color: Colors.white)),
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
              ).copyWith()),
          initialRoute: AuthScreen.routeName,
          routes: {
            ProductOverviewScreen.routeName: (_) => ProductOverviewScreen(),
            ProductDetailScreen.routeName: (_) => ProductDetailScreen(),
            CartScreen.routeName: (_) => CartScreen(),
            OrdersScreen.routeName: (_) => OrdersScreen(),
            UserProductScreen.routeName: (_) => UserProductScreen(),
            ProductFullScreen.routeName: (_) => ProductFullScreen(),
            EditProductScreen.routeName: (_) => EditProductScreen(),
            AuthScreen.routeName: (_) => AuthScreen()
          },
        ));
  }
}
