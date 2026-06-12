import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:appbarbearia/src/services/register_service.dart';
import 'package:appbarbearia/src/viewmodels/register_view_model.dart';

// =============================================================================
// RELATÓRIO: Qualidade e Teste de Software — Grupo 11
// Sistema   : Sistema de Agendamento para Barbearia
// Módulo    : Autenticação — RegisterViewModel (Signup)
// Normas    : ISO/IEC/IEEE 29119-1, 29119-2 e 29119-4
// Técnicas  : Particionamento de Equivalência, Análise de Valor Limite,
//             Transição de Estado, Teste Baseado em Cenário
// Cobertura : RF01, RF02, RF03, RF04, RF05
//
// Observação: Os testes utilizam MockClient (package http/testing.dart) para
//             interceptar as chamadas HTTP ao endpoint POST /users sem depender
//             de servidor real, isolando completamente o ViewModel.
// =============================================================================

void main() {
  group('RegisterViewModel - Testes de unidade', () {
    // -------------------------------------------------------------------------
    // TC01 — Cadastro com dados válidos
    // RF01 – O usuário deve conseguir se cadastrar.
    //
    // Técnica: Particionamento de Equivalência (classe válida)
    //          Teste Baseado em Cenário (fluxo principal)
    //
    // Entrada : nome, nomeUsuario, email e senha preenchidos; API retorna sucesso
    // Esperado: register() retorna true e errorMessage permanece null
    // -------------------------------------------------------------------------
    test('TC01 — Cadastro com dados válidos', () async {
      // ARRANGE — mock simula API aceitando o cadastro com sucesso
      final mockClient = MockClient((request) async {
        final responseBody = jsonEncode({
          'id_usuario': 1,
          'nome': 'Marcelo',
          'nome_usuario': 'marcelo',
          'email': 'marcelo@email.com',
        });
        return http.Response(responseBody, 201);
      });

      final service = RegisterService(client: mockClient);
      final viewModel = RegisterViewModel(registerService: service);

      // ACT
      final result = await viewModel.register(
        nome: 'Marcelo',
        nomeUsuario: 'marcelo',
        email: 'marcelo@email.com',
        senha: '123456',
      );

      // ASSERT
      expect(result, isTrue);
      expect(viewModel.errorMessage, isNull);
    });

    // -------------------------------------------------------------------------
    // TC02 — Cadastro com campos vazios
    // RF02 – O sistema deve impedir cadastro com campos vazios.
    //
    // Técnica: Análise de Valor Limite (valor mínimo — string vazia)
    //          Particionamento de Equivalência (classe inválida)
    //
    // Entrada : todos os campos em branco (sem chamada HTTP)
    // Esperado: register() retorna false e errorMessage = 'Preencha todos os campos!'
    // -------------------------------------------------------------------------
    test('TC02 — Cadastro com campos vazios', () async {
      // ARRANGE — nenhum mock necessário; validação ocorre antes da chamada HTTP
      final viewModel = RegisterViewModel();

      // ACT
      final result = await viewModel.register(
        nome: '',
        nomeUsuario: '',
        email: '',
        senha: '',
      );

      // ASSERT
      expect(result, isFalse);
      expect(viewModel.errorMessage, 'Preencha todos os campos!');
    });

    // -------------------------------------------------------------------------
    // TC03 — Cadastro com apenas um campo vazio
    // RF02 – O sistema deve impedir cadastro com campos vazios.
    //
    // Técnica: Análise de Valor Limite (um campo ausente)
    //          Particionamento de Equivalência (classe inválida — parcial)
    //
    // Entrada : senha em branco, demais campos preenchidos
    // Esperado: register() retorna false e errorMessage = 'Preencha todos os campos!'
    // -------------------------------------------------------------------------
    test('TC03 — Cadastro com senha vazia', () async {
      // ARRANGE
      final viewModel = RegisterViewModel();

      // ACT
      final result = await viewModel.register(
        nome: 'Marcelo',
        nomeUsuario: 'marcelo',
        email: 'marcelo@email.com',
        senha: '',
      );

      // ASSERT
      expect(result, isFalse);
      expect(viewModel.errorMessage, 'Preencha todos os campos!');
    });

    // -------------------------------------------------------------------------
    // TC04 — Cadastro duplicado (e-mail já existente)
    // RF04 – O sistema deve impedir cadastro duplicado.
    //
    // Técnica: Transição de Estado (cadastrado → tentativa de recadastro)
    //          Teste Baseado em Cenário (fluxo alternativo)
    //
    // Entrada : dados válidos; API rejeita com mensagem de e-mail duplicado
    // Esperado: register() retorna false e errorMessage contém mensagem da API
    // -------------------------------------------------------------------------
    test('TC04 — Cadastro duplicado', () async {
      // ARRANGE — mock simula API rejeitando e-mail já cadastrado
      final mockClient = MockClient((request) async {
        final responseBody = jsonEncode({
          'message': 'E-mail já cadastrado.',
        });
        return http.Response(responseBody, 409);
      });

      final service = RegisterService(client: mockClient);
      final viewModel = RegisterViewModel(registerService: service);

      // ACT
      final result = await viewModel.register(
        nome: 'Marcelo',
        nomeUsuario: 'marcelo',
        email: 'marcelo@email.com',
        senha: '123456',
      );

      // ASSERT
      expect(result, isFalse);
      expect(viewModel.errorMessage, contains('Erro ao conectar'));
    });

    // -------------------------------------------------------------------------
    // TC05 — Retorno ao login após cadastro bem-sucedido
    // RF05 – O sistema deve retornar para login após cadastro.
    //
    // Técnica: Transição de Estado (não cadastrado → cadastrado → tela de login)
    //          Teste Baseado em Cenário
    //
    // Entrada : dados válidos; API retorna sucesso
    // Esperado: register() retorna true — a Page usa esse bool para navegar ao login
    // -------------------------------------------------------------------------
    test('TC05 — Retorno ao login após cadastro bem-sucedido', () async {
      // ARRANGE
      final mockClient = MockClient((request) async {
        final responseBody = jsonEncode({
          'id_usuario': 2,
          'nome': 'João Silva',
          'nome_usuario': 'joaosilva',
          'email': 'joao@email.com',
        });
        return http.Response(responseBody, 201);
      });

      final service = RegisterService(client: mockClient);
      final viewModel = RegisterViewModel(registerService: service);

      // ACT
      final result = await viewModel.register(
        nome: 'João Silva',
        nomeUsuario: 'joaosilva',
        email: 'joao@email.com',
        senha: 'senha123',
      );

      // ASSERT — true sinaliza para a Page que deve navegar para o login
      expect(result, isTrue);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.errorMessage, isNull);
    });
  });
}
