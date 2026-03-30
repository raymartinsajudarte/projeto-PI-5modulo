import 'package:flutter/material.dart';
import '../widgets/primary_button.dart';
import '../widgets/auth_text_link.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo_barbearia.png', height: 220),
                SizedBox(height: 28),
                Text(
                  'Seja bem-vindo!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 14),
                SizedBox(
                  width: 270,
                  child: Text(
                    'Crie uma conta ou conecte-se ao nosso sistema para usufruir dos nossos serviços',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                ),
                SizedBox(height: 36),
                PrimaryButton(
                  text: 'Registre-se aqui',
                  width: 220,
                  onPressed: () {},
                ),
                SizedBox(height: 18),
                AuthTextLink(
                  prefixText: 'Já tem uma conta? ',
                  actionText: 'Conecte-se',
                  onTap: () {},
                  textSize: 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
