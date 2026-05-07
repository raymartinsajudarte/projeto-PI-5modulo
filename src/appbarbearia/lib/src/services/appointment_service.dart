import 'dart:convert';
import 'package:http/http.dart' as http;

class AppointmentService {
  static const String _baseUrl = 'http://localhost:3000';

  /// Retorna os horários já agendados no formato "HH:mm" para uma data específica.
  Future<List<String>> getUnavailableTimes(DateTime dia) async {
    final response = await http.get(Uri.parse('$_baseUrl/appointments'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final String diaFormatted =
          '${dia.year.toString().padLeft(4, '0')}-'
          '${dia.month.toString().padLeft(2, '0')}-'
          '${dia.day.toString().padLeft(2, '0')}';

      return data
          .where((e) => e['dia'] == diaFormatted)
          .map((e) {
            final String hora = e['hora'] as String;
            return hora.substring(0, 5);
          })
          .toList()
          .cast<String>();
    }

    throw Exception(
        'Erro ao buscar agendamentos. Status: ${response.statusCode}');
  }

  /// Cria um novo agendamento e retorna o id gerado.
  Future<int> createAppointment({
    required int idUsuario,
    required int idPagamento,
    required double valorTotal,
    required DateTime dia,
    required String hora,
    required List<Map<String, dynamic>> servicos,
  }) async {
    final String diaFormatted =
        '${dia.year.toString().padLeft(4, '0')}-'
        '${dia.month.toString().padLeft(2, '0')}-'
        '${dia.day.toString().padLeft(2, '0')}';

    final body = jsonEncode({
      'id_usuario': idUsuario,
      'id_pagamento': idPagamento,
      'valor_total': valorTotal,
      'dia': diaFormatted,
      'hora': hora,
      'servicos': servicos,
    });

    final response = await http.post(
      Uri.parse('$_baseUrl/appointments'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['id'] as int;
    }

    final data = jsonDecode(response.body);
    throw Exception(
        data['message'] ??
            'Erro ao criar agendamento. Status: ${response.statusCode}');
  }
}