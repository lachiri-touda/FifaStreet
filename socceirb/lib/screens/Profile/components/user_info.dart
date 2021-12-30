import 'package:flutter/material.dart';
import 'package:socceirb/constants.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({
    Key? key,
    required this.label,
    required this.value,
    this.press,
  }) : super(key: key);

  final String label;
  final String value;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: press,
      child: Container(
        height: SizeConfig.screenHeight * 0.06,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: SizeConfig.screenWidth * 0.07),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 17,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 15,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
