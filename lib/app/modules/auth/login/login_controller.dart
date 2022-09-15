import 'package:todo_list/app/exception/auth_exception.dart';
import 'package:todo_list/app/services/user/user_service.dart';
import 'package:todo_list/core/notifier/default_change_notifier.dart';

class LoginController extends DefaultChangeNotifier {
  final UserService _userService;
  String? infoMessage;

  LoginController({required UserService userService})
      : _userService = userService;

  bool get hasInfo => infoMessage != null;

  Future<void> login({required String email, required String password}) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();
      final user = await _userService.login(email, password);
      if (user != null) {
        success();
      } else {
        setError('Usuário ou senha inválidos');
      }
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> forgotPassword({required String email}) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();
      await _userService.forgotPassword(email);
      infoMessage = 'Reset de senha enviado para o seu e-mail';
    } on AuthException catch (e) {
      setError(e.message);
    } catch (e) {
      setError('Erro ao resetar a senha');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> googleLogin() async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();
      final user = await _userService.googleLogin();
      if (user != null) {
        success();
      } else {
        _userService.logout();
        setError('Erro ao realizar login com o Google');
      }
    } on AuthException catch (e) {
      _userService.logout();
      setError(e.message);
    } catch (e) {
      _userService.logout();
      setError('Erro ao realizar login com o Google');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
