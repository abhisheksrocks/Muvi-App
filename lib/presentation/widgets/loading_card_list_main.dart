// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'loading_shimmer_placeholder.dart';
import 'loading_timeout_overlay.dart';

class LoadingCardListMain extends StatelessWidget {
  const LoadingCardListMain({
    @required Key key,
    @required this.cardHeight,
    @required this.leftEdgePadding,
    @required this.functionToExecute,
    @required this.state,
    this.aspectRatio = 2 / 3,
  }) : super(key: key);

  final dynamic state;
  final double cardHeight;
  final double leftEdgePadding;
  final double aspectRatio;
  final Function functionToExecute;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      height: cardHeight,
      child: Stack(
        children: [
          ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: index == 0
                    ? EdgeInsets.only(left: leftEdgePadding, right: 8)
                    : EdgeInsets.symmetric(horizontal: 8),
                child: LoadingShimmerPlaceholder(
                  aspectRatio: aspectRatio,
                ),
              );
            },
          ),
          if (state.timeoutExhausted)
            LoadingTimeoutOverlay(functionToExecute: functionToExecute),
        ],
      ),
    );
  }
}
