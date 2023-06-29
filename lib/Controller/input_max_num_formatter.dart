import 'package:flutter/services.dart';

class MaxNumValueTextInputFormatter extends TextInputFormatter {
  final double maxValue;

  MaxNumValueTextInputFormatter(this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    final numericValue = double.tryParse(newValue.text);
    if (numericValue != null && numericValue > maxValue) {
      return oldValue;  
    }
    return newValue;
  }
} 