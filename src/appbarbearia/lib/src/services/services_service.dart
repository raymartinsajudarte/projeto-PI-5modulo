import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/service_model.dart';

class ServicesService {
  static const String _baseUrl = 'http://localhost:3000';

  Future<List<ServiceModel>> getServices() async {
    final response = await http.get(Uri.parse('$_baseUrl/services'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('Erro ao buscar serviços. Status: ${response.statusCode}');
  }
}