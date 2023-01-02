import 'package:app_tournament/ui/theme/text.dart';
import 'package:flutter/cupertino.dart';

class GradientStyle extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const GradientStyle(
    this.text, {
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: DesignText.title(
        text,
        style: style,
      ),
    );
  }
}
