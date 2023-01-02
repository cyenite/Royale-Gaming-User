import 'package:flutter/cupertino.dart';

BoxDecoration getProfileBGColor() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(146.0),
    gradient: const RadialGradient(
      center: Alignment(0.54, 1.19),
      radius: 0.953,
      colors: [
        Color(0xFFFFDD55),
        Color(0xFFFFE477),
        Color(0xFFFF8D7E),
        Color(0xFFE825C1)
      ],
      stops: [0.0, 0.127, 0.492, 1.0],
    ),
  );
}
