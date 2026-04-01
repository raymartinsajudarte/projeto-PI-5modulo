import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String textPlaceholder;
  final bool obscure;
  final TextEditingController controller;
  final String? label;
  final Color? fillColor;
  final bool filled;

  const TextInput({
    this.textPlaceholder = '',
    required this.obscure,
    required this.controller,
    this.label,
    this.fillColor,
    this.filled = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
          SizedBox(height: 6),
        ],

        TextField(
          controller: controller,
          obscureText: obscure,
          style: TextStyle(fontSize: 14, color: Color(0xFF222222)),
          decoration: InputDecoration(
            filled: filled,
            fillColor: fillColor,
            hintText: textPlaceholder,
            contentPadding: EdgeInsets.all(12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
      ],
    );
  }
}
