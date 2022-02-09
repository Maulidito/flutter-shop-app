import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart.dart';
import '../providers/product.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed("/product-detail", arguments: product.id);
            },
            child: Hero(
              tag: product.id + "loadedProduct",
              child: FadeInImage(
                image: NetworkImage(product.img),
                placeholder:
                    AssetImage("assets/images/product-placeholder.png"),
              ),
            )),
        footer: GridTileBar(
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product>(
              builder: (ctx, product, child) => IconButton(
                    onPressed: () async {
                      try {
                        await product.toggleFavoriteState(
                            auth.token ?? "", auth.userId ?? "");
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text("Something went wrong"),
                          backgroundColor: Colors.red[400],
                          duration: const Duration(seconds: 3),
                        ));
                      }
                    },
                    icon: Icon(product.getFavorite
                        ? Icons.favorite
                        : Icons.favorite_border_outlined),
                    color: Theme.of(context).colorScheme.secondary,
                  )),
          backgroundColor: Colors.black54,
          trailing: IconButton(
            onPressed: () => {
              cart.addItem(product.id, product.price, product.title),
              ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text("Added Item to Cart"),
                  duration: const Duration(seconds: 4),
                  action: SnackBarAction(
                      label: "Undo",
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      }),
                ),
              )
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
