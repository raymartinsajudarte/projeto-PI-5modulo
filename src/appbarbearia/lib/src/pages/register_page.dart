import 'package:appbarbearia/src/widgets/auth_text_link.dart';
import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/text_input.dart';
import 'package:appbarbearia/src/formatters/phone_formatter.dart';
import 'package:appbarbearia/src/formatters/username_formatter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_view_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final vm = context.read<RegisterViewModel>();

    final success = await vm.register(
      nome: nameController.text.trim(),
      nomeUsuario: usernameController.text.trim(),
      email: emailController.text.trim(),
      celular: phoneController.text.replaceAll(RegExp(r'\D'), ''),
      senha: passwordController.text.trim(),
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastrado com Sucesso!')),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(vm.errorMessage ?? 'Erro ao cadastrar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RegisterViewModel>();

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
                  'Cadastro de Usuario',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF157C00),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Preencha os campos com os seus\ndados.',
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
                    textPlaceholder: 'Nome Completo',
                    obscure: false,
                    controller: nameController,
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: 263,
                  child: TextInput(
                    textPlaceholder: 'Nome de Usuario',
                    obscure: false,
                    controller: usernameController,
                    inputFormatters: [UsernameInputFormatter()],
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: 263,
                  child: TextInput(
                    textPlaceholder: 'Email',
                    obscure: false,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: 263,
                  child: TextInput(
                    textPlaceholder: 'Celular',
                    obscure: false,
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [PhoneInputFormatter()],
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
                        text: 'Cadastrar',
                        onPressed: _handleRegister,
                        width: 263,
                      ),

                const SizedBox(height: 8),

                AuthTextLink(
                  prefixText: 'Ja possui uma conta?',
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