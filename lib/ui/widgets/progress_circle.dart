import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:flutter/material.dart';

// SizedBox ProgressAwesome() {
//   return NewWidget();
// }

class ProgressAwesome extends StatelessWidget {
  const ProgressAwesome({
    Key? key,
    this.color = DesignColor.blueSmart,
  }) : super(key: key);
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      width: 26,
      child: CircularProgressIndicator(
        strokeWidth: 1.5,
        color: color,
      ),
    );
  }
}
