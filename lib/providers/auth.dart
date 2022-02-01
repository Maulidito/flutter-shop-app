import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:shop_app/models/user.dart' as account;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  FirebaseAuth? auth;
  String? token;
  String? userId;
  late final account.User acc;
  Auth({this.auth});

  Stream<User?> get authStateChanges => auth!.idTokenChanges();

  // Future<void> authStateChange() async {
  //   auth.authStateChanges().listen((User? user) async {
  //     if (user == null) {
  //       debugPrint("user Sign out");
  //       token = null;
  //       userId = null;
  //     } else {
  //       token = await user.getIdToken(false);
  //       userId = user.uid;
  //       debugPrint("user Sign in $token --- $userId");
  //     }
  //   });
  // }

  Future<void> login(String email, String password) async {
    try {
      final res = await auth!
          .signInWithEmailAndPassword(email: email, password: password);

      res.user == null ? throw "Error" : null;
      account.User(
          name: res.user!.displayName ?? "", email: email, password: password);
      token = await res.user!.getIdToken();
      userId = res.user!.uid;
      final prefs = await SharedPreferences.getInstance();

      final userData = json.encode({"token": token, "userId": userId});
      await prefs.setString("userData", userData);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw e;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    debugPrint(prefs.getString("userData"));
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final prefData =
        json.decode(prefs.getString("userData") ?? "") as Map<String, dynamic>;
    token = prefData["token"] as String;
    userId = prefData["userId"] as String;

    if (token == null) {
      return false;
    }
    auth!.signInWithCustomToken(token ?? "");

    return true;
  }

  Future<void> logout() async {
    try {
      token = null;
      userId = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await auth!.signOut();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> register(account.User user) async {
    try {
      final res = await auth!.createUserWithEmailAndPassword(
          email: user.email, password: user.password ?? "");
      res.user?.updateDisplayName(user.name);
    } catch (e) {
      throw e;
    }
  }

  bool get isAuth {
    if (token != null && userId != null) {
      return true;
    } else {
      return false;
    }
  }
}
