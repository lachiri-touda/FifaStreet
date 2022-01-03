// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:socceirb/constants.dart';

class HomeLocationInput extends StatelessWidget {
  const HomeLocationInput({
    Key? key,
    required this.locationController,
  }) : super(key: key);

  final TextEditingController locationController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: SizeConfig.screenWidth * 0.85,
        height: SizeConfig.screenHeight * 0.07,
        child: TextField(
          controller: locationController,
          style: TextStyle(color: Colors.white),
          obscureText: false,
          textAlign: TextAlign.left,
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.location_on_sharp,
              color: kGoldenColor,
              size: 20,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 35,
              vertical: 20,
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
            hintText: 'Filter by location',
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 17),
          ),
        ),
      ),
    );
  }
}
