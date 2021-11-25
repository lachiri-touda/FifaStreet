import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  const RoundButton({
    Key? key,
    this.press,
    required this.color,
    required this.icon,
  }) : super(key: key);

  final GestureTapCallback? press;
  final Icon icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(60),
      onTap: press,
      child: Container(
        margin: const EdgeInsets.all(12),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: icon,
      ),
    );
  }
}