import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  String id = "";
  String email = "";
  String password = "";
  String passwordConfirm = "";
  String name = "";

  //여기서부터 내가 추가한거
  bool checkOver = false;
  bool checkAgree = false;

  void setId(String id) {
    this.id = id;
    notifyListeners();
  }

  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  void setPasswordConfirm(String passwordConfirm) {
    this.passwordConfirm = passwordConfirm;
    notifyListeners();
  }

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  //여기서부터 내가 추가한거
  void setCheckOver(bool checkOver){
    this.checkOver= checkOver;
    notifyListeners();
  }
  void setCheckAgree(bool checkAgree){
    this.checkAgree= checkAgree;
    notifyListeners();
  }
  //
}