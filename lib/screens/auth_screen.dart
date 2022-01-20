import 'package:flutter/material.dart';
import 'package:shop_app/screens/signin_screen.dart';
import 'package:shop_app/screens/signup_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        child: DefaultTabController(
            length: 2,
            child: TabBarView(children: [SigninScreen(), SignupScreen()])),
      ),
    );
  }
}
