import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.textInputType,
    this.hintText,
  }) : super(key: key);
  final String label;
  final TextInputType? textInputType;
  final TextEditingController controller;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: controller,
          keyboardType: textInputType ?? TextInputType.text,
          cursorHeight: 27,
          decoration: InputDecoration(
              labelText: label,
              hintText: hintText ?? '',
              hintStyle: const TextStyle(
                fontSize: 14,
              )),
        ),
      ],
    );
  }
}
