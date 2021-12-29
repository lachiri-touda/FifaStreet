import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.controller,
    required this.label,
  }) : super(key: key);
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          cursorHeight: 27,
          decoration: InputDecoration(
            labelText: label,
          ),
        ),
      ],
    );
  }
}
