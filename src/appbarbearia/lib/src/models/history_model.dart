class HistoricoModel {
  final int idAgendamento;
  final int idUsuario;
  final String nome;
  final String? foto;
  final String descricaoServicos;
  final String valorServicos;
  final double valorTotal;
  final DateTime dia;
  final String hora;
  final String formaPagamento;
  final String status;

  const HistoricoModel({
    required this.idAgendamento,
    required this.idUsuario,
    required this.nome,
    this.foto,
    required this.descricaoServicos,
    required this.valorServicos,
    required this.valorTotal,
    required this.dia,
    required this.hora,
    required this.formaPagamento,
    required this.status,
  });

  factory HistoricoModel.fromJson(Map<String, dynamic> json) {
    return HistoricoModel(
      idAgendamento: json['id_agendamento'] as int,
      idUsuario: json['id_usuario'] as int,
      nome: json['nome'] as String,
      foto: json['foto'] as String?,
      descricaoServicos: json['descricao servicos'] as String,
      valorServicos: json['valor servicos'] as String,
      valorTotal: double.parse(json['valor total'].toString()),
      dia: DateTime.parse(json['dia'] as String),
      hora: json['hora'] as String,
      formaPagamento: json['forma_pagamento'] as String,
      status: json['status'] as String,
    );
  }

  /// Verifica se pode ser cancelado (até 6h antes)
  bool get podeCancelar {
    if (status != 'confirmado') return false;

    final partes = hora.split(':');
    final horaAgendamento = DateTime(
      dia.year,
      dia.month,
      dia.day,
      int.parse(partes[0]),
      int.parse(partes[1]),
    );

    final limite = horaAgendamento.subtract(const Duration(hours: 6));
    return DateTime.now().isBefore(limite);
  }

  bool get isConcluido => status == 'concluido';
  bool get isCancelado => status == 'cancelado';
}