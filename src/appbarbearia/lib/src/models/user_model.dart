class UserModel {
  final int id;
  final String nome;
  final String nomeUsuario;
  final String email;
  final String? foto;
  final String perfil;

  UserModel({
    required this.id,
    required this.nome,
    required this.nomeUsuario,
    required this.email,
    this.foto,
    required this.perfil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nome: json['nome'],
      nomeUsuario: json['nome_usuario'],
      email: json['email'],
      foto: json['foto'],
      perfil: json['perfil'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'nome_usuario': nomeUsuario,
      'email': email,
      'foto': foto,
      'perfil': perfil,
    };
  }
}