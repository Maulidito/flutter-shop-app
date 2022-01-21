import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:shop_app/providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";
  const EditProductScreen({Key? key}) : super(key: key);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _priceController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _editedProduct = Product(id: "", desc: "", img: "", price: 0, title: "");
  var _isInit = true;
  var _isEdit = true;
  var _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    _imageUrlFocusNode.addListener(_updateImageUrl);
    _priceFocusNode.addListener(_priceFormat);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_isInit) {
      final productId = ModalRoute.of(context)?.settings.arguments;
      productId != null
          ? {
              _editedProduct = Provider.of<Products>(context)
                  .findById(id: productId.toString())
            }
          : _isEdit = false;
      _imageUrlController.text = _editedProduct.img;

      _editedProduct.price != 0
          ? _priceController.text = _editedProduct.price.toString()
          : _priceController.text = "";
      _priceFormat();
    }
    _isInit = false;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    _priceFocusNode.dispose();
  }

  void _priceFormat() {
    var _regexCommaDot = RegExp(r"[\,\.\ ]+");

    try {
      if (_priceFocusNode.hasFocus) {
        _priceController.text =
            _priceController.text.replaceAll(_regexCommaDot, "");
      } else {
        var value = _priceController.text.replaceAll(_regexCommaDot, "");

        _priceController.text =
            NumberFormat.decimalPattern().format(int.parse(value));
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    // _priceController.text =
    //     NumberFormat.decimalPattern(_priceController.text).toString();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    debugPrint("BERFORE FORM " + _priceController.text);
    _priceController.text =
        _priceController.text.replaceAll(RegExp(r"[\,\.\ ]+"), "").toString();
    _form.currentState?.validate();
    _form.currentState?.save();
    debugPrint("AFTER FORM " + _editedProduct.price.toString());

    setState(() {
      _isLoading = true;
    });

    try {
      var _providerProducts = Provider.of<Products>(context, listen: false);
      _isEdit
          ? await _providerProducts.updateProduct(_editedProduct)
          : await _providerProducts.addProduct(_editedProduct);
    } catch (err) {
      await showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Error"),
              content: const Text("Something Went Wrong "),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Okay"))
              ],
            );
          });
    } finally {
      Navigator.of(context).pop();
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(_imageUrlController.text);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit product"),
        actions: [
          IconButton(onPressed: _saveForm, icon: const Icon(Icons.save))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator.adaptive(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _form,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    TextFormField(
                      initialValue: _editedProduct.title,
                      decoration: const InputDecoration(
                        labelText: "Title",
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      autofocus: true,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please insert the Form";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        if (val != null) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: val,
                              price: _editedProduct.price,
                              desc: _editedProduct.desc,
                              isFavorite: _editedProduct.isFavorite,
                              img: _editedProduct.img);
                        }
                      },
                    ),
                    TextFormField(
                      // initialValue: _editedProduct.price == 0
                      //     ? ""
                      //     : _editedProduct.price.toString(),
                      decoration: const InputDecoration(labelText: "Price"),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      controller: _priceController,
                      focusNode: _priceFocusNode,
                      onTap: () {
                        debugPrint("tapping");
                        _priceFocusNode.hasFocus
                            ? _priceController.clear()
                            : null;
                      },

                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please insert the Form";
                        }
                        if (double.tryParse(value) == null) {
                          return "Please Enter a Valid number";
                        }
                        if (double.parse(value) <= 0) {
                          return "Please Input price Above Zero";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        if (val != null) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              price: double.parse(val),
                              desc: _editedProduct.desc,
                              isFavorite: _editedProduct.isFavorite,
                              img: _editedProduct.img);
                        }
                      },
                    ),
                    TextFormField(
                      initialValue: _editedProduct.desc,
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "please insert the Form";
                        }
                        if (value.length < 10) {
                          return "please more word in description";
                        }
                        return null;
                      },
                      onSaved: (val) {
                        if (val != null) {
                          _editedProduct = Product(
                              id: _editedProduct.id,
                              title: _editedProduct.title,
                              price: _editedProduct.price,
                              desc: val,
                              isFavorite: _editedProduct.isFavorite,
                              img: _editedProduct.img);
                        }
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          alignment: Alignment.center,
                          child: _imageUrlController.text.isEmpty
                              ? const Text(
                                  "Enter the URL",
                                  textAlign: TextAlign.center,
                                )
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                          margin: const EdgeInsets.only(top: 10, right: 10),
                          decoration: BoxDecoration(
                              border: Border.all(width: 1, color: Colors.grey)),
                        ),
                        Expanded(
                          child: TextFormField(
                              decoration:
                                  const InputDecoration(labelText: "Image URL"),
                              keyboardType: TextInputType.url,
                              controller: _imageUrlController,
                              focusNode: _imageUrlFocusNode,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "please insert the Form";
                                }
                                if (!value.startsWith("http") &&
                                    !value.startsWith("https")) {
                                  return "Please enter a valid URL";
                                }
                                if (!value.endsWith("png") &&
                                    !value.endsWith("jpg")) {
                                  return "Please enter a valid URL";
                                }

                                return null;
                              },
                              onSaved: (val) {
                                if (val != null) {
                                  _editedProduct = Product(
                                      id: _editedProduct.id,
                                      title: _editedProduct.title,
                                      price: _editedProduct.price,
                                      desc: _editedProduct.desc,
                                      isFavorite: _editedProduct.isFavorite,
                                      img: val);
                                }
                              },
                              onFieldSubmitted: (_) {
                                _saveForm();
                              },
                              textInputAction: TextInputAction.done),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
