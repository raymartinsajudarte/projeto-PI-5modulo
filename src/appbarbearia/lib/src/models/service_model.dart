class ServiceModel {
  final int id;
  final String nome;
  final double valor;
  final int duracaoMinutos;

  const ServiceModel({
    required this.id,
    required this.nome,
    required this.valor,
    required this.duracaoMinutos,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        id: json['id_servico'] as int,
        nome: json['nome'] as String,
        valor: double.parse(json['valor'].toString()),
        duracaoMinutos: json['duracao_minutos'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id_servico': id,
        'nome': nome,
        'valor': valor.toStringAsFixed(2),
        'duracao_minutos': duracaoMinutos,
      };
}