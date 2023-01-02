import 'package:flutter/material.dart';

class AnimatedProgressbar extends StatelessWidget {
  final double value;
  final double height;

  const AnimatedProgressbar({
    Key? key,
    required this.value,
    this.height = 6,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints box) {
        return Container(
          padding: const EdgeInsets.all(10),
          width: box.maxWidth,
          child: Stack(
            children: [
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutCubic,
                height: height,
                width: box.maxWidth * _floor(value),
                decoration: BoxDecoration(
                  color: _colorGen(value),
                  borderRadius: BorderRadius.all(
                    Radius.circular(height),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Always round negative or NaNs to min value
  _floor(double value, [min = 0.0]) {
    return value.sign <= min ? min : value;
  }

  _colorGen(double value) {
    int rbg = (value * 255).toInt();
    return Colors.deepOrange.withRed(rbg).withGreen(255 - rbg);
  }
}

class ProgressBar extends StatelessWidget {
  const ProgressBar(
      {Key? key, required this.maxPlayers, required this.joinedPlayers})
      : super(key: key);
  final int maxPlayers;
  final int joinedPlayers;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _progressCount(maxPlayers, joinedPlayers),
        Expanded(
          child: AnimatedProgressbar(
            value: _calculateProgress(maxPlayers, joinedPlayers),
            height: 4,
          ),
        ),
      ],
    );
  }

  Widget _progressCount(int maxPlayers, int joinedPlayers) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        '$maxPlayers / $joinedPlayers',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      ),
    );
  }

  double _calculateProgress(int maxPlayers, int joinedPlayers) {
    try {
      int maxPlayer = maxPlayers;
      int joinedPlayer = joinedPlayers;
      return joinedPlayer / maxPlayer;
    } catch (err) {
      return 0.0;
    }
  }
}
