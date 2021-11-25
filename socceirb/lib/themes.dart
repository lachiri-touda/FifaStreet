import 'package:flutter/material.dart';

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
                borderSide: const BorderSide(color: Colors.purple),
                gapPadding: 10,
              );
  return InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 25,
                vertical: 20,
              ),
              enabledBorder: outlineInputBorder,
              focusedBorder: outlineInputBorder,
              //border: outlineInputBorder,
            );
}