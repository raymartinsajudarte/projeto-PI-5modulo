import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextInput extends StatelessWidget {
  final String textPlaceholder;
  final bool obscure;
  final TextEditingController controller;
  final String? label;
  final Color? fillColor;
  final bool filled;

  final List<TextInputFormatter>? inputFormatters; // NOVO
  final TextInputType? keyboardType; // NOVO

  const TextInput({
    this.textPlaceholder = '',
    required this.obscure,
    required this.controller,
    this.label,
    this.fillColor,
    this.filled = false,
    this.inputFormatters, // NOVO
    this.keyboardType, // NOVO
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
            style: const TextStyle(fontSize: 12, color: Color(0xFF999999)),
          ),
          const SizedBox(height: 6),
        ],

        TextField(
          controller: controller,
          obscureText: obscure,
          inputFormatters: inputFormatters, // AQUI
          keyboardType: keyboardType, // AQUI
          style: const TextStyle(fontSize: 14, color: Color(0xFF222222)),
          decoration: InputDecoration(
            filled: filled,
            fillColor: fillColor,
            hintText: textPlaceholder,
            contentPadding: const EdgeInsets.all(12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ],
    );
  }
}