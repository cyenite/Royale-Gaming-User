import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class AnimateShimmer extends StatelessWidget {
  const AnimateShimmer({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final DarkModeProvider darkModeProvider =
        Provider.of<DarkModeProvider>(context);
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Lottie.asset(
          'assets/loading_animation_shimmer.json',
        ),
        if (darkModeProvider.isDarkTheme)
          Container(
            color: DesignColor.blackBackground.withOpacity(0.5),
          ),
      ],
    );
  }
}
