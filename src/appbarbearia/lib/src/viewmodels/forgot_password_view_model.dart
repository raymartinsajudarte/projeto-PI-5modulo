import 'package:flutter/material.dart';
import '../services/forgot_password_service.dart';

class ForgotPasswordViewModel extends ChangeNotifier {
  final _service = ForgotPasswordService();

  bool isLoading = false;

  /// Retorna null em caso de sucesso ou uma mensagem de erro.
  Future<String?> enviarEmail(String email) async {
    if (email.isEmpty) return 'Preencha o email.';

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(email)) return 'Email inválido.';

    isLoading = true;
    notifyListeners();

    try {
      await _service.forgotPassword(email);
      return null; // sucesso
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}