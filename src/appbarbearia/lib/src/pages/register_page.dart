import 'package:appbarbearia/src/services/register_service.dart';
import 'package:appbarbearia/src/widgets/auth_text_link.dart';
import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/text_input.dart';
import 'package:appbarbearia/src/formatters/phone_formatter.dart';
import 'package:appbarbearia/src/formatters/username_formatter.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();

  Future<void> handleRegister() async {
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.replaceAll(RegExp(r'\D'), '');
    final name = nameController.text.trim();

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        phone.isEmpty ||
        name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Preencha todos os campos!')));
      return;
    }

    try {
      final res = await RegisterService().register(
        nome: name,
        nomeUsuario: username,
        celular: phone,
        email: email,
        senha: password,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Cadastrado com Sucesso!')));

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao Conectar: $e')));
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Center(
            child: Column(
              children: [
                Image.asset('images/logo_barbearia.png', height: 200),

                SizedBox(height: 40),

                Text(
                  'Cadastro de Usuario',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF157C00),
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  'Preencha os campos com os seus\ndados.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Color(0xFFB2B2B2),
                  ),
                ),

                SizedBox(height: 32),

                SizedBox(
                  width: 263,
                  child: TextInput(
                    textPlaceholder: 'Nome Completo',
                    obscure: false,
                    controller: nameController,
                  ),
                ),

                SizedBox(height: 16),

                SizedBox(
                  width: 263,
                  child: TextInput(
                    textPlaceholder: 'Nome de Usuario',
                    obscure: false,
                    controller: usernameController,
                    inputFormatters: [UsernameInputFormatter()],
                  ),
                ),

                SizedBox(height: 16),

                SizedBox(
                  width: 263,
                  child: TextInput(
                    textPlaceholder: 'Email',
                    obscure: false,
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),

                SizedBox(height: 16),

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

                SizedBox(height: 16),

                SizedBox(
                  width: 263,
                  child: TextInput(
                    textPlaceholder: 'Senha',
                    obscure: true,
                    controller: passwordController,
                  ),
                ),

                SizedBox(height: 24),

                PrimaryButton(
                  text: 'Cadastrar',
                  onPressed: () {
                    handleRegister();
                  },
                  width: 263,
                ),

                SizedBox(height: 8),

                AuthTextLink(
                  prefixText: 'Ja possui uma conta?',
                  actionText: ' Conecte-se',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
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
