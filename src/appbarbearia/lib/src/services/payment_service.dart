import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_model.dart';

class PaymentService {
  static const String _baseUrl = 'http://localhost:3000';

  Future<List<PaymentModel>> getPayments() async {
    final response = await http.get(Uri.parse('$_baseUrl/payments'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((e) => PaymentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception(
        'Erro ao buscar formas de pagamento. Status: ${response.statusCode}');
  }
}