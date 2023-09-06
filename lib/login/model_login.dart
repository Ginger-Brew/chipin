import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  String id = "";
  String password = "";

  void setId(String id) {
    this.id = id;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  String getemail() {
    return id;
  }
}