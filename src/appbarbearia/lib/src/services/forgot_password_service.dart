import 'dart:convert';
import 'package:http/http.dart' as http;

class ForgotPasswordService {
  static const String _baseUrl = 'http://localhost:3000';

  /// Envia o email de redefinição de senha.
  /// Retorna null em caso de sucesso ou uma mensagem de erro.
  Future<String?> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return null; // sucesso
    }

    throw Exception(data['message'] ?? 'Erro ao enviar email.');
  }
}