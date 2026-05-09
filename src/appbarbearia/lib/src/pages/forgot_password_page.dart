import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/text_input.dart';
import 'package:appbarbearia/src/widgets/auth_text_link.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/forgot_password_view_model.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool _emailEnviado = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    final vm = context.read<ForgotPasswordViewModel>();
    final erro = await vm.enviarEmail(emailController.text.trim());

    if (!mounted) return;

    if (erro != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(erro)));
    } else {
      setState(() => _emailEnviado = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ForgotPasswordViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: Column(
              children: [
                Image.asset('images/logo_barbearia.png', height: 200),

                const SizedBox(height: 40),

                const Text(
                  'Esqueceu a senha?',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF157C00),
                  ),
                ),

                const SizedBox(height: 12),

                Text(
                  _emailEnviado
                      ? 'Email enviado! Verifique sua caixa de entrada e clique no link para redefinir sua senha.'
                      : 'Digite o email cadastrado na sua conta\ne enviaremos um link para redefinir.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFFB2B2B2),
                  ),
                ),

                const SizedBox(height: 32),

                // Mostra o campo só se ainda não enviou
                if (!_emailEnviado) ...[
                  SizedBox(
                    width: 263,
                    child: TextInput(
                      textPlaceholder: 'seu@email.com',
                      obscure: false,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),

                  const SizedBox(height: 24),

                  vm.isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButton(
                          text: 'Enviar link',
                          onPressed: _enviar,
                          width: 263,
                        ),
                ],

                // Mostra ícone de sucesso após enviar
                if (_emailEnviado) ...[
                  const SizedBox(height: 16),
                  const Icon(
                    Icons.mark_email_read_outlined,
                    size: 64,
                    color: Color(0xFF157C00),
                  ),
                  const SizedBox(height: 24),
                ],

                const SizedBox(height: 16),

                AuthTextLink(
                  prefixText: 'Lembrou a senha?',
                  actionText: ' Conecte-se',
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/login'),
                  textSize: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
