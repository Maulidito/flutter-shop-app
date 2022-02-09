import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/screens/product_overview_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  Map<String, String> _dataForm = {"password": "", "email": ""};
  late AnimationController controllArrow;
  late Animation<double> animation;

  @override
  void initState() {
    controllArrow =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 0.0, end: 20.0).animate(controllArrow);

    controllArrow.repeat(reverse: true);

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controllArrow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("signIn Screen Building...");
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;
    return Form(
      key: _form,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 40),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: _height * 0.0),
                alignment: AlignmentDirectional.center,
                child: Text(
                  "Sign in",
                  style: TextStyle(
                      fontSize: 50,
                      fontFamily: "Lato-Bold",
                      fontWeight: FontWeight.bold,
                      color: Colors.white.withOpacity(0.85)),
                ),
              ),
              SizedBox(
                height: _height * 0.35,
              ),
              TextFormField(
                onSaved: (String? val) {
                  val != null ? _dataForm = {..._dataForm, "email": val} : null;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                    hintText: "Email",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: _height * 0.03,
              ),
              TextFormField(
                onSaved: (String? val) {
                  val != null
                      ? _dataForm = {..._dataForm, "password": val}
                      : null;
                },
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                    hintText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
              SizedBox(
                height: _height * 0.06,
              ),
              ElevatedButton(
                  onPressed: () async {
                    _form.currentState?.save();

                    try {
                      await context.read<Auth>().login(_dataForm["email"] ?? "",
                          _dataForm["password"] ?? "");

                      Navigator.of(context).pushReplacementNamed(
                          ProductOverviewScreen.routeName);
                    } on FirebaseAuthException catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.message.toString())));
                    } catch (e) {
                      debugPrint(e.toString());
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:
                              Text("something went wrong, try again later")));
                    }
                  },
                  child: Text("Login"),
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(_width * 0.45, _height * 0.08),
                      side: BorderSide(color: Colors.white, width: 1),
                      textStyle: TextStyle(fontSize: 24))),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Swipe Right to Sign Up"),
                  AnimatedBuilder(
                    animation: animation,
                    builder: (ctx, ch) {
                      return Container(
                        width: 50,
                        padding: EdgeInsets.fromLTRB(animation.value, 0, 0, 0),
                        child: ch,
                      );
                    },
                    child: const Icon(
                      Icons.arrow_right_alt_rounded,
                      color: Colors.white,
                      size: 50,
                    ),
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
