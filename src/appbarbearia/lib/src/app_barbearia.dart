import 'package:appbarbearia/src/pages/agentamento_page.dart';
import 'package:appbarbearia/src/pages/login_page.dart';
import 'package:appbarbearia/src/pages/perfil_page.dart';
import 'package:appbarbearia/src/pages/register_page.dart';
import 'package:appbarbearia/src/pages/edit_user_page.dart';
import 'package:appbarbearia/src/viewmodels/agendamento_view_model.dart';
import 'package:appbarbearia/src/viewmodels/login_view_model.dart';
import 'package:appbarbearia/src/viewmodels/perfil_view_model.dart';
import 'package:appbarbearia/src/viewmodels/register_view_model.dart';
import 'package:appbarbearia/src/viewmodels/edit_user_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/welcome_page.dart';

class AppBarbearia extends StatelessWidget {
  const AppBarbearia({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginViewModel()),
        ChangeNotifierProvider(create: (_) => RegisterViewModel()),
        ChangeNotifierProvider(create: (_) => PerfilViewModel()),
        ChangeNotifierProvider(create: (_) => AgendamentoViewModel()),
        ChangeNotifierProvider(create: (_) => EditUserViewModel()),

      ],
      child: MaterialApp(
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
      ),
    );
  }
}
