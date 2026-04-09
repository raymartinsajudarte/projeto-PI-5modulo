import 'package:appbarbearia/src/widgets/auth_text_link.dart';
import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/text_input.dart';
import 'package:appbarbearia/src/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> handleLogin() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Preencha os campos!')));
      return;
    }

    try {
      final res = await AuthService().login(
        username: username,
        password: password,
      );

      if (res.user != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.message)));

        Navigator.pushReplacementNamed(context, '/perfil');
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(res.message)));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erro ao Conectar: $e')));
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
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
                  'Conecte-se Agora!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF157C00),
                  ),
                ),

                SizedBox(height: 12),

                Text(
                  'Preencha os campos com os seus\ndados cadastrados.',
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
                    textPlaceholder: 'Nome de Usuario',
                    obscure: false,
                    controller: usernameController,
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
                  text: 'Conectar',
                  onPressed: () {
                    handleLogin();
                  },
                  width: 263,
                ),

                SizedBox(height: 8),

                AuthTextLink(
                  prefixText: 'Não possui uma conta?',
                  actionText: ' Cadastre-se',
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/register');
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
