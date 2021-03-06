// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:socceirb/constants.dart';

Future<void> showMyDialog(
    {required String title, required String message, required context}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: kBaseColor,
        title: Text(
          title,
          style: TextStyle(
            fontSize: 22,
            color: kGoldenColor,
            fontWeight: FontWeight.w700,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: SingleChildScrollView(
          child: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 25,
              width: 35,
              margin: EdgeInsets.symmetric(horizontal: 35, vertical: 8),
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
              decoration: BoxDecoration(
                color: kGoldenColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text(
                'OK',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kBaseColor,
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
