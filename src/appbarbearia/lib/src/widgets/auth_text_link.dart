import 'package:flutter/material.dart';

class AuthTextLink extends StatelessWidget {
  final String prefixText;
  final String actionText;
  final VoidCallback onTap;

  const AuthTextLink({
    super.key,
    required this.prefixText,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Text(
          prefixText,
          style: const TextStyle(
            fontSize: 15,
            color: Colors.black54,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 15,
              color: Colors.green,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}