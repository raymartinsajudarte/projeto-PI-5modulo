import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final Function(DateTime) onDateSelected;

  const CalendarCard({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> weekDays = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];

    final int year = focusedMonth.year;
    final int month = focusedMonth.month;

    final DateTime firstDayOfMonth = DateTime(year, month, 1);
    final int daysInMonth = DateTime(year, month + 1, 0).day;

    final int startWeekday = firstDayOfMonth.weekday % 7;

    List<Widget> dayWidgets = [];

    for (int i = 0; i < startWeekday; i++) {
      dayWidgets.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final currentDate = DateTime(year, month, day);

      final bool isSelected =
          currentDate.year == selectedDate.year &&
          currentDate.month == selectedDate.month &&
          currentDate.day == selectedDate.day;

      final bool isSunday = currentDate.weekday == DateTime.sunday;

      dayWidgets.add(
        GestureDetector(
          onTap: () => onDateSelected(currentDate),
          child: Container(
            width: 34,
            height: 34,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF6CAB5B) : Colors.transparent,
              shape: BoxShape.circle,
            ),
            child: Text(
              '$day',
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : isSunday
                    ? Colors.red
                    : Color(0xFF2B2B2B),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
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
              Icon(Icons.calendar_month, size: 18, color: Color(0xFF1F1F1F)),
              SizedBox(width: 8),
              Text(
                'Selecione a Data',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1F1F1F),
                ),
              ),
            ],
          ),
          SizedBox(height: 14),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: onPreviousMonth,
                  child: Icon(Icons.chevron_left, color: Color(0xFF2B2B2B)),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _monthYearText(focusedMonth),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2B2B2B),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onNextMonth,
                  child: Icon(Icons.chevron_right, color: Color(0xFF2B2B2B)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Color(0xFF58AF45), width: 1.2),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: weekDays.asMap().entries.map((entry) {
                    final index = entry.key;
                    final day = entry.value;

                    final bool isSunday = index == 0;

                    return SizedBox(
                      width: 28,
                      child: Center(
                        child: Text(
                          day,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isSunday ? Colors.red : Color(0xFF3A3A3A),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),

                GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 4,
                  children: dayWidgets,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _monthYearText(DateTime date) {
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

    return '${months[date.month]} ${date.year}';
  }
}
