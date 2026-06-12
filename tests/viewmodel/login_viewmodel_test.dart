import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_barbearia/core/ui/ui_event.dart';
import 'package:projeto_barbearia/features/auth/data/repository/auth_repository_impl.dart';
import 'package:projeto_barbearia/features/auth/data/service/fake_auth_service.dart';
import 'package:projeto_barbearia/features/auth/model/user_model.dart';
import 'package:projeto_barbearia/features/auth/viewmodel/login_viewmodel.dart';
 
// =============================================================================
// RELATÓRIO: Qualidade e Teste de Software — Grupo 11
// Sistema   : Sistema de Agendamento para Barbearia
// Módulo    : Autenticação — LoginViewModel
// Normas    : ISO/IEC/IEEE 29119-1, 29119-2 e 29119-4
// Técnicas  : Particionamento de Equivalência, Análise de Valor Limite,
//             Transição de Estado, Teste Baseado em Cenário
// Cobertura : RF06, RF07, RF08
// =============================================================================
 
void main() {
  late FakeAuthService service;
  late AuthRepositoryImpl repository;
  late LoginViewModel viewModel;
 
  setUp(() {
    service = FakeAuthService();
    repository = AuthRepositoryImpl(service);
    viewModel = LoginViewModel(repository);
  });
 
  group('LoginViewModel - Testes de unidade', () {
    // -------------------------------------------------------------------------
    // TC06 — Login válido
    // RF06 – O usuário deve conseguir realizar login.
    //
    // Técnica: Particionamento de Equivalência (classe válida)
    //          Teste Baseado em Cenário (fluxo principal)
    //
    // Entrada : E-mail e senha corretos de um usuário previamente cadastrado
    // Esperado: Evento de navegação goToHome e ausência de mensagem de erro
    // -------------------------------------------------------------------------
    test('TC06 — Login válido', () async {
      // ARRANGE — cadastra o usuário antes de tentar o login
      await repository.signUp(
        const UserModel(
          name: 'Marcelo',
          email: 'marcelo@email.com',
          password: '123456',
        ),
      );
 
      // ACT
      await viewModel.login(
        email: 'marcelo@email.com',
        password: '123456',
      );
 
      // ASSERT
      expect(
        viewModel.authNavigationEvent,
        AuthNavigationEvent.goToHome,
      );
 
      expect(
        viewModel.uiMessage,
        isNull,
      );
    });
 
    // -------------------------------------------------------------------------
    // TC07 — Login com campos vazios
    // RF07 – O sistema deve impedir login com campos vazios.
    //
    // Técnica: Análise de Valor Limite (valor mínimo — string vazia)
    //          Particionamento de Equivalência (classe inválida)
    //
    // Entrada : E-mail e senha em branco
    // Esperado: Mensagem 'Preencha email e senha.' e evento none
    // -------------------------------------------------------------------------
    test('TC07 — Login com campos vazios', () async {
      // ACT
      await viewModel.login(
        email: '',
        password: '',
      );
 
      // ASSERT
      expect(
        viewModel.uiMessage?.message,
        'Preencha email e senha.',
      );
 
      expect(
        viewModel.authNavigationEvent,
        AuthNavigationEvent.none,
      );
    });
 
    // -------------------------------------------------------------------------
    // TC08 — Login inválido (senha incorreta)
    // RF08 – O sistema deve impedir login inválido.
    //
    // Técnica: Particionamento de Equivalência (classe inválida)
    //          Transição de Estado (estado: não autenticado → permanece não autenticado)
    //
    // Entrada : E-mail correto + senha errada de usuário cadastrado
    // Esperado: Mensagem 'E-mail ou senha invalidos' e evento none
    // -------------------------------------------------------------------------
    test('TC08 — Login inválido', () async {
      // ARRANGE — cadastra o usuário antes de tentar o login com senha errada
      await repository.signUp(
        const UserModel(
          name: 'Marcelo',
          email: 'marcelo@email.com',
          password: '123456',
        ),
      );
 
      // ACT
      await viewModel.login(
        email: 'marcelo@email.com',
        password: 'senhaerrada',
      );
 
      // ASSERT
      expect(
        viewModel.uiMessage?.message,
        'E-mail ou senha invalidos',
      );
 
      expect(
        viewModel.authNavigationEvent,
        AuthNavigationEvent.none,
      );
    });
 
    // -------------------------------------------------------------------------
    // TC09 — Navegação para Home após login válido
    // (Complementar ao TC06 — rastreabilidade RF06)
    //
    // Técnica: Transição de Estado (estado: não autenticado → autenticado → Home)
    //          Teste Baseado em Cenário
    //
    // Entrada : Credenciais corretas
    // Esperado: Evento goToHome confirmado e ausência de qualquer mensagem
    // -------------------------------------------------------------------------
    test('TC09 — Navegação para Home', () async {
      // ARRANGE
      await repository.signUp(
        const UserModel(
          name: 'Marcelo',
          email: 'marcelo@email.com',
          password: '123456',
        ),
      );
 
      // ACT
      await viewModel.login(
        email: 'marcelo@email.com',
        password: '123456',
      );
 
      // ASSERT
      expect(
        viewModel.authNavigationEvent,
        AuthNavigationEvent.goToHome,
      );
 
      expect(
        viewModel.uiMessage,
        isNull,
      );
    });
  });
}
