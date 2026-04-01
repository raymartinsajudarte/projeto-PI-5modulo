import 'package:appbarbearia/src/widgets/bottom_nav.dart';
import 'package:appbarbearia/src/widgets/link_buttons.dart';
import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/user_info.dart';
import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title:  Padding(
          padding: EdgeInsets.only(top: 8),
          child: Text('Perfil'),
        ),
        titleTextStyle: const TextStyle(
          color: Color(0xFF145906),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              UserInfoWidget(
                userName: '@maxvallim22',
                userNameComplete: 'Max Vallim',
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
                onTap: () {},
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
