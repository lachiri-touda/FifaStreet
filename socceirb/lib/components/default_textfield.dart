import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.textInputType,
    this.hintText,
    this.obscure,
  }) : super(key: key);
  final String label;
  final TextInputType? textInputType;
  final TextEditingController controller;
  final String? hintText;
  final bool? obscure;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder outlineInputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(28),
      borderSide: const BorderSide(color: Colors.purple),
      gapPadding: 10,
    );
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: controller,
          keyboardType: textInputType ?? TextInputType.text,
          cursorHeight: 27,
          obscureText: obscure ?? false,
          decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              enabledBorder: outlineInputBorder,
              focusedBorder: outlineInputBorder,
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
