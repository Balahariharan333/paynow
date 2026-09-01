import 'package:flutter/services.dart';

/// Formatter that physically restricts users from entering or pasting
/// any number greater than the specified maximum limit (default: 1,00,000 / 1 Lakh)
/// and constrains decimal places to 2 digits.
class MaxAmountTextInputFormatter extends TextInputFormatter {
  final double max;
  final int maxDecimalDigits;

  const MaxAmountTextInputFormatter({
    this.max = 100000.0,
    this.maxDecimalDigits = 2,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(',', '').trim();
    if (text.isEmpty) {
      return newValue;
    }

    // Only allow numbers and at most one decimal point
    if (!RegExp(r'^\d*\.?\d*$').hasMatch(text)) {
      return oldValue;
    }

    // Constrain decimal digits
    if (text.contains('.')) {
      final parts = text.split('.');
      if (parts.length > 1 && parts[1].length > maxDecimalDigits) {
        return oldValue;
      }
    }

    final double? val = double.tryParse(text);
    if (val == null) {
      return oldValue;
    }

    // Block typing any number exceeding 1 Lakh (100,000)
    if (val > max) {
      return oldValue;
    }

    return newValue;
  }
}
