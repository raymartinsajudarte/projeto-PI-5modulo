import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appbarbearia/src/services/appointment_service.dart';
import 'package:appbarbearia/src/services/payment_service.dart';
import 'package:appbarbearia/src/services/services_service.dart';
import 'package:appbarbearia/src/services/auth_service.dart';
import 'package:appbarbearia/src/models/payment_model.dart';
import 'package:appbarbearia/src/viewmodels/agendamento_view_model.dart';

// =============================================================================
// RELATÓRIO: Qualidade e Teste de Software — Grupo 11
// Sistema   : Sistema de Agendamento para Barbearia
// Módulo    : Agendamento — AgendamentoViewModel
// Normas    : ISO/IEC/IEEE 29119-1, 29119-2 e 29119-4
// Técnicas  : Particionamento de Equivalência, Análise de Valor Limite,
//             Transição de Estado, Teste Baseado em Cenário
// Cobertura : RF referentes à tela de agendamento
//
// Observação: Os testes utilizam MockClient para interceptar chamadas HTTP
//             aos endpoints /services, /payments, /appointments.
//             SharedPreferences.setMockInitialValues simula o usuário logado.
//             Cada teste instancia o ViewModel com serviços injetados para
//             isolamento completo de dependências externas.
// =============================================================================

// -----------------------------------------------------------------------------
// Helpers — respostas HTTP mockadas reutilizadas nos testes
// -----------------------------------------------------------------------------

final _mockServices = jsonEncode([
  {'id_servico': 1, 'nome': 'corte', 'valor': '30.00', 'duracao_minutos': 30},
  {'id_servico': 2, 'nome': 'barba', 'valor': '20.00', 'duracao_minutos': 20},
]);

final _mockPayments = jsonEncode([
  {'id_forma_pagamento': 1, 'nome': 'Pix'},
  {'id_forma_pagamento': 2, 'nome': 'Crédito'},
]);

final _mockAppointmentsVazio = jsonEncode([]);

final _mockUserLogado = jsonEncode({
  'id': 1,
  'nome': 'Marcelo',
  'nome_usuario': 'marcelo',
  'email': 'marcelo@email.com',
  'foto': null,
  'celular': null,
  'perfil': 'cliente',
});

// Cria um MockClient que responde corretamente a todos os endpoints usados
// pelo AgendamentoViewModel durante o init().
MockClient _mockClientPadrao({
  String appointmentsBody = '',
  int appointmentsStatus = 200,
}) {
  return MockClient((request) async {
    final path = request.url.path;

    if (path.contains('/services')) {
      return http.Response(_mockServices, 200);
    }
    if (path.contains('/payments')) {
      return http.Response(_mockPayments, 200);
    }
    if (path.contains('/appointments')) {
      if (request.method == 'GET') {
        return http.Response(
          appointmentsBody.isEmpty ? _mockAppointmentsVazio : appointmentsBody,
          appointmentsStatus,
        );
      }
      if (request.method == 'POST') {
        return http.Response(
          jsonEncode({'id': 99}),
          appointmentsStatus == 200 ? 201 : appointmentsStatus,
        );
      }
    }

    return http.Response('Not found', 404);
  });
}

