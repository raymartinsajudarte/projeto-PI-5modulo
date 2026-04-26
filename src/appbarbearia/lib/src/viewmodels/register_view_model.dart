import 'package:flutter/material.dart';
import '../services/register_service.dart';

class RegisterViewModel extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  /// Retorna true em caso de sucesso, false em caso de erro.
  Future<bool> register({
    required String nome,
    required String nomeUsuario,
    required String email,
    required String celular,
    required String senha,
  }) async {
    if (nome.isEmpty ||
        nomeUsuario.isEmpty ||
        email.isEmpty ||
        celular.isEmpty ||
        senha.isEmpty) {
      errorMessage = 'Preencha todos os campos!';
      notifyListeners();
      return false;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await RegisterService().register(
        nome: nome,
        nomeUsuario: nomeUsuario,
        celular: celular,
        email: email,
        senha: senha,
      );
      return true;
    } catch (e) {
      errorMessage = 'Erro ao conectar: $e';
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}