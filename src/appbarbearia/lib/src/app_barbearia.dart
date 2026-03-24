import 'package:appbarbearia/src/pages/login_page.dart';
import 'package:appbarbearia/src/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'pages/welcome_page.dart';

class AppBarbearia extends StatelessWidget {
  const AppBarbearia({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'App Barbearia',
      home: RegisterPage(),
    );
  }
}