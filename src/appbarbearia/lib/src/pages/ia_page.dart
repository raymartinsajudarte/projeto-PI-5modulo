import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/ia_view_model.dart';
import '../viewmodels/agendamento_view_model.dart';

class IaPage extends StatefulWidget {
  const IaPage({super.key});

  @override
  State<IaPage> createState() => _IaPageState();
}

class _IaPageState extends State<IaPage> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _enviar(IaViewModel vm) async {
    final texto = _inputController.text.trim();
    if (texto.isEmpty) return;
    _inputController.clear();
    await vm.enviarMensagem(texto);
    _scrollToBottom();
  }

  void _irParaAgendamento(IaViewModel vm) {
    final dados = vm.dadosAgendamento;
    if (dados == null) return;

    // Guarda os dados como pendentes — serão aplicados após o init() terminar
    context.read<AgendamentoViewModel>().dadosPendentesIA = dados;
    Navigator.pushReplacementNamed(context, '/agendamento');
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<IaViewModel>();
    _scrollToBottom();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        toolbarHeight: 70,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF158F00)),
        ),
        title: const Text(
          'Barbenida IA',
          style: TextStyle(
            color: Color(0xFF158F00),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            thickness: 1,
            color: Colors.grey.shade300,
            indent: 16,
            endIndent: 16,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Lista de mensagens ───────────────────────────────────────────
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: vm.mensagens.length + (vm.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == vm.mensagens.length) {
                  return _TypingIndicator();
                }
                return _ChatBubble(message: vm.mensagens[index]);
              },
            ),
          ),

          // ── Botão confirmar agendamento ───────────────────────────────────
          if (vm.atendimentoFinalizado && vm.dadosAgendamento != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFECFDF5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.check_circle,
                          color: Color(0xFF158F00), size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Atendimento finalizado!',
                        style: TextStyle(
                          color: Color(0xFF158F00),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Resumo dos dados coletados
                  _ResumoItem(
                      icon: Icons.content_cut,
                      texto: vm.dadosAgendamento!.servicoEscolhido),
                  _ResumoItem(
                      icon: Icons.calendar_today,
                      texto: vm.dadosAgendamento!.diaEscolhido),
                  _ResumoItem(
                      icon: Icons.access_time,
                      texto: vm.dadosAgendamento!.horarioEscolhido),
                  _ResumoItem(
                      icon: Icons.payments_outlined,
                      texto: vm.dadosAgendamento!.pagamentoEscolhido),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _irParaAgendamento(vm),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF158F00),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Confirmar Agendamento',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── Input ─────────────────────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _inputController,
                    enabled: !vm.atendimentoFinalizado,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _enviar(vm),
                    decoration: InputDecoration(
                      hintText: vm.atendimentoFinalizado
                          ? 'Atendimento encerrado'
                          : 'Pipipopo.....',
                      hintStyle: const TextStyle(
                        color: Color(0xFFB2B2B2),
                        fontSize: 14,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide:
                            const BorderSide(color: Color(0xFF158F00)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: vm.isLoading || vm.atendimentoFinalizado
                      ? null
                      : () => _enviar(vm),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: vm.isLoading || vm.atendimentoFinalizado
                          ? Colors.grey.shade300
                          : const Color(0xFF158F00),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Resumo item ──────────────────────────────────────────────────────────────
class _ResumoItem extends StatelessWidget {
  final IconData icon;
  final String texto;

  const _ResumoItem({required this.icon, required this.texto});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF158F00)),
          const SizedBox(width: 6),
          Text(
            texto,
            style: const TextStyle(fontSize: 13, color: Color(0xFF1F1F1F)),
          ),
        ],
      ),
    );
  }
}

// ── Bubble de mensagem ───────────────────────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  final ChatMessage message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF062200),
              child: const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isUser ? const Color(0xFF6CAB5B) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.texto,
                style: TextStyle(
                  fontSize: 14,
                  color: isUser ? Colors.white : const Color(0xFF1F1F1F),
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFF158F00),
              child:
                  const Icon(Icons.person, color: Colors.white, size: 16),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Indicador de digitação ───────────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFF062200),
            child: const Icon(Icons.auto_awesome,
                color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.circular(4),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: FadeTransition(
              opacity: _animation,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  3,
                  (i) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF158F00),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}