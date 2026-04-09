class UserModel {
  final int id;
  final String nome;
  final String email;

  UserModel({
    required this.id,
    required this.nome,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
    );
  }
}

class LoginResponseModel {
  final String message;
  final UserModel? user;

  LoginResponseModel({
    required this.message,
    this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      message: json['message'] ?? 'Credencias Invalidas!',
      user: json['user'] != null
          ? UserModel.fromJson(json['user'])
          : null,
    );
  }
}