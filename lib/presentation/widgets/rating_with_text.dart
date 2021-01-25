// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// 🌎 Project imports:
import '../core/app_style.dart';

class RatingWithText extends StatelessWidget {
  final int totalRatingCount;
  final double avgRatingOutOfTen;
  const RatingWithText({
    Key key,
    this.totalRatingCount,
    @required this.avgRatingOutOfTen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return avgRatingOutOfTen != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RatingBarIndicator(
                itemBuilder: (context, index) => ShaderMask(
                  shaderCallback: (bounds) =>
                      AppStyle().defaultLinearGradient().createShader(bounds),
                  child: Icon(
                    Icons.star,
                  ),
                ),
                itemSize: 18,
                rating: avgRatingOutOfTen / 2,
                itemPadding: EdgeInsets.only(right: 8),
              ),
              totalRatingCount != null
                  ? Text(
                      '$totalRatingCount Ratings',
                      style: Theme.of(context).textTheme.subtitle1,
                    )
                  : SizedBox(),
            ],
          )
        : SizedBox();
  }
}
