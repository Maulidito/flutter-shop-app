import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = "/user-product";
  const UserProductScreen({Key? key}) : super(key: key);

  Future<void> _refershProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Product"),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(EditProductScreen.routeName),
              icon: const Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refershProducts(context),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Consumer<Products>(
            builder: (ctx, product, child) => ListView.builder(
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return UserProductItem(
                  title: product.items[index].title,
                  img: product.items[index].img,
                  id: product.items[index].id,
                );
              },
              itemCount: product.items.length,
            ),
          ),
        ),
      ),
    );
  }
}
