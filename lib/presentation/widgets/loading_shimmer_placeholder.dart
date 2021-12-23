// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:shimmer/shimmer.dart';

class LoadingShimmerPlaceholder extends StatelessWidget {
  final Color baseColor;
  final Color highlightColor;
  final double aspectRatio;
  const LoadingShimmerPlaceholder({
    Key? key,
    this.baseColor = Colors.white10,
    this.highlightColor = Colors.white,
    this.aspectRatio = 2 / 3,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
            color: Colors.white10,
          ),
          // child: Center(
          //   child: CircularProgressIndicator(),
          // ),
        ),
      ),
    );
  }
}
