import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class NotFoundAnimation extends StatelessWidget {
  const NotFoundAnimation({
    Key? key,
    required this.text,
    this.color,
  }) : super(key: key);
  final String text;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    final DarkModeProvider darkModeProvider =
        Provider.of<DarkModeProvider>(context);
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(
                  'assets/not_found.json',
                ),
                if (darkModeProvider.isDarkTheme)
                  Container(
                    color: DesignColor.blackBackground.withOpacity(0.5),
                  ),
              ],
            ),
          ),
          DesignText.bold2(
            text,
            fontSize: 12,
            fontWeight: 700,
            color: color,
          )
        ],
      ),
    );
  }
}
