import 'package:appbarbearia/src/widgets/auth_text_link.dart';
import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/text_input.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF157C00)),
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
                  ),
                ),

                SizedBox(height: 16),

                SizedBox(
                  width: 263,
                  child: TextInput(textPlaceholder: 'Senha', obscure: true),
                ),

                SizedBox(height: 24),

                PrimaryButton(text: 'Conectar', onPressed: () {}, width: 263),

                SizedBox(height: 8),

                AuthTextLink(
                  prefixText: 'Não possui uma conta?',
                  actionText: ' Cadastre-se',
                  onTap: () {},
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
