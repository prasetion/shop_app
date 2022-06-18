import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String? _token;
  DateTime _expiryDate = DateTime.now();
  String? _userId;

  Future<void> signUp(String? email, String? password) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCfRsUW2EdPhGjvGckH5peNTtD15_chs54");
    final res = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    print(json.decode(res.body));
  }
}
