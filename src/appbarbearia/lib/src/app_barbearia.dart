import 'package:appbarbearia/src/pages/agentamento_page.dart';
import 'package:appbarbearia/src/pages/splash_page.dart';
import 'package:appbarbearia/src/pages/login_page.dart';
import 'package:appbarbearia/src/pages/perfil_page.dart';
import 'package:appbarbearia/src/pages/register_page.dart';
import 'package:appbarbearia/src/pages/edit_user_page.dart';
import 'package:appbarbearia/src/pages/forgot_password_page.dart';
import 'package:appbarbearia/src/pages/change_password_page.dart';
import 'package:appbarbearia/src/pages/ia_page.dart';
import 'package:appbarbearia/src/pages/historico_page.dart';
import 'package:appbarbearia/src/viewmodels/agendamento_view_model.dart';
import 'package:appbarbearia/src/viewmodels/forgot_password_view_model.dart';
import 'package:appbarbearia/src/viewmodels/login_view_model.dart';
import 'package:appbarbearia/src/viewmodels/perfil_view_model.dart';
import 'package:appbarbearia/src/viewmodels/register_view_model.dart';
import 'package:appbarbearia/src/viewmodels/edit_user_view_model.dart';
import 'package:appbarbearia/src/viewmodels/change_password_view_model.dart';
import 'package:appbarbearia/src/viewmodels/ia_view_model.dart';
import 'package:appbarbearia/src/viewmodels/history_view_model.dart';
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
        ChangeNotifierProvider(create: (_) => ForgotPasswordViewModel()),
        ChangeNotifierProvider(create: (_) => ChangePasswordViewModel()),
        ChangeNotifierProvider(create: (_) => IaViewModel()),
        ChangeNotifierProvider(create: (_) => HistoricoViewModel()),


      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'App Barbearia',
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashPage(),
          '/welcome': (context) => WelcomePage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/perfil': (context) => PerfilPage(),
          '/edit-user': (context) => EditUserPage(),
          '/historico': (context) => HistoricoPage(),
          '/agendamento': (context) => AgendamentoPage(),
          '/forgot-password': (context) => ForgotPasswordPage(),
          '/alterar-senha': (context) => ChangePasswordPage(),
          '/ia': (context) => IaPage(),

        },
      ),
    );
  }
}
