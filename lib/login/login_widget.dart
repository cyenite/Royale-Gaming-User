import 'package:flutter/material.dart';
import 'package:app_tournament/config/hive_open_ad.dart';

class LoginButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;
  final double bottomLeft;
  final double bottomRight;
  final double topLeft;
  final double topRight;
  const LoginButton({
    Key? key,
    required this.color,
    required this.icon,
    required this.text,
    required this.loginMethod,
    this.bottomLeft = 4,
    this.bottomRight = 4,
    this.topLeft = 4,
    this.topRight = 4,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 18,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.fromLTRB(19, 18, 19, 18),
          backgroundColor: color,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottomLeft),
              bottomRight: Radius.circular(bottomRight),
              topLeft: Radius.circular(topLeft),
              topRight: Radius.circular(topRight),
            ),
          ),
        ),
        onPressed: () {
          putopenAdHiveFalse();
          loginMethod();
        },
        label: Text(text, textAlign: TextAlign.center),
      ),
    );
  }
}
