import 'package:flutter/services.dart';

class UsernameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final filteredText = newValue.text.replaceAll(
      RegExp(r'[^a-zA-Z0-9_]'),
      '',
    );

    return TextEditingValue(
      text: filteredText,
      selection: TextSelection.collapsed(offset: filteredText.length),
    );
  }
}