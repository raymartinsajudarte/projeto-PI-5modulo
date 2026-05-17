import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/history_model.dart';

class HistoricoService {
  static const String _baseUrl = 'http://localhost:3000';

  Future<List<HistoricoModel>> getHistorico(int idUsuario) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/appointments/history/$idUsuario'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => HistoricoModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Erro ao buscar histórico.');
  }

  Future<void> cancelarAgendamento(int idAgendamento) async {
    final response = await http.patch(
      Uri.parse('$_baseUrl/appointments/$idAgendamento/cancel'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      final data = jsonDecode(response.body);
      throw Exception(data['error'] ?? 'Erro ao cancelar agendamento.');
    }
  }
}