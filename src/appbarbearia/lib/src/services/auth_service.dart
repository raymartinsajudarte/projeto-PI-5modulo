import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_response_model.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:3000';

  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'nome_usuario': username,
        'senha': password,
      }),
    );

    final data = jsonDecode(response.body);

    return LoginResponseModel.fromJson(data);
  }
}