// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:socceirb/constants.dart';

Future<void> showSuccessAlert(
    {required String message, required context, required String image}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        elevation: 2,
        backgroundColor: kBaseColor,
        title: Align(
          alignment: Alignment.topCenter,
          child: Image.asset(
            image,
            height: 70,
            width: 70,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: SingleChildScrollView(
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
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
              height: 35,
              width: 45,
              margin: EdgeInsets.symmetric(horizontal: 35, vertical: 8),
              decoration: BoxDecoration(
                color: kGoldenColor,
                borderRadius: BorderRadius.circular(3),
              ),
              child: Center(
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
          ),
        ],
      );
    },
  );
}
