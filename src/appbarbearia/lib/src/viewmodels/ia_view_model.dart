import 'dart:math';

import 'package:flutter/material.dart';
import '../services/ia_service.dart';
import '../services/payment_service.dart';
import '../services/services_service.dart';

class ChatMessage {
  final String texto;
  final bool isUser;

  const ChatMessage({required this.texto, required this.isUser});
}

class DadosAgendamentoIA {
  final int servicoId;
  final int pagamentoId;
  final String diaEscolhido;
  final String horarioEscolhido;
  final String servicoLabel;
  final String pagamentoLabel;

  const DadosAgendamentoIA({
    required this.servicoId,
    required this.pagamentoId,
    required this.diaEscolhido,
    required this.horarioEscolhido,
    required this.servicoLabel,
    required this.pagamentoLabel,
  });
}

class IaViewModel extends ChangeNotifier {
  final _service = IaService();
  final _servicesService = ServicesService();
  final _paymentService = PaymentService();

  final String _sessionId =
      '${DateTime.now().microsecondsSinceEpoch}-${Random().nextInt(0x7FFFFFFF)}';

  final List<ChatMessage> mensagens = [];
  bool isLoading = false;
  bool atendimentoFinalizado = false;
  DadosAgendamentoIA? dadosAgendamento;

  IaViewModel() {
    mensagens.add(const ChatMessage(
      texto: 'Olá, precisa de ajuda para agendar um serviço?',
      isUser: false,
    ));
  }

  Future<void> enviarMensagem(String texto) async {
    if (texto.trim().isEmpty || isLoading || atendimentoFinalizado) return;

    mensagens.add(ChatMessage(texto: texto.trim(), isUser: true));
    isLoading = true;
    notifyListeners();

    try {
      final resposta = await _service.enviarMensagem(
        mensagem: texto.trim(),
        sessionId: _sessionId,
      );

      final mensagemIA =
          resposta['mensagem'] as String? ?? 'Desculpe, não entendi.';
      final finalizado =
          resposta['atendimento_finalizado'] as bool? ?? false;

      mensagens.add(ChatMessage(texto: mensagemIA, isUser: false));

      if (finalizado) {
        final servicoId = _parseId(resposta['servico_escolhido']);
        final pagamentoId = _parseId(resposta['pagamento_escolhido']);
        final dia = resposta['dia_escolhido']?.toString() ?? '';
        final horario = _normalizarHorario(resposta['horario_escolhido']);

        if (servicoId != null && pagamentoId != null && dia.isNotEmpty) {
          final labels = await _resolverLabels(servicoId, pagamentoId);
          atendimentoFinalizado = true;
          dadosAgendamento = DadosAgendamentoIA(
            servicoId: servicoId,
            pagamentoId: pagamentoId,
            diaEscolhido: dia,
            horarioEscolhido: horario,
            servicoLabel: labels.$1,
            pagamentoLabel: labels.$2,
          );
        }
      }
    } catch (e) {
      mensagens.add(const ChatMessage(
        texto: 'Erro ao conectar com a IA. Tente novamente.',
        isUser: false,
      ));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  int? _parseId(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  String _normalizarHorario(dynamic value) {
    if (value == null) return '';
    if (value is int) {
      return '${value.toString().padLeft(2, '0')}:00';
    }
    final s = value.toString().trim();
    if (!s.contains(':')) return s;
    final parts = s.split(':');
    final h = parts[0].padLeft(2, '0');
    final m = parts.length > 1 ? parts[1].padLeft(2, '0') : '00';
    return '$h:$m';
  }

  Future<(String, String)> _resolverLabels(int servicoId, int pagamentoId) async {
    var servicoLabel = 'Serviço #$servicoId';
    var pagamentoLabel = 'Pagamento #$pagamentoId';

    try {
      final servicos = await _servicesService.getServices();
      for (final s in servicos) {
        if (s.id == servicoId) {
          servicoLabel = s.nome;
          break;
        }
      }

      final pagamentos = await _paymentService.getPayments();
      for (final p in pagamentos) {
        if (p.id == pagamentoId) {
          pagamentoLabel = p.nome;
          break;
        }
      }
    } catch (_) {}

    return (servicoLabel, pagamentoLabel);
  }
}
