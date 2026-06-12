import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:appbarbearia/src/services/auth_service.dart';
import 'package:appbarbearia/src/viewmodels/login_view_model.dart';

// =============================================================================
// RELATÓRIO: Qualidade e Teste de Software — Grupo 11
// Sistema   : Sistema de Agendamento para Barbearia
// Módulo    : Autenticação — LoginViewModel
// Normas    : ISO/IEC/IEEE 29119-1, 29119-2 e 29119-4
// Técnicas  : Particionamento de Equivalência, Análise de Valor Limite,
//             Transição de Estado, Teste Baseado em Cenário
// Cobertura : RF06, RF07, RF08
//
// Observação: Os testes utilizam MockClient (package http/testing.dart) para
//             interceptar as chamadas HTTP sem depender de servidor real.
//             SharedPreferences.setMockInitialValues({}) simula o armazenamento
//             local, isolando completamente o ViewModel durante os testes.
// =============================================================================

void main() {
  setUp(() {
    // Simula o SharedPreferences localmente sem acesso ao dispositivo real
    SharedPreferences.setMockInitialValues({});
  });

  group('LoginViewModel - Testes de unidade', () {
    // -------------------------------------------------------------------------
    // TC06 — Login válido
    // RF06 – O usuário deve conseguir realizar login.
    //
    // Técnica: Particionamento de Equivalência (classe válida)
    //          Teste Baseado em Cenário (fluxo principal)
    //
    // Entrada : username e password preenchidos; API retorna user válido
    // Esperado: login() retorna true e errorMessage permanece null
    // -------------------------------------------------------------------------
    test('TC06 — Login válido', () async {
      // ARRANGE — mock retorna um usuário válido
      final mockClient = MockClient((request) async {
        final responseBody = jsonEncode({
          'message': 'Login realizado com sucesso!',
          'user': {
            'id': 1,
            'nome': 'Marcelo',
            'nome_usuario': 'marcelo',
            'email': 'marcelo@email.com',
            'foto': null,
            'celular': null,
            'perfil': 'cliente',
          },
        });
        return http.Response(responseBody, 200);
      });

      final service = AuthService(client: mockClient);
      final viewModel = LoginViewModel(authService: service);

      // ACT
      final result = await viewModel.login(
        username: 'marcelo',
        password: '123456',
      );

      // ASSERT
      expect(result, isTrue);
      expect(viewModel.errorMessage, isNull);
    });

    // -------------------------------------------------------------------------
    // TC07 — Login com campos vazios
    // RF07 – O sistema deve impedir login com campos vazios.
    //
    // Técnica: Análise de Valor Limite (valor mínimo — string vazia)
    //          Particionamento de Equivalência (classe inválida)
    //
    // Entrada : username e password em branco (sem chamada HTTP)
    // Esperado: login() retorna false e errorMessage = 'Preencha todos os campos!'
    // -------------------------------------------------------------------------
    test('TC07 — Login com campos vazios', () async {
      // ARRANGE — nenhum mock necessário; validação ocorre antes da chamada HTTP
      final viewModel = LoginViewModel();

      // ACT
      final result = await viewModel.login(
        username: '',
        password: '',
      );

      // ASSERT
      expect(result, isFalse);
      expect(viewModel.errorMessage, 'Preencha todos os campos!');
    });

    // -------------------------------------------------------------------------
    // TC08 — Login inválido (credenciais incorretas)
    // RF08 – O sistema deve impedir login inválido.
    //
    // Técnica: Particionamento de Equivalência (classe inválida)
    //          Transição de Estado (não autenticado → permanece não autenticado)
    //
    // Entrada : username existente + password incorreto; API retorna user null
    // Esperado: login() retorna false e errorMessage exibe mensagem da API
    // -------------------------------------------------------------------------
    test('TC08 — Login inválido', () async {
      // ARRANGE — mock simula credenciais rejeitadas pela API
      final mockClient = MockClient((request) async {
        final responseBody = jsonEncode({
          'message': 'Credenciais inválidas!',
          'user': null,
        });
        return http.Response(responseBody, 401);
      });

      final service = AuthService(client: mockClient);
      final viewModel = LoginViewModel(authService: service);

      // ACT
      final result = await viewModel.login(
        username: 'marcelo',
        password: 'senhaerrada',
      );

      // ASSERT
      expect(result, isFalse);
      expect(viewModel.errorMessage, 'Credenciais inválidas!');
    });

    // -------------------------------------------------------------------------
    // TC09 — Navegação para Home após login válido
    // RF06 – (complementar) Transição de estado confirmada.
    //
    // Técnica: Transição de Estado (não autenticado → autenticado)
    //          Teste Baseado em Cenário
    //
    // Entrada : Credenciais corretas
    // Esperado: login() retorna true, isLoading volta para false e sem erros
    // -------------------------------------------------------------------------
    test('TC09 — Estado após login válido (isLoading e errorMessage)', () async {
      // ARRANGE
      final mockClient = MockClient((request) async {
        final responseBody = jsonEncode({
          'message': 'Login realizado com sucesso!',
          'user': {
            'id': 1,
            'nome': 'Marcelo',
            'nome_usuario': 'marcelo',
            'email': 'marcelo@email.com',
            'foto': null,
            'celular': null,
            'perfil': 'cliente',
          },
        });
        return http.Response(responseBody, 200);
      });

      final service = AuthService(client: mockClient);
      final viewModel = LoginViewModel(authService: service);

      // ACT
      final result = await viewModel.login(
        username: 'marcelo',
        password: '123456',
      );

      // ASSERT — após conclusão, isLoading deve ser false e sem erro
      expect(result, isTrue);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
    });
  });
}
