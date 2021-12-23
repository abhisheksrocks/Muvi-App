// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../core/app_style.dart';
import 'no_elements_movie_card.dart';

class NoElementsCardListBackground extends StatelessWidget {
  final double leftEdgeInsets;
  final double aspectRatio;
  const NoElementsCardListBackground({
    Key? key,
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
          child: ShaderMask(
            shaderCallback: AppStyle().defaultPosterShader,
            child: NoElementsMovieCard(
              aspectRatio: aspectRatio,
            ),
          ),
        );
      },
    );
  }
}
