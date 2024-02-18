
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:utsmobilewilbert/data/model/auth.dart';
import 'package:utsmobilewilbert/presentation/pages/auth/state.dart';
import 'package:utsmobilewilbert/presentation/pages/auth/login.dart';
import 'package:utsmobilewilbert/presentation/pages/home.dart';

class AuthService {
  static const String key = 'account';

  static Future<void> login(
      String email, String password, BuildContext context) async {
    List<Account> accounts = await getAccount();

    Account matchingAccount = accounts.firstWhere(
      (account) => account.email == email,
      orElse: () => Account(id: '', name: '', email: '', password: ''),
    );

    if (matchingAccount.password == password) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login successful!'),
        ),
      );
      AuthState.loggedInAccount = matchingAccount;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    } else {
      if (matchingAccount.id == '') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User belum terdaftar!'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tolong masukkan password dengan benar!'),
          ),
        );
      }
    }
  }

  static Future<List<Account>> getAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey(key)) {
      var data = prefs.getString(key);
      if (data != null) {
        Iterable decoded = jsonDecode(data);
        return List<Account>.from(decoded.map((e) => Account.fromJson(e)));
      }
    }

    return [];
  }

  static Future<void> register(
      List<Account> account, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var encoded = jsonEncode(account);
    prefs.setString(key, encoded);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('berhasil register!'),
      ),
    );
    print(encoded);
  }

  static Future<void> logout(BuildContext context) async {
    AuthState.loggedInAccount = null;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
    print(AuthState.loggedInAccount);
  }
}
