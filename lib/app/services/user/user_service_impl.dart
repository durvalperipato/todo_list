import 'package:firebase_auth/firebase_auth.dart';
import 'package:todo_list/app/repositories/user/user_repository.dart';
import 'package:todo_list/app/services/user/user_service.dart';

class UserServiceImpl implements UserService {
  final UserRepository _userRepository;

  UserServiceImpl(UserRepository userRepository)
      : _userRepository = userRepository;

  @override
  Future<User?> register(String email, String password) {
    return _userRepository.register(email, password);
  }

  @override
  Future<User?> login(String email, String password) {
    return _userRepository.login(email, password);
  }

  @override
  Future<void> forgotPassword(String email) {
    return _userRepository.forgotPassword(email);
  }

  @override
  Future<User?> googleLogin() {
    return _userRepository.googleLogin();
  }

  @override
  Future<void> logout() {
    return _userRepository.logout();
  }

  @override
  Future<void> updateDisplayName(String name) {
    return _userRepository.updateDisplayName(name);
  }
}
