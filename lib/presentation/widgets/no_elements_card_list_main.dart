// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'no_elements_card_list_background.dart';
import 'no_elements_overlay.dart';

class NoElementsCardListMain extends StatelessWidget {
  const NoElementsCardListMain({
    @required Key key,
    @required this.cardHeight,
    @required this.leftEdgePadding,
    this.aspectRatio = 2 / 3,
  }) : super(key: key);

  final double cardHeight;
  final double leftEdgePadding;
  final double aspectRatio;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: cardHeight,
      child: Stack(
        children: [
          NoElementsCardListBackground(
            leftEdgeInsets: leftEdgePadding,
            aspectRatio: aspectRatio,
          ),
          NoElementsOverlay(),
          // NetworkErrorOverlay(),
        ],
      ),
    );
  }
}
