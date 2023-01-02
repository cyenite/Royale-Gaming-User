import 'package:flutter/material.dart';

import 'package:app_tournament/ui/theme/container.dart';
import 'package:app_tournament/ui/theme/text.dart';

class ProBadge extends StatelessWidget {
  final double marginRight;
  final double? fontSize;
  final String proBadge;
  const ProBadge({
    Key? key,
    required this.marginRight,
    this.fontSize,
    required this.proBadge,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      right: 0,
      child: DesignContainer(
        margin: EdgeInsets.fromLTRB(0, 0, marginRight, 0),
        padding: const EdgeInsets.all(0),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(4),
          bottomRight: Radius.circular(0),
          topLeft: Radius.circular(0),
          topRight: Radius.circular(4),
        ),
        color: const Color(0xffff4757),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
          child: DesignText.bold2(
            proBadge,
            fontWeight: 700,
            fontSize: fontSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
