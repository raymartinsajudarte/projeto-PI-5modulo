import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/history_view_model.dart';
import '../models/history_model.dart';

class HistoricoPage extends StatefulWidget {
  const HistoricoPage({super.key});

  @override
  State<HistoricoPage> createState() => _HistoricoPageState();
}

class _HistoricoPageState extends State<HistoricoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoricoViewModel>().loadHistorico();
    });
  }

  Future<void> _confirmarCancelamento(
      BuildContext context, HistoricoModel agendamento) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancelar Agendamento'),
        content: Text(
          'Deseja cancelar o agendamento de '
          '${agendamento.descricaoServicos} '
          'do dia ${_formatarData(agendamento.dia)} '
          'às ${agendamento.hora.substring(0, 5)}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Sim, cancelar'),
          ),
        ],
      ),
    );

    if (confirmar != true || !mounted) return;

    final vm = context.read<HistoricoViewModel>();
    final erro = await vm.cancelar(agendamento.idAgendamento);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(erro ?? 'Agendamento cancelado com sucesso!'),
      ),
    );
  }

  String _formatarData(DateTime dia) {
    const meses = [
      '', 'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
    ];
    return '${dia.day} de ${meses[dia.month]}';
  }

  String _formatarValor(double valor) {
    return 'R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HistoricoViewModel>();

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        centerTitle: true,
        title: const Text('Agendamentos'),
        titleTextStyle: const TextStyle(
          color: Color(0xFF145906),
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          onPressed: () => Navigator.pushReplacementNamed(context, '/perfil'),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF158F00)),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: vm.isLoading
            ? const Center(child: CircularProgressIndicator())
            : vm.errorMessage != null
                ? Center(child: Text(vm.errorMessage!))
                : vm.agendamentos.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhum agendamento encontrado.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: vm.agendamentos.length,
                        itemBuilder: (context, index) {
                          final agendamento = vm.agendamentos[index];
                          return _AgendamentoCard(
                            agendamento: agendamento,
                            formatarData: _formatarData,
                            formatarValor: _formatarValor,
                            onCancelar: () => _confirmarCancelamento(
                                context, agendamento),
                            canceling: vm.canceling,
                          );
                        },
                      ),
      ),
    );
  }
}

// ── Card de agendamento ──────────────────────────────────────────────────────
class _AgendamentoCard extends StatelessWidget {
  final HistoricoModel agendamento;
  final String Function(DateTime) formatarData;
  final String Function(double) formatarValor;
  final VoidCallback onCancelar;
  final bool canceling;

  const _AgendamentoCard({
    required this.agendamento,
    required this.formatarData,
    required this.formatarValor,
    required this.onCancelar,
    required this.canceling,
  });

  @override
  Widget build(BuildContext context) {
    final isConcluido = agendamento.isConcluido;
    final isCancelado = agendamento.isCancelado;
    final podeCancelar = agendamento.podeCancelar;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isCancelado
            ? Colors.grey.shade100
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isConcluido
              ? const Color(0xFF6CAB5B)
              : isCancelado
                  ? Colors.grey.shade300
                  : const Color(0xFF6CAB5B),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hora / ícone de status ────────────────────────────────────
            Column(
              children: [
                if (isConcluido)
                  const Icon(Icons.check_circle,
                      color: Color(0xFF6CAB5B), size: 36)
                else if (isCancelado)
                  const Icon(Icons.cancel_outlined,
                      color: Colors.grey, size: 36)
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F3F3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      agendamento.hora.substring(0, 5),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F1F1F),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 12),

            // ── Detalhes ──────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Serviços Realizados:',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        formatarData(agendamento.dia),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Serviços
                  Text(
                    agendamento.descricaoServicos
                        .split(' | ')
                        .map((s) => _capitalize(s))
                        .join(',\n'),
                    style: TextStyle(
                      fontSize: 13,
                      color: isCancelado
                          ? Colors.grey
                          : const Color(0xFF1F1F1F),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Valor + pagamento
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatarValor(agendamento.valorTotal),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isCancelado
                              ? Colors.grey
                              : const Color(0xFF158F00),
                        ),
                      ),
                      Text(
                        _capitalize(agendamento.formaPagamento),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // ── Botão cancelar ou status ──────────────────────────
                  if (isCancelado)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null,
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: Colors.grey.shade200,
                          disabledForegroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'CANCELADO',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    )
                  else if (isConcluido)
                    const SizedBox.shrink()
                  else if (podeCancelar)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canceling ? null : onCancelar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B0000),
                          foregroundColor: Colors.white,
                          padding:
                              const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'CANCELAR',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    )
                  else
                    // Passou das 6h antes — não pode mais cancelar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: null, // desabilitado
                        style: ElevatedButton.styleFrom(
                          disabledBackgroundColor: Colors.grey.shade200,
                          disabledForegroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'CANCELAR',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}