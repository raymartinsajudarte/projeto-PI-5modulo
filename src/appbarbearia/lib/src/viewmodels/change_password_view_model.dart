import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class ChangePasswordViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _userService = UserService();

  bool isLoading = false;

  Future<String?> alterarSenha({
    required String novaSenha,
    required String confirmarSenha,
  }) async {
    if (novaSenha.isEmpty || confirmarSenha.isEmpty) {
      return 'Preencha todos os campos.';
    }

    if (novaSenha.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres.';
    }

    if (novaSenha != confirmarSenha) {
      return 'As senhas não coincidem.';
    }

    final user = await _authService.getLoggedUser();
    if (user == null) return 'Usuário não identificado.';

    isLoading = true;
    notifyListeners();

    try {
      await _userService.updateUser(
        id: user.id,
        senha: novaSenha,
      );
      return null; 
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}