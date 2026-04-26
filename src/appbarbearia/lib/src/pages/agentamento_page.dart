import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/agendamento_view_model.dart';
import '../widgets/header_widget.dart';
import '../widgets/calendar_card.dart';
import '../widgets/time_buttons.dart';
import '../widgets/service_card.dart';
import '../widgets/payment_method_card.dart';
import '../widgets/sumary_card.dart';

class AgendamentoPage extends StatefulWidget {
  const AgendamentoPage({super.key});

  @override
  State<AgendamentoPage> createState() => _AgendamentoPageState();
}

class _AgendamentoPageState extends State<AgendamentoPage> {
  @override
  void initState() {
    super.initState();
    context.read<AgendamentoViewModel>().init();
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Future<void> _confirmar(AgendamentoViewModel vm) async {
    final erro = await vm.confirmar();
    if (!mounted) return;
    if (erro != null) {
      _snack(erro);
    } else {
      _snack('Agendamento confirmado com sucesso!');
      Navigator.pushReplacementNamed(context, '/perfil');
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AgendamentoViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: const HeaderWidget(title: 'Agendar Horário'),
            ),
            Divider(
              thickness: 1,
              color: Colors.grey.shade300,
              indent: 16,
              endIndent: 16,
            ),
            Expanded(
              child: vm.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Calendário
                          CalendarCard(
                            focusedMonth: vm.focusedMonth,
                            selectedDate: vm.selectedDate,
                            onPreviousMonth: vm.previousMonth,
                            onNextMonth: vm.nextMonth,
                            onDateSelected: vm.selectDate,
                          ),

                          const SizedBox(height: 20),

                          // Horários
                          _SectionCard(
                            icon: Icons.access_time,
                            title: 'Horários Disponíveis',
                            child: vm.loadingTimes
                                ? const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12),
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        vm.formattedDate,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF7A7A7A)),
                                      ),
                                      const SizedBox(height: 16),
                                      _timeGroup(vm, 'MANHÃ', vm.morningTimes),
                                      const SizedBox(height: 18),
                                      _timeGroup(vm, 'TARDE', vm.afternoonTimes),
                                    ],
                                  ),
                          ),

                          const SizedBox(height: 20),

                          // Serviços
                          _SectionCard(
                            icon: Icons.content_cut,
                            title: 'Selecione os Serviços',
                            child: Column(
                              children: List.generate(
                                vm.services.length,
                                (i) => ServiceCard(
                                  icon: vm.services[i]['icon'] as IconData,
                                  title: vm.services[i]['title'] as String,
                                  subtitle:
                                      vm.services[i]['subtitle'] as String,
                                  price: vm.services[i]['price'] as double,
                                  isSelected:
                                      vm.services[i]['selected'] as bool,
                                  onTap: () => vm.toggleService(i),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Pagamento
                          _SectionCard(
                            icon: Icons.payments_outlined,
                            title: 'Selecione Método de Pagamento',
                            child: Column(
                              children: vm.paymentMethods
                                  .map((p) => PaymentMethodCard(
                                        icon: iconForPayment(p.nome),
                                        title: capitalizeFirst(p.nome),
                                        subtitle: subtitleForPayment(p.nome),
                                        isSelected:
                                            vm.selectedPaymentId == p.id,
                                        onTap: () => vm.selectPayment(p),
                                      ))
                                  .toList(),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Resumo
                          SummaryCard(
                            dateText: vm.formattedDate,
                            timeText:
                                vm.selectedTime ?? 'Selecione um horário',
                            selectedServices: vm.selectedServices,
                            paymentMethod:
                                capitalizeFirst(vm.selectedPaymentNome),
                            total: vm.total,
                            onConfirm: () {
                              if (!vm.submitting) _confirmar(vm);
                            },
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeGroup(AgendamentoViewModel vm, String label, List<String> times) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF158F00),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: times
              .map((t) => TimeSlotButton(
                    time: t,
                    isSelected: vm.selectedTime == t,
                    isDisabled: vm.unavailableTimes.contains(t),
                    onTap: () => vm.selectTime(t),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F3F3),
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF1F1F1F)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}