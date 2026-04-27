class ServicoItem {
  final int idServico;
  final double valorUnitario;

  ServicoItem({
    required this.idServico,
    required this.valorUnitario,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_servico": idServico,
      "valor_unitario": valorUnitario,
    };
  }
}

class AppointmentModel {
  final int idUsuario;
  final int idPagamento;
  final double valorTotal;
  final String dia;
  final String hora;
  final List<ServicoItem> servicos;

  AppointmentModel({
    required this.idUsuario,
    required this.idPagamento,
    required this.valorTotal,
    required this.dia,
    required this.hora,
    required this.servicos,
  });

  Map<String, dynamic> toJson() {
    return {
      "id_usuario": idUsuario,
      "id_pagamento": idPagamento,
      "valor_total": valorTotal,
      "dia": dia,
      "hora": hora,
      "servicos": servicos.map((e) => e.toJson()).toList(),
    };
  }
}