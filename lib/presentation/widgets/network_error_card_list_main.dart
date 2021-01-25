// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'network_error_card_list_background.dart';
import 'network_error_overlay.dart';

class NetworkErrorCardListMain extends StatelessWidget {
  const NetworkErrorCardListMain({
    @required Key key,
    @required this.cardHeight,
    @required this.leftEdgeInsets,
    this.functionToExecute,
    this.aspectRatio = 2 / 3,
  }) : super(key: key);

  final double cardHeight;
  final double leftEdgeInsets;
  final double aspectRatio;
  final Function functionToExecute;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: cardHeight,
      child: Stack(
        children: [
          NetworkErrorCardListBackground(
            leftEdgeInsets: leftEdgeInsets,
            aspectRatio: aspectRatio,
          ),
          NetworkErrorOverlay(
            functionToExecute: functionToExecute,
          ),
        ],
      ),
    );
  }
}
