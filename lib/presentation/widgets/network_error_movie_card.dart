// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:auto_size_text/auto_size_text.dart';

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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.warning,
                color: Colors.white.withOpacity(0.05),
              ),
              AutoSizeText(
                'Network Error',
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(color: Colors.white.withOpacity(0.05)),
                maxLines: 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
