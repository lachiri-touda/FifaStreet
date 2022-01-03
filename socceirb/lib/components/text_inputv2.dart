// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:socceirb/constants.dart';

class TextInputV2 extends StatelessWidget {
  const TextInputV2({
    Key? key,
    required this.controller,
    required this.hintText,
    this.icon,
    this.textInputType,
    this.obscure,
  }) : super(key: key);

  final TextEditingController controller;
  final bool? obscure;
  final IconData? icon;
  final String hintText;
  final TextInputType? textInputType;
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: SizeConfig.screenWidth * 0.85,
        height: SizeConfig.screenHeight * 0.07,
        child: TextField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          obscureText: obscure ?? false,
          textAlign: TextAlign.left,
          keyboardType: textInputType ?? TextInputType.text,
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    color: kGoldenColor,
                    size: 20,
                  )
                : Icon(null),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 35,
              vertical: 10,
            ),
            filled: true,
            fillColor: Color(0xff28293f),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color(0x00ffffff)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Color(0x00ffffff)),
            ),
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 17),
          ),
        ),
      ),
    );
  }
}
