class PaymentModel {
  final int id;
  final String nome;

  const PaymentModel({
    required this.id,
    required this.nome,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        id: json['id_forma_pagamento'] as int,
        nome: json['nome'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id_forma_pagamento': id,
        'nome': nome,
      };
}