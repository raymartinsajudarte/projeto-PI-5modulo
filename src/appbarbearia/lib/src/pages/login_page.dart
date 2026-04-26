import 'package:appbarbearia/src/widgets/auth_text_link.dart';
import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final vm = context.read<LoginViewModel>();

    final success = await vm.login(
      username: usernameController.text.trim(),
      password: passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacementNamed(context, '/perfil');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Erro ao conectar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<LoginViewModel>();

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
                  'Conecte-se Agora!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF157C00),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Preencha os campos com os seus\ndados cadastrados.',
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
                    textPlaceholder: 'Nome de Usuario',
                    obscure: false,
                    controller: usernameController,
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: 263,
                  child: TextInput(
                    textPlaceholder: 'Senha',
                    obscure: true,
                    controller: passwordController,
                  ),
                ),

                const SizedBox(height: 24),

                vm.isLoading
                    ? const CircularProgressIndicator()
                    : PrimaryButton(
                        text: 'Conectar',
                        onPressed: _handleLogin,
                        width: 263,
                      ),

                const SizedBox(height: 8),

                AuthTextLink(
                  prefixText: 'Não possui uma conta?',
                  actionText: ' Cadastre-se',
                  onTap: () =>
                      Navigator.pushReplacementNamed(context, '/register'),
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