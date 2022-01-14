import 'dart:convert';
import '../utilities/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   desc: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   img:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   desc: 'A nice pair of trousers.',
    //   price: 59.99,
    //   img:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   desc: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   img: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   desc: 'Prepare any meal you want.',
    //   price: 49.99,
    //   img:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];
  var showFavorite = false;

  Future<void> fetchSetProduct() async {
    final url = Uri.parse(Firebase.urlFirebase + '/products.json');
    debugPrint("FETCHING THE PRODUCT");
    try {
      final response = await http.get(url);
      final rawData = jsonDecode(response.body) as Map<String, dynamic>;

      _items.clear();
      rawData.forEach((prodId, value) {
        _items.add(Product(
            id: prodId,
            title: value["title"],
            desc: value["description"],
            img: value["image"],
            price: value["price"],
            isFavorite: value["isFavorite"]));
      });
    } catch (e) {
      throw e;
    } finally {
      notifyListeners();
    }
  }

  List<Product> get items {
    return <Product>[..._items];
  }

  List<Product> get itemFavorite {
    return <Product>[..._items.where((element) => element.isFavorite == true)];
  }

  List<Product> getItemFilter(bool filter) {
    if (filter == true) {
      return itemFavorite;
    }
    return items;
  }

  static Map<String, dynamic> productToJson(Product prod) {
    return {
      "title": prod.title,
      "price": prod.price,
      "description": prod.desc,
      "image": prod.img,
      "isFavorite": prod.isFavorite
    };
  }

  Future<void> addProduct(Product prod) async {
    final url = Uri.parse(Firebase.urlFirebase + '/products.json');

    try {
      final newProduct = Product(
          title: prod.title,
          img: prod.img,
          price: prod.price,
          desc: prod.desc,
          id: DateTime.now().toString());

      final response =
          await http.post(url, body: json.encode(productToJson(newProduct)));

      _items.add(Product(
          title: prod.title,
          img: prod.img,
          price: prod.price,
          desc: prod.desc,
          id: jsonDecode(response.body)["name"]));
      notifyListeners();
    } catch (err) {
      debugPrint(err.toString());
      throw err;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(Firebase.urlFirebase + '/products/$id.json');
    try {
      await http.delete(url).then((value) {
        _items.removeWhere((element) => element.id == id);
      });
    } catch (err) {
      debugPrint("error delete product" + err.toString());
      throw err;
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateProduct(Product prod) async {
    var prodIndex = _items.indexWhere((element) => element.id == prod.id);

    try {
      if (prodIndex >= 0) {
        final url =
            Uri.parse(Firebase.urlFirebase + '/products/${prod.id}.json');
        await http.patch(url, body: jsonEncode(productToJson(prod)));
        _items[prodIndex] = prod;
      } else {
        debugPrint("not Found");
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Product findById({required String id}) {
    return _items.firstWhere((element) => element.id == id);
  }
}
