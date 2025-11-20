import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,##0', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Handle empty input
    if (newValue.text.isEmpty) {
      return TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Remove commas and parse the raw number
    String rawValue = newValue.text.replaceAll(',', '');

    // Limit input to 9 digits
    if (rawValue.length > 9) {
      return oldValue; // Reject changes if input exceeds 9 digits
    }

    double? parsedValue = double.tryParse(rawValue);

    // If parsing fails, return the unformatted newValue
    if (parsedValue == null) {
      return newValue;
    }

    // Format the parsed number
    String formattedValue = _formatter.format(parsedValue);

    // Calculate the new cursor position
    int cursorPosition = formattedValue.length -
        (rawValue.length - newValue.selection.baseOffset);

    // Ensure cursor position is within bounds
    cursorPosition = cursorPosition.clamp(0, formattedValue.length);

    return TextEditingValue(
      text: formattedValue,
      selection: TextSelection.collapsed(offset: cursorPosition),
    );
  }
}
