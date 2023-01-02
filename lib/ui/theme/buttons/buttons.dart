import 'package:flutter/material.dart';
import 'package:app_tournament/ui/theme/text.dart';

class DesignButtons extends StatelessWidget {
  final Function onPressed;
  final String textLabel;
  final Icon icon;
  final Color? color;
  final Color? colorText;
  final double? bottomLeft;
  final double? bottomRight;
  final double? topLeft;
  final double? topRight;
  final bool? elevated;
  final double? pdleft;
  final double? pdtop;
  final double? pdright;
  final double? pdbottom;
  const DesignButtons.icon({
    Key? key,
    required this.onPressed,
    this.color,
    this.colorText,
    required this.textLabel,
    required this.icon,
    this.bottomLeft = 4,
    this.bottomRight = 4,
    this.topLeft = 4,
    this.topRight = 4,
    this.elevated = false,
    this.pdleft,
    this.pdtop,
    this.pdright,
    this.pdbottom,
  }) : super(key: key);
  const DesignButtons.customRadius({
    Key? key,
    required this.onPressed,
    this.color,
    this.colorText,
    required this.textLabel,
    required this.icon,
    this.bottomLeft = 4,
    this.bottomRight = 4,
    this.topLeft = 4,
    this.topRight = 4,
    this.elevated = false,
    this.pdleft,
    this.pdtop,
    this.pdright,
    this.pdbottom,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (elevated == false) {
      return TextButton.icon(
        style: TextButton.styleFrom(
          backgroundColor: color ?? Colors.blue.withOpacity(0.2),
          padding: EdgeInsets.fromLTRB(
              pdleft ?? 4, pdtop ?? 0, pdright ?? 4, pdbottom ?? 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottomLeft ?? 4),
              bottomRight: Radius.circular(bottomRight ?? 4),
              topLeft: Radius.circular(topLeft ?? 4),
              topRight: Radius.circular(topRight ?? 4),
            ),
          ),
        ),
        icon: icon,
        onPressed: () {
          onPressed();
        },
        label: DesignText.bold2(
          textLabel, color: colorText ?? Colors.black,
          // color: Colors.white,
          fontWeight: 800,
        ),
      );
    } else {
      return ElevatedButton.icon(
        // style: TextButton.styleFrom(
        //   backgroundColor: color ?? Colors.blue.withOpacity(0.2),
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.only(
        //       bottomLeft: Radius.circular(bottomLeft ?? 4),
        //       bottomRight: Radius.circular(bottomRight ?? 4),
        //       topLeft: Radius.circular(topLeft ?? 4),
        //       topRight: Radius.circular(topRight ?? 4),
        //     ),
        //   ),
        // ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.fromLTRB(
              pdleft ?? 19, pdtop ?? 18, pdright ?? 19, pdbottom ?? 18),
          backgroundColor: color,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(bottomLeft ?? 4),
              bottomRight: Radius.circular(bottomRight ?? 4),
              topLeft: Radius.circular(topLeft ?? 4),
              topRight: Radius.circular(topRight ?? 4),
            ),
          ),
        ),
        icon: icon,
        onPressed: () {
          onPressed();
        },
        label: DesignText.bold2(
          textLabel,
          color: colorText ?? Colors.white,
          fontWeight: 700,
        ),
      );
    }
  }
}
