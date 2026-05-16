import 'package:flutter/material.dart';
import '../models/history_model.dart';
import '../services/auth_service.dart';
import '../services/history_service.dart';

class HistoricoViewModel extends ChangeNotifier {
  final _service = HistoricoService();
  final _authService = AuthService();

  List<HistoricoModel> agendamentos = [];
  bool isLoading = true;
  bool canceling = false;
  String? errorMessage;

  Future<void> loadHistorico() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final user = await _authService.getLoggedUser();
      if (user == null) {
        errorMessage = 'Usuário não identificado.';
        return;
      }

      agendamentos = await _service.getHistorico(user.id);

      // Ordena: futuros primeiro, depois passados
      agendamentos.sort((a, b) => b.dia.compareTo(a.dia));
    } catch (e) {
      errorMessage = 'Erro ao carregar histórico.';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Retorna null em sucesso ou mensagem de erro
  Future<String?> cancelar(int idAgendamento) async {
    canceling = true;
    notifyListeners();

    try {
      await _service.cancelarAgendamento(idAgendamento);

      // Atualiza o status localmente sem precisar recarregar tudo
      final index =
          agendamentos.indexWhere((a) => a.idAgendamento == idAgendamento);
      if (index != -1) {
        final atual = agendamentos[index];
        agendamentos[index] = HistoricoModel(
          idAgendamento: atual.idAgendamento,
          idUsuario: atual.idUsuario,
          nome: atual.nome,
          foto: atual.foto,
          descricaoServicos: atual.descricaoServicos,
          valorServicos: atual.valorServicos,
          valorTotal: atual.valorTotal,
          dia: atual.dia,
          hora: atual.hora,
          formaPagamento: atual.formaPagamento,
          status: 'cancelado',
        );
      }

      return null; // sucesso
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      canceling = false;
      notifyListeners();
    }
  }
}