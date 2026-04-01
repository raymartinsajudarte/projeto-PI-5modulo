import 'package:appbarbearia/src/widgets/bottom_nav.dart';
import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/text_input.dart';
import 'package:appbarbearia/src/widgets/user_info.dart';
import 'package:flutter/material.dart';

class EditUserPage extends StatelessWidget {
  final nomeCompletoController = TextEditingController();
  final emailController = TextEditingController();
  final celularController = TextEditingController();

  EditUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: Text('Edição de Perfil'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color(0xFF145906),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () {
            ;
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              
              UserInfoWidget(
                userName: '@maxvallim22',
                userNameComplete: 'Max Vallim',
                editable: true,
              ),

              SizedBox(height: 10),

              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
                indent: 16,
                endIndent: 16,
              ),

              SizedBox(height: 16),

              SizedBox(
                width: 300,
                child: TextInput(
                  textPlaceholder: 'Max Vallim Stecss',
                  obscure: false,
                  controller: nomeCompletoController,
                ),
              ),

              SizedBox(height: 16),

              SizedBox(
                width: 300,
                child: TextInput(
                  textPlaceholder: 'maxvallim22@exemplo.com',
                  obscure: false,
                  controller: emailController,
                ),
              ),

              SizedBox(height: 16),

              SizedBox(
                width: 300,
                child: TextInput(
                  textPlaceholder: '(19) 99999-9999',
                  obscure: false,
                  controller: celularController,
                ),
              ),

              SizedBox(height: 16),

              PrimaryButton(
                text: 'Salvar Alterações',
                onPressed: () {},
                width: 300,
              ),

              SizedBox(height: 160),

              BottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}
