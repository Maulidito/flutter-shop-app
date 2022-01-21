import 'dart:convert';
import '../utilities/firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'product.dart';
import 'package:firebase_database/firebase_database.dart';

class Products with ChangeNotifier {
  final List<Product> _items = [];
  var showFavorite = false;

  late final String? token;

  Products({this.token});

  void updateToken(int token) {
    token = token;
  }

  void firebaseVer() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("/products");

    DatabaseEvent event = await ref.once();

    print(event.snapshot.value);
  }

  Future<void> fetchSetProduct() async {
    firebaseVer();

    final url = Uri.parse(Firebase.urlFirebase + '/products.json?auth=$token');
    debugPrint("FETCHING THE PRODUCT");
    try {
      final response = await http.get(url);
      final rawData = jsonDecode(response.body) as Map<String, dynamic>;
      debugPrint(" raw data : ${rawData.toString()}");
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
    final url = Uri.parse(Firebase.urlFirebase + '/products.json?auth=$token');
    debugPrint("Token : $token");
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
    final url =
        Uri.parse(Firebase.urlFirebase + '/products/$id.json?auth=$token');
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
        final url = Uri.parse(
            Firebase.urlFirebase + '/products/${prod.id}.json?auth=$token');
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
