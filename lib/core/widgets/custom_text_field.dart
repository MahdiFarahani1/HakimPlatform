import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;
  final int? maxLength;
  final void Function(String)? onChanged;
  final Color textColor; // 👈 added textColor property

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.enabled = true,
    this.maxLength,
    this.onChanged,
    this.textColor = Colors.white, // 👈 default white
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      //textAlign: TextAlign.end,
      controller: controller,
      style: TextStyle(color: textColor), // 👈 apply color
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        counterText: '',
      ),
      keyboardType: keyboardType,
      validator: validator,
      enabled: enabled,
      maxLength: maxLength,
      onChanged: onChanged,
    );
  }
}
