import 'package:flutter/material.dart';
import '../services/ia_service.dart';

class ChatMessage {
  final String texto;
  final bool isUser;

  const ChatMessage({required this.texto, required this.isUser});
}

class DadosAgendamentoIA {
  final String servicoEscolhido;
  final String diaEscolhido;
  final String horarioEscolhido;
  final String pagamentoEscolhido;

  const DadosAgendamentoIA({
    required this.servicoEscolhido,
    required this.diaEscolhido,
    required this.horarioEscolhido,
    required this.pagamentoEscolhido,
  });
}

class IaViewModel extends ChangeNotifier {
  final _service = IaService();

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
      final resposta = await _service.enviarMensagem(texto.trim());

      final mensagemIA =
          resposta['mensagem'] as String? ?? 'Desculpe, não entendi.';
      final finalizado =
          resposta['atendimento_finalizado'] as bool? ?? false;

      mensagens.add(ChatMessage(texto: mensagemIA, isUser: false));

      if (finalizado) {
        atendimentoFinalizado = true;
        dadosAgendamento = DadosAgendamentoIA(
          servicoEscolhido:
              resposta['servico_escolhido'] as String? ?? '',
          diaEscolhido: resposta['dia_escolhido'] as String? ?? '',
          horarioEscolhido:
              resposta['horario_escolhido'] as String? ?? '',
          pagamentoEscolhido:
              resposta['pagamento_escolhido'] as String? ?? '',
        );
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
}