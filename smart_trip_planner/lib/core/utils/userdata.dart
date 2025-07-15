import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userName = '';
  String _email = '';

  String get userName => _userName;
  String get email => _email;

  void setUserName(String name, String email) {
    _userName = name;
    _email = email;
    notifyListeners();
  }
}
