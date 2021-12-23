// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:auto_size_text/auto_size_text.dart';

class NoImageMovieCard extends StatelessWidget {
  final double aspectRatio;
  const NoImageMovieCard({
    Key? key,
    this.aspectRatio = 2 / 3,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      key: key,
      aspectRatio: aspectRatio,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey.withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Center(
            child: AutoSizeText(
              'No Image',
              style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Colors.white.withOpacity(0.2),
                  ),
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
