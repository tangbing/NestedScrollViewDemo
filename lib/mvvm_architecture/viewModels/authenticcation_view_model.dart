

import 'package:first_project/mvvm_architecture/models/user_model.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationViewModel with ChangeNotifier {
  bool _isAuthenticated = false;

  UserModel? _user;

  bool get isAuthenticated => _isAuthenticated;
  UserModel? get user => _user;

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    _user = UserModel(email: email, token: password);
    _isAuthenticated = true;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isAuthenticated = false;
    notifyListeners();
  }
}