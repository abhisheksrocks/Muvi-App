// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ReviewBackgroundAllConditions extends StatelessWidget {
  final Color foregroundColor;
  const ReviewBackgroundAllConditions({
    Key? key,
    this.foregroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    height: 16,
                    width: 100,
                    color: foregroundColor,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Container(
                    height: 24,
                    width: 1,
                    color: foregroundColor,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  RatingBarIndicator(
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: foregroundColor,
                    ),
                    itemSize: 18,
                    rating: 5,
                    itemPadding: EdgeInsets.only(right: 8),
                  ),
                ],
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 12,
                width: constraints.maxWidth * 0.95,
                color: foregroundColor,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 12,
                width: constraints.maxWidth,
                color: foregroundColor,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 12,
                width: constraints.maxWidth * 0.98,
                color: foregroundColor,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 12,
                width: constraints.maxWidth * 0.6,
                color: foregroundColor,
              ),

              //-------One line gap--------/
              SizedBox(
                height: 20,
              ),
              Container(
                height: 12,
                width: constraints.maxWidth,
                color: foregroundColor,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 12,
                width: constraints.maxWidth * 0.98,
                color: foregroundColor,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 12,
                width: constraints.maxWidth,
                color: foregroundColor,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 12,
                width: constraints.maxWidth * 0.95,
                color: foregroundColor,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 12,
                width: constraints.maxWidth * 0.93,
                color: foregroundColor,
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                height: 12,
                width: constraints.maxWidth * 0.4,
                color: foregroundColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
