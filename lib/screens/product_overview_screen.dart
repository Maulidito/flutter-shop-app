import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';

enum FilterOptions { favorite, all }

class ProductOverviewScreen extends StatefulWidget {
  static const routeName = "/product-overview";

  ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showFavoriteOnly = false;

  late Future _fetchProduct;

  Future _obtainFectProduct() {
    return Provider.of<Products>(context, listen: false).fetchSetProduct();
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchProduct = _obtainFectProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: const Text("My Shop"),
          actions: [
            PopupMenuButton(
              onSelected: (FilterOptions selected) {
                setState(() {
                  if (selected == FilterOptions.favorite) {
                    _showFavoriteOnly = true;
                  } else {
                    _showFavoriteOnly = false;
                  }
                });
              },
              icon: const Icon(Icons.more_vert),
              itemBuilder: (_) => [
                const PopupMenuItem(
                  child: Text("All"),
                  value: FilterOptions.all,
                ),
                const PopupMenuItem(
                  child: Text("Favorite"),
                  value: FilterOptions.favorite,
                )
              ],
            ),
            Consumer<Cart>(
              builder: (ctx, cart, ch) =>
                  Badge(child: ch!, value: cart.getQuantity().toString()),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () =>
                    Navigator.pushNamed(context, CartScreen.routeName),
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: _fetchProduct,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator.adaptive());
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text("something went wrong"),
                );
              }

              return ProductsGrid(_showFavoriteOnly);
            }
          },
        ));
  }
}
