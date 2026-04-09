import 'package:flutter/material.dart';

class TimeSlotButton extends StatelessWidget {
  final String time;
  final bool isSelected;
  final bool isDisabled;
  final VoidCallback? onTap;

  const TimeSlotButton({
    super.key,
    required this.time,
    required this.isSelected,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Colors.white;
    Color borderColor = const Color(0xFFD0D0D0);
    Color textColor = const Color(0xFF222222);

    if (isDisabled) {
      backgroundColor = const Color(0xFFF1F1F1);
      borderColor = const Color(0xFFE3E3E3);
      textColor = const Color(0xFFBDBDBD);
    } else if (isSelected) {
      backgroundColor = const Color(0xFF158F00);
      borderColor = const Color(0xFF158F00);
      textColor = Colors.white;
    }

    return GestureDetector(
      onTap: isDisabled ? null : onTap,
      child: Container(
        width: 62,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: borderColor,
            width: 1,
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
    );
  }
}