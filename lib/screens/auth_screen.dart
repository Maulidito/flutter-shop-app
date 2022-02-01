import 'package:flutter/material.dart';

import 'package:shop_app/screens/signin_screen.dart';
import 'package:shop_app/screens/signup_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);
  static const routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    final pageController = PageController(
      initialPage: 0,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: AlignmentDirectional.center,
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
        child: PageView(
            controller: pageController,
            scrollDirection: Axis.horizontal,
            children: [
              SigninScreen(),
              SignupScreen(
                pageViewToSignin: () => pageController.jumpToPage(0),
              )
            ]),
      ),
    );
  }
}
