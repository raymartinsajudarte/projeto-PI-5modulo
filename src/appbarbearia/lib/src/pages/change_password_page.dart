import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/change_password_view_model.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final novaSenhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    novaSenhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final vm = context.read<ChangePasswordViewModel>();

    final erro = await vm.alterarSenha(
      novaSenha: novaSenhaController.text.trim(),
      confirmarSenha: confirmarSenhaController.text.trim(),
    );

    if (!mounted) return;

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(erro)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChangePasswordViewModel>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Alterar Senha'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color(0xFF145906),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: Column(
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Color(0xFF157C00),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Alterar Senha',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF157C00),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Digite e confirme sua nova senha.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFFB2B2B2),
                  ),
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: 263,
                  child: TextInput(
                    textPlaceholder: 'Nova senha',
                    obscure: true,
                    controller: novaSenhaController,
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: 263,
                  child: TextInput(
                    textPlaceholder: 'Confirmar nova senha',
                    obscure: true,
                    controller: confirmarSenhaController,
                  ),
                ),

                const SizedBox(height: 24),

                vm.isLoading
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        text: 'Salvar',
                        onPressed: _salvar,
                        width: 263,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}