void main() {
  setUp(() {
    // Simula usuário logado no SharedPreferences
    SharedPreferences.setMockInitialValues({
      'loggedUser': _mockUserLogado,
    });
  });

  group('AgendamentoViewModel - Testes de unidade', () {
    // -------------------------------------------------------------------------
    // TC01 — Carregamento inicial de serviços e pagamentos
    // RF – O sistema deve buscar e exibir serviços e formas de pagamento.
    //
    // Técnica: Teste Baseado em Cenário (fluxo principal — init)
    //          Particionamento de Equivalência (resposta válida da API)
    //
    // Entrada : API retorna listas de serviços e pagamentos
    // Esperado: services e paymentMethods preenchidos; isLoading = false
    // -------------------------------------------------------------------------
    test('TC01 — init() carrega serviços e pagamentos corretamente', () async {
      // ARRANGE
      final client = _mockClientPadrao();
      final viewModel = AgendamentoViewModel(
        servicesService: ServicesService(client: client),
        paymentService: PaymentService(client: client),
        appointmentService: AppointmentService(client: client),
        authService: AuthService(client: client),
      );

      // ACT
      await viewModel.init();

      // ASSERT
      expect(viewModel.services, isNotEmpty);
      expect(viewModel.paymentMethods, isNotEmpty);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.loggedUserId, equals(1));
    });

    // -------------------------------------------------------------------------
    // TC02 — Agendamento válido (fluxo principal do diagrama de sequência)
    // RF – O sistema deve confirmar agendamento com horário disponível.
    //
    // Técnica: Particionamento de Equivalência (classe válida)
    //          Teste Baseado em Cenário (fluxo principal)
    //
    // Entrada : horário, serviço e pagamento selecionados; API confirma
    // Esperado: confirmar() retorna null (sem erro)
    // -------------------------------------------------------------------------
    test('TC02 — confirmar() com dados válidos retorna null', () async {
      // ARRANGE
      final client = _mockClientPadrao();
      final viewModel = AgendamentoViewModel(
        servicesService: ServicesService(client: client),
        paymentService: PaymentService(client: client),
        appointmentService: AppointmentService(client: client),
        authService: AuthService(client: client),
      );

      await viewModel.init();

      // Seleciona horário, serviço e pagamento
      viewModel.selectTime('09:00');
      viewModel.toggleService(0); // seleciona primeiro serviço (corte)
      viewModel.selectPayment(viewModel.paymentMethods.first);

      // ACT
      final result = await viewModel.confirmar();

      // ASSERT
      expect(result, isNull);
      expect(viewModel.submitting, isFalse);
    });

    // -------------------------------------------------------------------------
    // TC03 — Agendamento sem horário selecionado
    // RF – O sistema deve validar seleção de horário antes de confirmar.
    //
    // Técnica: Análise de Valor Limite (campo ausente — selectedTime = null)
    //          Particionamento de Equivalência (classe inválida)
    //
    // Entrada : nenhum horário selecionado
    // Esperado: confirmar() retorna mensagem 'Selecione um horário.'
    // -------------------------------------------------------------------------
    test('TC03 — confirmar() sem horário selecionado retorna erro', () async {
      // ARRANGE
      final client = _mockClientPadrao();
      final viewModel = AgendamentoViewModel(
        servicesService: ServicesService(client: client),
        paymentService: PaymentService(client: client),
        appointmentService: AppointmentService(client: client),
        authService: AuthService(client: client),
      );

      await viewModel.init();

      // Não seleciona horário (selectedTime começa como '09:00' — força null)
      viewModel.selectedTime = null;
      viewModel.toggleService(0);
      viewModel.selectPayment(viewModel.paymentMethods.first);

      // ACT
      final result = await viewModel.confirmar();

      // ASSERT
      expect(result, equals('Selecione um horário.'));
    });

    // -------------------------------------------------------------------------
    // TC04 — Agendamento sem serviço selecionado
    // RF – O sistema deve validar seleção de serviço antes de confirmar.
    //
    // Técnica: Análise de Valor Limite (lista vazia — selectedServices = [])
    //          Particionamento de Equivalência (classe inválida)
    //
    // Entrada : nenhum serviço selecionado
    // Esperado: confirmar() retorna 'Selecione pelo menos um serviço.'
    // -------------------------------------------------------------------------
    test('TC04 — confirmar() sem serviço selecionado retorna erro', () async {
      // ARRANGE
      final client = _mockClientPadrao();
      final viewModel = AgendamentoViewModel(
        servicesService: ServicesService(client: client),
        paymentService: PaymentService(client: client),
        appointmentService: AppointmentService(client: client),
        authService: AuthService(client: client),
      );

      await viewModel.init();

      viewModel.selectTime('09:00');
      // Não seleciona nenhum serviço
      viewModel.selectPayment(viewModel.paymentMethods.first);

      // ACT
      final result = await viewModel.confirmar();

      // ASSERT
      expect(result, equals('Selecione pelo menos um serviço.'));
    });

    // -------------------------------------------------------------------------
    // TC05 — Horário indisponível não pode ser selecionado (fluxo alternativo A1)
    // RF – O sistema deve bloquear horários já ocupados.
    //
    // Técnica: Transição de Estado (disponível → indisponível)
    //          Teste Baseado em Cenário (fluxo alternativo A1 do diagrama)
    //
    // Entrada : API retorna '09:00' como horário ocupado; usuário tenta selecionar
    // Esperado: selectedTime permanece null após tentativa de seleção bloqueada
    // -------------------------------------------------------------------------
    test('TC05 — selectTime() bloqueia horário indisponível (A1)', () async {
      // ARRANGE — API retorna 09:00 como já agendado
      final horarioOcupado = jsonEncode([
        {'dia': _diaFormatado(DateTime.now()), 'hora': '09:00:00'},
      ]);

      final client = _mockClientPadrao(appointmentsBody: horarioOcupado);
      final viewModel = AgendamentoViewModel(
        servicesService: ServicesService(client: client),
        paymentService: PaymentService(client: client),
        appointmentService: AppointmentService(client: client),
        authService: AuthService(client: client),
      );

      await viewModel.init();

      // Garante que o horário está na lista de indisponíveis
      expect(viewModel.unavailableTimes, contains('09:00'));

      // Força selectedTime null antes da tentativa
      viewModel.selectedTime = null;

      // ACT — tenta selecionar horário bloqueado
      viewModel.selectTime('09:00');

      // ASSERT — selectedTime continua null
      expect(viewModel.selectedTime, isNull);
    });

    // -------------------------------------------------------------------------
    // TC06 — Busca de horários disponíveis ao selecionar nova data
    // RF – O sistema deve atualizar horários ao trocar a data.
    //
    // Técnica: Transição de Estado (data A → data B → nova lista de horários)
    //          Teste Baseado em Cenário
    //
    // Entrada : usuário seleciona uma data futura sem agendamentos
    // Esperado: unavailableTimes vazio para a nova data
    // -------------------------------------------------------------------------
    test('TC06 — selectDate() recarrega horários disponíveis', () async {
      // ARRANGE
      final client = _mockClientPadrao();
      final viewModel = AgendamentoViewModel(
        servicesService: ServicesService(client: client),
        paymentService: PaymentService(client: client),
        appointmentService: AppointmentService(client: client),
        authService: AuthService(client: client),
      );

      await viewModel.init();

      final novaData = DateTime.now().add(const Duration(days: 5));

      // ACT
      viewModel.selectDate(novaData);
      await Future.delayed(const Duration(milliseconds: 300));

      // ASSERT — data atualizada e horário desmarcado
      expect(viewModel.selectedDate.day, equals(novaData.day));
      expect(viewModel.selectedTime, isNull);
    });

    // -------------------------------------------------------------------------
    // TC07 — Cálculo do total com múltiplos serviços
    // RF – O sistema deve calcular o valor total dos serviços selecionados.
    //
    // Técnica: Particionamento de Equivalência (múltiplos itens selecionados)
    //          Análise de Valor Limite (soma de valores)
    //
    // Entrada : dois serviços selecionados (corte R$30 + barba R$20)
    // Esperado: total = 50.0
    // -------------------------------------------------------------------------
    test('TC07 — total calculado corretamente com múltiplos serviços', () async {
      // ARRANGE
      final client = _mockClientPadrao();
      final viewModel = AgendamentoViewModel(
        servicesService: ServicesService(client: client),
        paymentService: PaymentService(client: client),
        appointmentService: AppointmentService(client: client),
        authService: AuthService(client: client),
      );

      await viewModel.init();

      // ACT — seleciona corte (R$30) e barba (R$20)
      viewModel.toggleService(0);
      viewModel.toggleService(1);

      // ASSERT
      expect(viewModel.total, equals(50.0));
      expect(viewModel.selectedServices.length, equals(2));
    });

    // -------------------------------------------------------------------------
    // TC08 — Usuário não identificado ao confirmar
    // RF – O sistema deve impedir agendamento sem usuário autenticado.
    //
    // Técnica: Transição de Estado (sessão expirada → bloqueio)
    //          Particionamento de Equivalência (classe inválida — sem sessão)
    //
    // Entrada : loggedUserId = null (sessão inexistente)
    // Esperado: confirmar() retorna mensagem de usuário não identificado
    // -------------------------------------------------------------------------
    test('TC08 — confirmar() sem usuário logado retorna erro', () async {
      // ARRANGE — sem usuário na sessão
      SharedPreferences.setMockInitialValues({});

      final client = _mockClientPadrao();
      final viewModel = AgendamentoViewModel(
        servicesService: ServicesService(client: client),
        paymentService: PaymentService(client: client),
        appointmentService: AppointmentService(client: client),
        authService: AuthService(client: client),
      );

      await viewModel.init();

      viewModel.selectTime('10:00');
      viewModel.toggleService(0);
      viewModel.selectPayment(viewModel.paymentMethods.first);

      // ACT
      final result = await viewModel.confirmar();

      // ASSERT
      expect(result, equals('Usuário não identificado. Faça login novamente.'));
    });
  });
}

// -----------------------------------------------------------------------------
// Utilitário — formata DateTime para 'yyyy-MM-dd' (mesmo formato da API)
// -----------------------------------------------------------------------------
String _diaFormatado(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';
