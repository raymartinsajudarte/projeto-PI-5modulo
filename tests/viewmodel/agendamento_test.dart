import 'package:flutter_test/flutter_test.dart';
import 'package:appbarbearia/core/ui/ui_event.dart';
import 'package:appbarbearia/features/agendamento/data/repository/agendamento_repository_impl.dart';
import 'package:appbarbearia/features/agendamento/data/service/fake_agendamento_service.dart';
import 'package:appbarbearia/features/agendamento/model/agendamento_model.dart';
import 'package:appbarbearia/features/agendamento/viewmodel/agendamento_viewmodel.dart';

void main() {
  late FakeAgendamentoService service;
  late AgendamentoRepositoryImpl repository;
  late AgendamentoViewModel viewModel;

  setUp(() {
    service = FakeAgendamentoService();
    repository = AgendamentoRepositoryImpl(service);
    viewModel = AgendamentoViewModel(repository);
  });

  group('AgendamentoViewModel - Testes de unidade', () {
    // -------------------------------------------------------------------------
    // TC01 — Agendamento válido (fluxo principal do diagrama de sequência)
    // -------------------------------------------------------------------------
    test('TC01 — Agendamento válido com horário disponível', () async {
      // ARRANGE
      final agendamento = AgendamentoModel(
        clienteNome: 'João Marcolino',
        data: DateTime(2025, 7, 10),
        horario: '10:00',
        servico: 'Corte de cabelo',
        formaPagamento: 'Cartão',
      );

      // Pré-popula o serviço com o horário disponível
      await service.adicionarHorarioDisponivel(
        data: DateTime(2025, 7, 10),
        horario: '10:00',
      );

      // ACT
      await viewModel.realizarAgendamento(agendamento);

      // ASSERT — Confirmação de agendamento e navegação para tela de sucesso
      expect(
        viewModel.agendamentoNavigationEvent,
        AgendamentoNavigationEvent.goToConfirmacao,
      );

      expect(
        viewModel.uiMessage,
        isNull,
      );
    });

    // -------------------------------------------------------------------------
    // TC02 — Campos obrigatórios vazios
    // -------------------------------------------------------------------------
    test('TC02 — Agendamento com campos obrigatórios vazios', () async {
      // ARRANGE
      final agendamento = AgendamentoModel(
        clienteNome: '',
        data: null,
        horario: '',
        servico: '',
        formaPagamento: '',
      );

      // ACT
      await viewModel.realizarAgendamento(agendamento);

      // ASSERT
      expect(
        viewModel.uiMessage?.message,
        'Preencha todos os campos obrigatórios.',
      );

      expect(
        viewModel.agendamentoNavigationEvent,
        AgendamentoNavigationEvent.none,
      );
    });

    // -------------------------------------------------------------------------
    // TC03 — Horário indisponível (fluxo alternativo A1 do diagrama)
    // -------------------------------------------------------------------------
    test('TC03 — Agendamento com horário indisponível (A1)', () async {
      // ARRANGE
      // Ocupa o horário com outro agendamento existente
      await service.adicionarAgendamentoExistente(
        data: DateTime(2025, 7, 10),
        horario: '10:00',
      );

      final agendamento = AgendamentoModel(
        clienteNome: 'Eduardo',
        data: DateTime(2025, 7, 10),
        horario: '10:00',
        servico: 'Barba Completa',
        formaPagamento: 'Pix',
      );

      // ACT
      await viewModel.realizarAgendamento(agendamento);

      // ASSERT — Sistema solicita nova escolha ao usuário
      expect(
        viewModel.uiMessage?.message,
        'Horário indisponível. Por favor, escolha outro horário.',
      );

      expect(
        viewModel.agendamentoNavigationEvent,
        AgendamentoNavigationEvent.none,
      );
    });

    // -------------------------------------------------------------------------
    // TC04 — Carregamento de horários disponíveis no calendário
    // -------------------------------------------------------------------------
    test('TC04 — Buscar horários disponíveis para uma data', () async {
      // ARRANGE
      await service.adicionarHorarioDisponivel(
        data: DateTime(2025, 7, 10),
        horario: '09:00',
      );
      await service.adicionarHorarioDisponivel(
        data: DateTime(2025, 7, 10),
        horario: '10:00',a
      );
      await service.adicionarHorarioDisponivel(
        data: DateTime(2025, 7, 10),
        horario: '14:00',
      );

      // ACT
      await viewModel.carregarHorariosDisponiveis(DateTime(2025, 7, 10));

      // ASSERT — Lista com os horários retornados
      expect(viewModel.horariosDisponiveis, isNotEmpty);
      expect(viewModel.horariosDisponiveis.length, equals(3));
      expect(viewModel.horariosDisponiveis, containsAll(['09:00', '10:00', '14:00']));
    });

    // -------------------------------------------------------------------------
    // TC05 — Data não selecionada ao tentar agendar
    // -------------------------------------------------------------------------
    test('TC05 — Agendamento sem data selecionada', () async {
      // ARRANGE
      final agendamento = AgendamentoModel(
        clienteNome: 'Carlos Pereira',
        data: null,
        horario: '11:00',
        servico: 'Corte e barba',
        formaPagamento: 'Dinheiro',
      );

      // ACT
      await viewModel.realizarAgendamento(agendamento);

      // ASSERT
      expect(
        viewModel.uiMessage?.message,
        'Preencha todos os campos obrigatórios.',
      );

      expect(
        viewModel.agendamentoNavigationEvent,
        AgendamentoNavigationEvent.none,
      );
    });

    // -------------------------------------------------------------------------
    // TC06 — Agendamento válido e navegação para tela de confirmação
    // -------------------------------------------------------------------------
    test('TC06 — Navegação para tela de confirmação após agendamento válido', () async {
      // ARRANGE
      await service.adicionarHorarioDisponivel(
        data: DateTime(2025, 7, 15),
        horario: '15:00',
      );

      final agendamento = AgendamentoModel(
        clienteNome: 'Mateus Silva',
        data: DateTime(2025, 7, 15),
        horario: '15:00',
        servico: 'corte de cabelo',
        formaPagamento: 'Pix',
      );

      // ACT
      await viewModel.realizarAgendamento(agendamento);

      // ASSERT — Navega para confirmação e não exibe erro
      expect(
        viewModel.agendamentoNavigationEvent,
        AgendamentoNavigationEvent.goToConfirmacao,
      );

      expect(viewModel.uiMessage, isNull);
    });
  });
}
