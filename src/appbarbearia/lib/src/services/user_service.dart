import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserService {
  static const String _baseUrl = 'http://localhost:3000';

  Future<String> updateUser({
    required int id,
    String? nome,
    String? email,
    String? celular,
  }) async {
    final body = <String, dynamic>{};
    if (nome != null && nome.isNotEmpty) body['nome'] = nome;
    if (email != null && email.isNotEmpty) body['email'] = email;
    if (celular != null && celular.isNotEmpty) body['celular'] = celular;

    final response = await http.put(
      Uri.parse('$_baseUrl/users/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data['message'] ?? 'Atualizado com sucesso!';
    }

    throw Exception(data['message'] ?? 'Erro ao atualizar usuário.');
  }

  Future<String> uploadFoto({
    required int id,
    required List<int> bytes,
    required String fileName,
  }) async {
    final uri = Uri.parse('$_baseUrl/users/$id/foto');
    final request = http.MultipartRequest('POST', uri);

    final ext = fileName.split('.').last.toLowerCase();
    final mimeType = ext == 'png' ? 'png' : 'jpeg';

    request.files.add(
      http.MultipartFile.fromBytes(
        'foto',
        bytes,
        filename: fileName,
        contentType: MediaType('image', mimeType), 
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final path = data['foto'] as String;
      if (path.startsWith('/')) {
        return 'http://localhost:3000$path';
      }
      return path;
    }

    throw Exception(data['message'] ?? 'Erro ao enviar foto.');
  }
}
