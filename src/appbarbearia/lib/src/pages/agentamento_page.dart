import 'package:flutter/material.dart';
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
  DateTime focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  String? selectedTime = '09:00';
  String selectedPayment = 'Cartão';

  final List<Map<String, dynamic>> services = [
    {
      'title': 'Corte de Cabelo',
      'subtitle': 'Corte moderno com tesoura e máquina.',
      'price': 50.0,
      'icon': Icons.content_cut,
      'selected': true,
    },
    {
      'title': 'Sobrancelha',
      'subtitle': 'Limpeza e acabamento da sobrancelha.',
      'price': 30.0,
      'icon': Icons.remove_red_eye_outlined,
      'selected': false,
    },
    {
      'title': 'Barba Completa',
      'subtitle': 'Modelagem, toalha quente e hidratação.',
      'price': 40.0,
      'icon': Icons.face,
      'selected': true,
    },
  ];

  final List<String> morningTimes = [
    '08:00',
    '08:30',
    '09:00',
    '09:30',
    '10:00',
    '10:30',
    '11:00',
    '11:30',
  ];

  final List<String> afternoonTimes = [
    '13:30',
    '14:00',
    '14:30',
    '15:00',
    '15:30',
    '16:00',
    '16:30',
    '17:00',
    '17:30',
    '18:00',
  ];

  final List<String> unavailableTimes = [];

  void previousMonth() {
    final now = DateTime.now();

    final mesAtual = DateTime(now.year, now.month);

    final mesAnterior = DateTime(focusedMonth.year, focusedMonth.month - 1);

    if (mesAnterior.isBefore(mesAtual)) {
      return;
    }
    setState(() {
      focusedMonth = mesAnterior;
    });
  }

  void nextMonth() {
    setState(() {
      focusedMonth = DateTime(focusedMonth.year, focusedMonth.month + 1, 1);
    });
  }

  void selectDate(DateTime date) {
    setState(() {
      selectedDate = date;
      focusedMonth = DateTime(date.year, date.month, 1);
    });
  }

  void selectTime(String time) {
    if (unavailableTimes.contains(time)) return;

    setState(() {
      selectedTime = time;
    });
  }

  void toggleService(int index) {
    setState(() {
      services[index]['selected'] = !services[index]['selected'];
    });
  }

  void selectPayment(String payment) {
    setState(() {
      selectedPayment = payment;
    });
  }

  List<Map<String, dynamic>> get selectedServices {
    return services.where((service) => service['selected'] == true).toList();
  }

  double get total {
    double sum = 0;

    for (final service in selectedServices) {
      sum += service['price'] as double;
    }

    return sum;
  }

  String get formattedDate {
    const months = [
      '',
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];

    return '${selectedDate.day} de ${months[selectedDate.month]}, ${selectedDate.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 80,
              padding: EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: HeaderWidget(title: 'Agendar Horario'),
            ),

            Divider(
              thickness: 1,
              color: Colors.grey.shade300,
              indent: 16,
              endIndent: 16,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CalendarCard(
                      focusedMonth: focusedMonth,
                      selectedDate: selectedDate,
                      onPreviousMonth: previousMonth,
                      onNextMonth: nextMonth,
                      onDateSelected: selectDate,
                    ),

                    SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
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
                              Icon(
                                Icons.access_time,
                                size: 18,
                                color: Color(0xFF1F1F1F),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Horários Disponíveis',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),

                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF7A7A7A),
                            ),
                          ),

                          SizedBox(height: 16),

                          Text(
                            'MANHÃ',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF158F00),
                            ),
                          ),
                          SizedBox(height: 10),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: morningTimes.map((time) {
                              return TimeSlotButton(
                                time: time,
                                isSelected: selectedTime == time,
                                isDisabled: unavailableTimes.contains(time),
                                onTap: () => selectTime(time),
                              );
                            }).toList(),
                          ),

                          SizedBox(height: 18),

                          Text(
                            'TARDE',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF158F00),
                            ),
                          ),
                          SizedBox(height: 10),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: afternoonTimes.map((time) {
                              return TimeSlotButton(
                                time: time,
                                isSelected: selectedTime == time,
                                isDisabled: unavailableTimes.contains(time),
                                onTap: () => selectTime(time),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
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
                              Icon(
                                Icons.content_cut,
                                size: 18,
                                color: Color(0xFF1F1F1F),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Selecione os Serviços',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          ...List.generate(services.length, (index) {
                            final service = services[index];

                            return ServiceCard(
                              icon: service['icon'] as IconData,
                              title: service['title'] as String,
                              subtitle: service['subtitle'] as String,
                              price: service['price'] as double,
                              isSelected: service['selected'] as bool,
                              onTap: () => toggleService(index),
                            );
                          }),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFFF3F3F3),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
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
                              Icon(
                                Icons.payments_outlined,
                                size: 18,
                                color: Color(0xFF1F1F1F),
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Selecione Método de Pagamento',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1F1F1F),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),

                          PaymentMethodCard(
                            icon: Icons.credit_card,
                            title: 'Cartão',
                            subtitle: 'Crédito / Débito',
                            isSelected: selectedPayment == 'Cartão',
                            onTap: () => selectPayment('Cartão'),
                          ),
                          PaymentMethodCard(
                            icon: Icons.pix,
                            title: 'Pix',
                            subtitle: 'Pagamento instantâneo',
                            isSelected: selectedPayment == 'Pix',
                            onTap: () => selectPayment('Pix'),
                          ),
                          PaymentMethodCard(
                            icon: Icons.attach_money,
                            title: 'Dinheiro',
                            subtitle: 'Pagamento em espécie',
                            isSelected: selectedPayment == 'Dinheiro',
                            onTap: () => selectPayment('Dinheiro'),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20),

                    SummaryCard(
                      dateText: formattedDate,
                      timeText: selectedTime ?? 'Selecione um horário',
                      selectedServices: selectedServices,
                      paymentMethod: selectedPayment,
                      total: total,
                      onConfirm: () {
                        if (selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selecione um horário.')),
                          );
                          return;
                        }

                        if (selectedServices.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selecione pelo menos um serviço.'),
                            ),
                          );
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Agendamento confirmado com sucesso!',
                            ),
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
