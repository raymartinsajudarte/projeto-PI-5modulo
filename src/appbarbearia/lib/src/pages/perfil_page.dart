import 'package:appbarbearia/src/widgets/bottom_nav.dart';
import 'package:appbarbearia/src/widgets/link_buttons.dart';
import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/user_info.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/perfil_view_model.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({super.key});

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PerfilViewModel>().loadUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PerfilViewModel>();

    if (vm.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (vm.user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuário não encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: const Padding(
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              UserInfoWidget(
                userName: '@${vm.user!.nomeUsuario}',
                userNameComplete: vm.user!.nome,
                imageUrl: vm.user!.foto,
              ),
              PrimaryButton(
                text: 'Editar Perfil',
                onPressed: () => Navigator.pushNamed(context, '/edit-user'),
                width: 132,
              ),
              const SizedBox(height: 40),
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
                onTap: () =>
                    Navigator.pushReplacementNamed(context, ''),
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
                  await vm.logout();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, '/welcome');
                },
              ),
              const SizedBox(height: 140),
              const BottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}
