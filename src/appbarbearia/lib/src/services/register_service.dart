import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/register_response_model.dart';

class RegisterService {
  static const String baseUrl = 'http://localhost:3000';

  Future<RegisterResponseModel> register({
    required String nome,
    required String nomeUsuario,
    required String email,
    required String senha,
  }) async {
    final url = Uri.parse('$baseUrl/users');

    final res = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nome': nome,
        'nome_usuario': nomeUsuario,
        'email': email,
        'senha': senha,
      }),
    );

    final data = jsonDecode(res.body);

    return RegisterResponseModel.fromJson(data);
  }
}