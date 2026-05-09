import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginViewModel extends ChangeNotifier {
  final _authService = AuthService();

  bool isLoading = false;
  String? errorMessage;

  /// Retorna true em caso de sucesso, false em caso de erro.
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    if (username.isEmpty || password.isEmpty) {
      errorMessage = 'Preencha todos os campos!';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final res = await _authService.login(
        username: username,
        password: password,
      );

      if (res.user != null) {
        return true;
      } else {
        errorMessage = res.message;
        return false;
      }
    } catch (e) {
      errorMessage = 'Erro ao conectar: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}