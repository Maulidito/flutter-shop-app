import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/screens/product_detail_screen.dart';
import 'package:shop_app/screens/product_full_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String img;
  const UserProductItem({
    Key? key,
    required this.title,
    required this.img,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _radiusCard =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(15));
    return Card(
      semanticContainer: true,
      elevation: 5,
      shape: _radiusCard,
      child: InkWell(
        customBorder: _radiusCard,
        onTap: () => Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: id),
        child: ListTile(
          title: Text(title),
          leading: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => Navigator.of(context)
                .pushNamed(ProductFullScreen.routeName, arguments: id),
            child: Hero(
              tag: id + "image",
              child: CircleAvatar(
                backgroundImage: NetworkImage(img),
              ),
            ),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(EditProductScreen.routeName, arguments: id),
                  icon: Icon(Icons.edit),
                  color: Theme.of(context).colorScheme.primary,
                ),
                IconButton(
                  onPressed: () async {
                    try {
                      await Provider.of<Products>(context, listen: false)
                          .deleteProduct(id);
                    } catch (err) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Something went wrong when deleting product $title'),
                        backgroundColor: Colors.red[400],
                      ));
                    }
                  },
                  icon: Icon(Icons.delete),
                  color: Theme.of(context).colorScheme.error,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
