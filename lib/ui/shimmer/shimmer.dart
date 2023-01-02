import 'package:flutter/material.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DarkModeProvider darkModeProvider =
        Provider.of<DarkModeProvider>(context);
    return Shimmer.fromColors(
      baseColor: darkModeProvider.isDarkTheme
          ? DesignColor.blackAppbar.withOpacity(0.2)
          : Colors.grey.shade300,
      highlightColor: darkModeProvider.isDarkTheme
          ? DesignColor.blackAppbar
          : Colors.grey.shade100,
      enabled: true,
      child: const Card(
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
