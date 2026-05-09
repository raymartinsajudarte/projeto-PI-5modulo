import 'package:appbarbearia/src/widgets/bottom_nav.dart';
import 'package:appbarbearia/src/widgets/primary_button.dart';
import 'package:appbarbearia/src/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/edit_user_view_model.dart';
import '../formatters/phone_formatter.dart';

class EditUserPage extends StatefulWidget {
  const EditUserPage({super.key});

  @override
  State<EditUserPage> createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final celularController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<EditUserViewModel>().loadUser();
  }

  @override
  void dispose() {
    nomeController.dispose();
    emailController.dispose();
    celularController.dispose();
    super.dispose();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _salvar(EditUserViewModel vm) async {
    final erro = await vm.salvar(
      nome: nomeController.text.trim(),
      email: emailController.text.trim(),
      celular: celularController.text.trim(),
    );

    if (!mounted) return;

    if (erro != null) {
      _snack(erro);
    } else {
      _snack('Perfil atualizado com sucesso!');
      Navigator.pushReplacementNamed(context, '/perfil');
    }
  }

  ImageProvider? _buildImageProvider(EditUserViewModel vm) {
    if (vm.temFotoLocal && vm.fotoBytesPreview != null) {
      return MemoryImage(vm.fotoBytesPreview!);
    }
    final url = vm.user?.foto;
    if (url != null && url.isNotEmpty) {
      return NetworkImage(url);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<EditUserViewModel>();

    if (vm.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final imageProvider = _buildImageProvider(vm);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text('Edição de Perfil'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Color(0xFF145906),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // ── Avatar editável ──────────────────────────────────────────
              GestureDetector(
                onTap: vm.submitting ? null : vm.selecionarFoto,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: imageProvider,
                      child: imageProvider == null
                          ? const Icon(Icons.person, size: 50)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Text(
                vm.user!.nome,
                style: const TextStyle(fontSize: 18),
              ),
              Text(
                '@${vm.user!.nomeUsuario}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              Divider(
                thickness: 1,
                color: Colors.grey.shade300,
                indent: 16,
                endIndent: 16,
              ),

              const SizedBox(height: 16),

              // ── Campos ───────────────────────────────────────────────────
              SizedBox(
                width: 300,
                child: TextInput(
                  textPlaceholder: vm.user!.nome,
                  obscure: false,
                  controller: nomeController,
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: 300,
                child: TextInput(
                  textPlaceholder: vm.user!.email,
                  obscure: false,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: 300,
                child: TextInput(
                  textPlaceholder: vm.user?.celular ?? '(19) 99999-9999',
                  obscure: false,
                  controller: celularController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [PhoneInputFormatter()],
                ),
              ),

              const SizedBox(height: 24),

              vm.submitting
                  ? const CircularProgressIndicator()
                  : PrimaryButton(
                      text: 'Salvar Alterações',
                      onPressed: () => _salvar(vm),
                      width: 300,
                    ),

              const SizedBox(height: 160),

              const BottomNav(),
            ],
          ),
        ),
      ),
    );
  }
}