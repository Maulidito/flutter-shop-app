import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/models/user.dart' as account;

class Auth with ChangeNotifier {
  FirebaseAuth auth = FirebaseAuth.instance;
  String? token;
  late final account.User acc;

  void authStateChange() {
    auth.authStateChanges().listen((User? user) {
      if (user == null) {
      } else {
        acc = account.User(
            email: user.email ?? "",
            password: "",
            name: user.displayName ?? "");
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      final res = await auth.signInWithEmailAndPassword(
          email: email, password: password);

      token = await res.user?.getIdToken(false);
      debugPrint("Login Token $token");
      account.User(
          name: res.user?.displayName ?? "", email: email, password: password);
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      await auth.signOut();
    } catch (e) {
      throw e;
    }
  }

  Future<void> register(account.User user) async {
    try {
      final res = await auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password ?? "");
      res.user?.updateDisplayName(user.name);
    } catch (e) {
      throw e;
    }
  }
}
