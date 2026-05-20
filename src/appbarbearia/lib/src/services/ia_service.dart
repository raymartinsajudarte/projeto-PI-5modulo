import 'dart:convert';
import 'package:http/http.dart' as http;

class IaService {
  static const String _baseUrl = 'http://localhost:3000';

  Future<Map<String, dynamic>> enviarMensagem({
    required String mensagem,
    required String sessionId,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/ia/chat'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'mensagem': mensagem,
        'sessionId': sessionId,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data as Map<String, dynamic>;
    }

    throw Exception(data['error'] ?? 'Erro ao enviar mensagem.');
  }
}
