import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MobileInput extends StatelessWidget {
  final TextEditingController controller;

  const MobileInput({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.phone,

      maxLength: 10,

      inputFormatters: [FilteringTextInputFormatter.digitsOnly],

      decoration: const InputDecoration(
        labelText: 'Mobile Number',
        hintText: 'Enter mobile number',
        prefixText: '+91 ',
        counterText: '',
      ),
    );
  }
}
