import 'user_model.dart';

class LoginResponseModel {
  final String message;
  final UserModel? user;

  LoginResponseModel({
    required this.message,
    this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] ?? 'Credenciais inválidas!',
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }
}