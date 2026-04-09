import 'package:appbarbearia/src/pages/agentamento_page.dart';
import 'package:appbarbearia/src/pages/login_page.dart';
import 'package:appbarbearia/src/pages/perfil_page.dart';
import 'package:appbarbearia/src/pages/register_page.dart';
import 'package:appbarbearia/src/pages/edit_user_page.dart';
import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';

class AppBarbearia extends StatelessWidget {
  const AppBarbearia({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Barbearia',

      initialRoute: '/welcome',

      routes: {
        '/welcome': (context) => WelcomePage(),
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/perfil': (context) => PerfilPage(),
        '/edit-user': (context) => EditUserPage(),
        '/agendamento': (context) => AgendamentoPage(),
      },
    );
  }
}