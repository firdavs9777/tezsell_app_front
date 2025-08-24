import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget _buildTextField({
  required BuildContext context, // Add BuildContext as a required parameter
  required TextEditingController controller,
  required String labelText,
  int maxLines = 1,
  TextInputType keyboardType = TextInputType.text,
  List<TextInputFormatter>? inputFormatters,
}) {
  return TextField(
    controller: controller,
    maxLines: maxLines,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    decoration: InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      labelStyle: TextStyle(
        color: Theme.of(context).colorScheme.onBackground, // Use context here
      ),
    ),
  );
}
