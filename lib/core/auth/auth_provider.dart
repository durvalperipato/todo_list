import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/app/services/user/user_service.dart';
import 'package:todo_list/core/navigator/todo_list_navigator.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth;
  final UserService _userService;
  late String? userEmail;

  AuthProvider(
      {required FirebaseAuth firebaseAuth, required UserService userService})
      : _firebaseAuth = firebaseAuth,
        _userService = userService;

  Future<void> logout() => _userService.logout();
  User? get user => _firebaseAuth.currentUser;

  void loadListener() {
    _firebaseAuth.userChanges().listen((_) => notifyListeners());
    _firebaseAuth.authStateChanges().listen((user) {
      if (user != null) {
        userEmail = user.email;
        TodoListNavigator.to.pushNamedAndRemoveUntil(
          '/home',
          (route) => false,
        );
      } else {
        TodoListNavigator.to
            .pushNamedAndRemoveUntil('/login', (route) => false);
      }
    });
  }
}
