import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import 'dart:typed_data';

class EditUserViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _userService = UserService();
  final _picker = ImagePicker();

  UserModel? user;
  bool isLoading = true;
  bool submitting = false;

  XFile? _fotoSelecionada;
  Uint8List? fotoBytesPreview; // bytes para prévia na Web com Image.memory

  bool get temFotoLocal => _fotoSelecionada != null;

  Future<void> loadUser() async {
    isLoading = true;
    notifyListeners();

    user = await _authService.getLoggedUser();

    isLoading = false;
    notifyListeners();
  }

  Future<void> selecionarFoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 60, // reduzido para ficar abaixo dos 2MB do servidor
      maxWidth: 800,
      maxHeight: 800,
    );

    if (picked != null) {
      _fotoSelecionada = picked;
      fotoBytesPreview = await picked.readAsBytes();
      notifyListeners();
    }
  }

  Future<String?> salvar({
    required String nome,
    required String email,
    required String celular,
  }) async {
    if (user == null) return 'Usuário não identificado.';

    final temTexto = nome.isNotEmpty || email.isNotEmpty || celular.isNotEmpty;
    if (!temTexto && _fotoSelecionada == null) {
      return 'Preencha pelo menos um campo para salvar.';
    }

    submitting = true;
    notifyListeners();

    try {
      if (temTexto) {
        await _userService.updateUser(
          id: user!.id,
          nome: nome.isNotEmpty ? nome : null,
          email: email.isNotEmpty ? email : null,
          celular: celular.isNotEmpty
              ? celular.replaceAll(RegExp(r'\D'), '')
              : null,
        );
      }

      String? novaFotoUrl;
      if (_fotoSelecionada != null && fotoBytesPreview != null) {
        novaFotoUrl = await _userService.uploadFoto(
          id: user!.id,
          bytes: fotoBytesPreview!,
          fileName: _fotoSelecionada!.name,
        );
        print('url:$novaFotoUrl');
      }

      final usuarioAtualizado = UserModel(
        id: user!.id,
        nome: nome.isNotEmpty ? nome : user!.nome,
        nomeUsuario: user!.nomeUsuario,
        email: email.isNotEmpty ? email : user!.email,
        foto: novaFotoUrl ?? user!.foto,
        celular: celular.isNotEmpty
            ? celular.replaceAll(RegExp(r'\D'), '')
            : user!.celular,
        perfil: user!.perfil,
      );

      await _authService.saveLoggedUser(usuarioAtualizado);
      user = usuarioAtualizado;
      _fotoSelecionada = null;
      fotoBytesPreview = null;

      return null; // sucesso
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      submitting = false;
      notifyListeners();
    }
  }
}
