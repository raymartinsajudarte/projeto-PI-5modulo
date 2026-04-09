class RegisterResponseModel {
  final int idUsuario;
  final String nome;
  final String nomeUsuario;
  final String email;

  RegisterResponseModel({
    required this.idUsuario,
    required this.nome,
    required this.nomeUsuario,
    required this.email,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      idUsuario: json['id_usuario'],
      nome: json['nome'],
      nomeUsuario: json['nome_usuario'],
      email: json['email'],
    );
  }
}
