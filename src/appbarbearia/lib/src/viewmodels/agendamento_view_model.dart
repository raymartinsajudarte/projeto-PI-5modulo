import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/services_service.dart';
import '../services/payment_service.dart';
import '../services/appointment_service.dart';
import '../models/payment_model.dart';

const _allowedServiceIds = [1, 2, 3, 4];

IconData iconForService(int id) {
  switch (id) {
    case 1:
      return Icons.content_cut;
    case 2:
      return Icons.face;
    case 3:
      return Icons.remove_red_eye_outlined;
    case 4:
      return Icons.color_lens_outlined;
    default:
      return Icons.spa;
  }
}

String subtitleForService(int id) {
  switch (id) {
    case 1:
      return 'Corte moderno com tesoura e máquina.';
    case 2:
      return 'Modelagem, toalha quente e hidratação.';
    case 3:
      return 'Limpeza e acabamento da sobrancelha.';
    case 4:
      return 'Descoloração completa dos fios.';
    default:
      return '';
  }
}

IconData iconForPayment(String nome) {
  switch (nome.toLowerCase()) {
    case 'crédito':
    case 'débito':
      return Icons.credit_card;
    case 'pix':
      return Icons.pix;
    default:
      return Icons.attach_money;
  }
}

String subtitleForPayment(String nome) {
  switch (nome.toLowerCase()) {
    case 'crédito':
      return 'Pagamento no crédito';
    case 'débito':
      return 'Pagamento no débito';
    case 'pix':
      return 'Pagamento instantâneo';
    default:
      return 'Pagamento em espécie';
  }
}

String capitalizeFirst(String s) =>
    s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

class AgendamentoViewModel extends ChangeNotifier {
  final _servicesService = ServicesService();
  final _paymentService = PaymentService();
  final _appointmentService = AppointmentService();

  DateTime focusedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime selectedDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  final List<String> morningTimes = ['08:00', '09:00', '10:00', '11:00'];
  final List<String> afternoonTimes = [
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
  ];
  List<String> unavailableTimes = [];
  String? selectedTime = '09:00';

  List<Map<String, dynamic>> services = [];
  List<PaymentModel> paymentMethods = [];

  bool loadingServices = true;
  bool loadingPayments = true;
  bool loadingTimes = false;
  bool submitting = false;

  int? selectedPaymentId;
  String selectedPaymentNome = '';

  int? loggedUserId;

  bool get isLoading => loadingServices || loadingPayments;

  List<Map<String, dynamic>> get selectedServices =>
      services.where((s) => s['selected'] == true).toList();

  double get total =>
      selectedServices.fold(0.0, (sum, s) => sum + (s['price'] as double));

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

  Future<void> init() async {
    await Future.wait([
      _fetchServices(),
      _fetchPayments(),
      _loadUser(),
      fetchUnavailableTimes(selectedDate),
    ]);
  }

  Future<void> _loadUser() async {
    final user = await AuthService().getLoggedUser();
    loggedUserId = user?.id;
    notifyListeners();
  }

  Future<void> _fetchServices() async {
    try {
      final all = await _servicesService.getServices();
      final filtered =
          all.where((s) => _allowedServiceIds.contains(s.id)).toList()..sort(
            (a, b) =>
                _allowedServiceIds.indexOf(a.id) -
                _allowedServiceIds.indexOf(b.id),
          );

      services = filtered
          .map(
            (s) => {
              'id': s.id,
              'title': capitalizeFirst(s.nome),
              'subtitle': subtitleForService(s.id),
              'price': s.valor,
              'icon': iconForService(s.id),
              'selected': s.id == 1,
            },
          )
          .toList();
    } catch (_) {
    } finally {
      loadingServices = false;
      notifyListeners();
    }
  }

  Future<void> _fetchPayments() async {
    try {
      final methods = await _paymentService.getPayments();
      paymentMethods = methods;
      if (methods.isNotEmpty) {
        selectedPaymentId = methods.first.id;
        selectedPaymentNome = methods.first.nome;
      }
    } catch (_) {
    } finally {
      loadingPayments = false;
      notifyListeners();
    }
  }

  Future<void> fetchUnavailableTimes(DateTime dia) async {
    loadingTimes = true;
    notifyListeners();
    try {
      final blocked = await _appointmentService.getUnavailableTimes(dia);
      unavailableTimes = blocked;
      if (selectedTime != null && blocked.contains(selectedTime)) {
        selectedTime = null;
      }
    } catch (_) {
    } finally {
      loadingTimes = false;
      notifyListeners();
    }
  }

  // ── Ações ─────────────────────────────────────────────────────────────────
  void previousMonth() {
    final now = DateTime.now();
    final anterior = DateTime(focusedMonth.year, focusedMonth.month - 1);
    if (anterior.isBefore(DateTime(now.year, now.month))) return;
    focusedMonth = anterior;
    notifyListeners();
  }

  void nextMonth() {
    focusedMonth = DateTime(focusedMonth.year, focusedMonth.month + 1);
    notifyListeners();
  }

  void selectDate(DateTime date) {
    selectedDate = date;
    focusedMonth = DateTime(date.year, date.month);
    selectedTime = null;
    notifyListeners();
    fetchUnavailableTimes(date);
  }

  void selectTime(String time) {
    if (unavailableTimes.contains(time)) return;
    selectedTime = time;
    notifyListeners();
  }

  void toggleService(int index) {
    services[index]['selected'] = !services[index]['selected'];
    notifyListeners();
  }

  void selectPayment(PaymentModel payment) {
    selectedPaymentId = payment.id;
    selectedPaymentNome = payment.nome;
    notifyListeners();
  }

  /// Retorna uma mensagem de erro ou null em caso de sucesso.
  Future<String?> confirmar() async {
    if (selectedTime == null) return 'Selecione um horário.';
    if (selectedServices.isEmpty) return 'Selecione pelo menos um serviço.';
    if (selectedPaymentId == null) return 'Selecione um método de pagamento.';
    if (loggedUserId == null)
      return 'Usuário não identificado. Faça login novamente.';

    submitting = true;
    notifyListeners();

    try {
      await _appointmentService.createAppointment(
        idUsuario: loggedUserId!,
        idPagamento: selectedPaymentId!,
        valorTotal: total,
        dia: selectedDate,
        hora: '${selectedTime!}:00',
        servicos: selectedServices
            .map((s) => {'id_servico': s['id'], 'valor_unitario': s['price']})
            .toList(),
      );
      await fetchUnavailableTimes(selectedDate);
      return null; // sucesso
    } catch (e) {
      return e.toString().replaceFirst('Exception: ', '');
    } finally {
      submitting = false;
      notifyListeners();
    }
  }
}
