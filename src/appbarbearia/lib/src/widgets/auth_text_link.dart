import 'package:flutter/material.dart';

class AuthTextLink extends StatelessWidget {
  final String prefixText;
  final String actionText;
  final VoidCallback onTap;
  final double textSize;

  const AuthTextLink({
    super.key,
    required this.prefixText,
    required this.actionText,
    required this.onTap,
    required this.textSize
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(prefixText, style: TextStyle(fontSize: textSize, color: Colors.black54)),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: TextStyle(
              fontSize: textSize,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
