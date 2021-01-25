// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'network_error_movie_card.dart';

class NetworkErrorCardListBackground extends StatelessWidget {
  final double leftEdgeInsets;
  final double aspectRatio;
  const NetworkErrorCardListBackground({
    Key key,
    this.leftEdgeInsets = 8,
    this.aspectRatio = 2 / 3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: index == 0
              ? EdgeInsets.only(left: leftEdgeInsets, right: 8)
              : EdgeInsets.symmetric(horizontal: 8),
          child: NetworkErrorMovieCard(
            aspectRatio: aspectRatio,
          ),
        );
      },
    );
  }
}
