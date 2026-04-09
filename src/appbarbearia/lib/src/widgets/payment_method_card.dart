import 'package:flutter/material.dart';

class PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? Color(0xFF158F00) : Colors.transparent;
    final indicatorColor = isSelected ? Color(0xFF158F00) : Color(0xFFD9D9D9);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 14),
        padding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Color(0xFFF4F4F4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Color(0xFF158F00), size: 22),
            ),
            SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF222222),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 11, color: Color(0xFF9B9B9B)),
                  ),
                ],
              ),
            ),

            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: indicatorColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
