import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal:0),
      padding: EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF062200),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(icon: Icons.calendar_today, label: "Agendar"),
          _NavItem(icon: Icons.person, label: "Profile"),
          _NavItem(icon: Icons.auto_awesome, label: "IA"),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.greenAccent),
        SizedBox(height: 4),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
