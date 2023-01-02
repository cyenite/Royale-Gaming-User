import 'package:app_tournament/ui/shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class GameShimmer extends StatelessWidget {
  const GameShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        return const ShimmerCard();
      },
      itemCount: 14,
    );
  }
}
