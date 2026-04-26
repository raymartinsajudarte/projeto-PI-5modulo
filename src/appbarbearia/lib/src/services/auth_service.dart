import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/login_response_model.dart';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:3000';

  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

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

    final loginResponse = LoginResponseModel.fromJson(data);

    if (loginResponse.user != null) {
      await saveLoggedUser(loginResponse.user!);
    }

    return loginResponse;
  }

  Future<void> saveLoggedUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'loggedUser',
      jsonEncode(user.toJson()),
    );
  }

  Future<UserModel?> getLoggedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('loggedUser');

    if (userString == null) return null;

    final Map<String, dynamic> userMap = jsonDecode(userString);
    return UserModel.fromJson(userMap);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedUser');
  }
}