import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;

  const OtpInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      keyboardType: TextInputType.number,

      maxLength: 6,

      textAlign: TextAlign.center,

      style: const TextStyle(
        fontSize: 24,
        letterSpacing: 12,
        fontWeight: FontWeight.bold,
      ),

      inputFormatters: [FilteringTextInputFormatter.digitsOnly],

      decoration: const InputDecoration(hintText: '------', counterText: ''),
    );
  }
}
