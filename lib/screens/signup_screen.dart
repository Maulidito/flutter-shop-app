import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/user.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/product_overview_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _form = GlobalKey<FormState>();
  User _formData = User(name: "", password: "", email: "");
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Form(
        child: SafeArea(
      child: Form(
          key: _form,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            child: Column(
              children: [
                Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 50,
                      fontFamily: "Lato-Bold",
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.85)),
                ),
                SizedBox(
                  height: _height * 0.03,
                ),
                Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      "Name",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white),
                    )),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  onSaved: (val) {
                    val != null
                        ? _formData = User(
                            name: val,
                            email: _formData.email,
                            password: _formData.password)
                        : null;
                  },
                  decoration: InputDecoration(
                      hintText: "Name",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
                SizedBox(
                  height: _height * 0.03,
                ),
                Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      "Email",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white),
                    )),
                TextFormField(
                  enableSuggestions: true,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: "Email",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onSaved: (val) {
                    val != null
                        ? _formData = User(
                            name: _formData.name,
                            email: val,
                            password: _formData.password)
                        : null;
                  },
                ),
                SizedBox(
                  height: _height * 0.03,
                ),
                Container(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      "Password",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.white),
                    )),
                TextFormField(
                  textInputAction: TextInputAction.done,
                  obscureText: true,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                      hintText: "Password",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onSaved: (val) {
                    val != null
                        ? _formData = User(
                            name: _formData.name,
                            email: _formData.email,
                            password: val)
                        : null;
                  },
                ),
                SizedBox(
                  height: _height * 0.3,
                ),
                ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _isloading = true;
                      });

                      _form.currentState?.save();
                      try {
                        await Provider.of<Auth>(context, listen: false)
                            .register(_formData);
                        Navigator.of(context).pushReplacementNamed(
                            ProductOverviewScreen.routeName);
                      } on fb.FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.message.toString())));
                      } finally {
                        setState(() {
                          _isloading = false;
                        });
                      }
                    },
                    child: _isloading
                        ? CircularProgressIndicator.adaptive(
                            backgroundColor: Colors.white,
                          )
                        : Text("Sign Up"),
                    style: ElevatedButton.styleFrom(
                        fixedSize: Size(_width * 0.45, _height * 0.08),
                        side: BorderSide(color: Colors.white, width: 1),
                        textStyle: TextStyle(fontSize: 24)))
              ],
            ),
          )),
    ));
  }
}
