import 'package:flutter/material.dart';

class TextInput extends StatelessWidget {
  final String textPlaceholder;
  final bool obscure;
  final TextEditingController controller; 

  const TextInput({
    required this.textPlaceholder,
    required this.obscure,
    required this.controller,
    super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(fontSize: 14, color: Color(0xFF777777)),
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
        contentPadding: EdgeInsets.all(10),
        hintText: textPlaceholder,
        
      ),
    );
  }
}
