import 'package:appbarbearia/src/models/user_model.dart';
import 'package:appbarbearia/src/services/auth_service.dart';
import 'package:appbarbearia/src/widgets/bottom_nav.dart';
import 'package:appbarbearia/src/widgets/link_buttons.dart';
import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/user_info.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final AuthService _authService = AuthService();

  UserModel? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final loggedUser = await _authService.getLoggedUser();

    setState(() {
      user = loggedUser;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return  Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (user == null) {
      return  Scaffold(
        body: Center(
          child: Text('Usuário não encontrado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title:  Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Perfil'),
        ),
        titleTextStyle:  TextStyle(
          color: Color(0xFF145906),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.all(16),
          child: Column(
            children: [
              UserInfoWidget(
                userName: '@${user!.nomeUsuario}',
                userNameComplete: user!.nome,
                imageUrl: user!.foto,
              ),
              PrimaryButton(
                text: 'Editar Perfil',
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-user');
                },
                width: 132,
              ),
              SizedBox(height: 40),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
                indent: 16,
                endIndent: 16,
              ),
              ProfileLinkButton(
                icon: Icons.password,
                title: 'Alterar Senha',
                onTap: () {},
              ),
              ProfileLinkButton(
                icon: Icons.calendar_today,
                title: 'Agendamentos',
                onTap: () {},
              ),
              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
                indent: 10,
                endIndent: 10,
              ),
              ProfileLinkButton(
                icon: Icons.exit_to_app,
                title: 'Sair',
                onTap: () async {
                  await _authService.logout();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, '/welcome');
                },
              ),
               SizedBox(height: 140),
               BottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}