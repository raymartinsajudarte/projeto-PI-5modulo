import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class PerfilViewModel extends ChangeNotifier {
  final _authService = AuthService();

  UserModel? user;
  bool isLoading = true;

  Future<void> loadUser() async {
    isLoading = true;
    notifyListeners();

    user = await _authService.getLoggedUser();

    PaintingBinding.instance.imageCache.clear();

    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
