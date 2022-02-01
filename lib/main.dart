import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint("Main Screen Building...");

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Auth>(
            create: (_) => Auth(auth: FirebaseAuth.instance)),
        StreamProvider<User?>(
            create: (ctx) => ctx.read<Auth>().authStateChanges,
            initialData: null),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (_, Auth auth, previousProduct) => Products(
            token: auth.token,
            userId: auth.userId,
          )..update(previousProduct!.items),
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, Auth auth, previousProduct) =>
              Orders(token: auth.token, userId: auth.userId)
                ..Update(previousProduct!.orders),
          create: (_) => Orders(),
        ),
      ],
      child: (MaterialApp(
        theme: ThemeData(
            fontFamily: "Lato",
            textTheme:
                const TextTheme(headline1: TextStyle(color: Colors.white)),
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.purple,
              accentColor: Colors.deepOrange,
            ).copyWith()),
        home: AuthenticationWrapper(),
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
      )),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final firebaseUser = () async => await context.watch<User>();
    final User? firebaseUser = context.read<User?>();
    final user = context.read<Auth>();

    return FutureBuilder<bool>(
      future: Provider.of<Auth>(context, listen: false).tryAutoLogin(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text("Something went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return snapshot.data == true ? ProductOverviewScreen() : AuthScreen();
        }
        return AuthScreen();
      },
    );
  }
}
