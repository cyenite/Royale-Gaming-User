import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class DarkModeToggle extends StatefulWidget {
  final ValueChanged onToggleCallback;
  const DarkModeToggle({
    Key? key,
    required this.onToggleCallback,
  }) : super(key: key);

  @override
  _DarkModeToggleState createState() => _DarkModeToggleState();
}

class _DarkModeToggleState extends State<DarkModeToggle> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<DarkModeProvider>(context);
    return GestureDetector(
      onTap: () {
        widget.onToggleCallback(1);
      },
      child: SizedBox(
        width: 48,
        height: 20,
        child: Stack(
          children: [
            Container(
              decoration: ShapeDecoration(
                  color: themeProvider.isDarkTheme
                      ? Colors.black
                      : Colors.blueGrey.shade300,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60))),
            ),
            AnimatedAlign(
              alignment: themeProvider.isDarkTheme
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
              child: Container(
                alignment: Alignment.center,
                width: 30,
                height: 12,
                child: Icon(
                  themeProvider.isDarkTheme
                      ? Ionicons.sunny_outline
                      : Ionicons.moon_outline,
                  size: 12,
                  color:
                      themeProvider.isDarkTheme ? Colors.white : Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
