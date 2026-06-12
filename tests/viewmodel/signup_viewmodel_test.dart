import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_barbearia/core/ui/ui_event.dart';
import 'package:projeto_barbearia/features/auth/data/repository/auth_repository_impl.dart';
import 'package:projeto_barbearia/features/auth/data/service/fake_auth_service.dart';
import 'package:projeto_barbearia/features/auth/model/user_model.dart';
import 'package:projeto_barbearia/features/auth/viewmodel/signup_viewmodel.dart';

// =============================================================================
// RELATÓRIO: Qualidade e Teste de Software — Grupo 11
// Sistema   : Sistema de Agendamento para Barbearia
// Módulo    : Autenticação — SignupViewModel
// Normas    : ISO/IEC/IEEE 29119-1, 29119-2 e 29119-4
// Técnicas  : Particionamento de Equivalência, Análise de Valor Limite,
//             Transição de Estado, Teste Baseado em Cenário
// Cobertura : RF01, RF02, RF03, RF04, RF05
// =============================================================================

void main() {
  late FakeAuthService service;
  late AuthRepositoryImpl repository;
  late SignupViewModel viewModel;

  setUp(() {
    service = FakeAuthService();
    repository = AuthRepositoryImpl(service);
    viewModel = SignupViewModel(repository);
  });

  group('SignupViewModel - Testes de unidade', () {
    // -------------------------------------------------------------------------
    // TC01 — Cadastro com dados válidos
    // RF01 – O usuário deve conseguir se cadastrar.
    //
    // Técnica: Particionamento de Equivalência (classe válida)
    //          Teste Baseado em Cenário (fluxo principal)
    //
    // Entrada : Nome, e-mail e senha válidos
    // Esperado: Cadastro realizado com sucesso e navegação para login
    // -------------------------------------------------------------------------
    test('TC01 — Cadastro com dados válidos', () async {
      // ACT
      await viewModel.signUp(
        name: 'Marcelo',
        email: 'marcelo@email.com',
        password: '123456',
      );

      // ASSERT
      expect(
        viewModel.authNavigationEvent,
        AuthNavigationEvent.goToLogin,
      );

      expect(
        viewModel.uiMessage,
        isNull,
      );
    });

    // -------------------------------------------------------------------------
    // TC02 — Cadastro com campos vazios
    // RF02 – O sistema deve impedir cadastro com campos vazios.
    //
    // Técnica: Análise de Valor Limite (valor mínimo — string vazia)
    //          Particionamento de Equivalência (classe inválida)
    //
    // Entrada : Nome, e-mail e senha em branco
    // Esperado: Mensagem 'Preencha todos os campos.' e evento none
    // -------------------------------------------------------------------------
    test('TC02 — Cadastro com campos vazios', () async {
      // ACT
      await viewModel.signUp(
        name: '',
        email: '',
        password: '',
      );

      // ASSERT
      expect(
        viewModel.uiMessage?.message,
        'Preencha todos os campos.',
      );

      expect(
        viewModel.authNavigationEvent,
        AuthNavigationEvent.none,
      );
    });

    // -------------------------------------------------------------------------
    // TC03 — Cadastro com e-mail inválido
    // RF03 – O sistema deve impedir cadastro com e-mail inválido.
    //
    // Técnica: Particionamento de Equivalência (classe inválida — formato)
    //          Análise de Valor Limite (ausência do caractere '@')
    //
    // Entrada : E-mail sem formato válido (sem '@' e sem domínio)
    // Esperado: Mensagem 'Informe um email valido' e evento none
    // -------------------------------------------------------------------------
    test('TC03 — Cadastro com e-mail inválido', () async {
      // ACT
      await viewModel.signUp(
        name: 'Marcelo',
        email: 'emailsemarroba',
        password: '123456',
      );

      // ASSERT
      expect(
        viewModel.uiMessage?.message,
        'Informe um email valido',
      );

      expect(
        viewModel.authNavigationEvent,
        AuthNavigationEvent.none,
      );
    });

    // -------------------------------------------------------------------------
    // TC04 — Cadastro duplicado
    // RF04 – O sistema deve impedir cadastro duplicado.
    //
    // Técnica: Transição de Estado (estado: cadastrado → tentativa de recadastro)
    //          Teste Baseado em Cenário (fluxo alternativo)
    //
    // Entrada : E-mail de um usuário já cadastrado no sistema
    // Esperado: Mensagem 'E-mail já cadastrado' e evento none
    // -------------------------------------------------------------------------
    test('TC04 — Cadastro duplicado', () async {
      // ARRANGE — cadastra o usuário pela primeira vez
      await repository.signUp(
        const UserModel(
          name: 'Marcelo',
          email: 'marcelo@email.com',
          password: '123456',
        ),
      );

      // ACT — tenta cadastrar o mesmo e-mail novamente
      await viewModel.signUp(
        name: 'Marcelo',
        email: 'marcelo@email.com',
        password: '123456',
      );

      // ASSERT
      expect(
        viewModel.uiMessage?.message,
        'E-mail já cadastrado',
      );

      expect(
        viewModel.authNavigationEvent,
        AuthNavigationEvent.none,
      );
    });

    // -------------------------------------------------------------------------
    // TC05 — Retorno ao login após cadastro bem-sucedido
    // RF05 – O sistema deve retornar para login após cadastro.
    //
    // Técnica: Transição de Estado (estado: não cadastrado → cadastrado → login)
    //          Teste Baseado em Cenário
    //
    // Entrada : Dados válidos de cadastro
    // Esperado: Evento goToLogin confirmado e ausência de mensagem de erro
    // -------------------------------------------------------------------------
    test('TC05 — Retorno ao login após cadastro', () async {
      // ACT
      await viewModel.signUp(
        name: 'João Silva',
        email: 'joao@email.com',
        password: 'senha123',
      );

      // ASSERT
      expect(
        viewModel.authNavigationEvent,
        AuthNavigationEvent.goToLogin,
      );

      expect(
        viewModel.uiMessage,
        isNull,
      );
    });
  });
}
