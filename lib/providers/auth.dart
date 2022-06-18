import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String? _token;
  DateTime _expiryDate = DateTime.now();
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String? email, String? password, String urlSegment) async {
    final url = Uri.parse(
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCfRsUW2EdPhGjvGckH5peNTtD15_chs54");
    try {
      final res = await http.post(
        url,
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );
      final resData = json.decode(res.body);
      if (resData["error"] != null) {
        throw HttpException(resData["error"]["message"]);
      }

      _token = resData["idToken"];
      _userId = resData["localId"];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(resData["expiresIn"]),
      ));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String? email, String? password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> login(String? email, String? password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
