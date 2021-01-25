// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class NetworkErrorMovieCard extends StatelessWidget {
  final double aspectRatio;
  const NetworkErrorMovieCard({
    Key key,
    this.aspectRatio = 2 / 3,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      key: key,
      aspectRatio: aspectRatio,
      // aspectRatio: 16 / 9,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Center(
          child: Icon(
            Icons.warning,
            color: Colors.grey.withOpacity(0.1),
          ),
        ),
      ),
    );
  }
}
