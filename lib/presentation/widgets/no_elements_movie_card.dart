// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class NoElementsMovieCard extends StatelessWidget {
  final double aspectRatio;
  const NoElementsMovieCard({
    Key? key,
    this.aspectRatio = 2 / 3,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      // aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white10,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey.withOpacity(0.1),
        ),
      ),
    );
  }
}
