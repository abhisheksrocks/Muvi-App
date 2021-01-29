// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:readmore/readmore.dart';

class SummaryReviewText extends StatelessWidget {
  final String textData;
  final TextStyle textStyle;
  final int linesToShow;
  const SummaryReviewText({
    Key key,
    @required this.textData,
    @required this.textStyle,
    this.linesToShow = 5,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return textData.contains(new RegExp(
      r'\<[a-zA-Z]*\>',
    ))
        ? Html(
            data: textData,
            style: {
              '*': Style(
                color: textStyle.color,
                fontFamily: textStyle.fontFamily,
              )
            },
          )
        : ReadMoreText(
            textData,
            style: textStyle,
            trimLines: linesToShow,
            trimMode: TrimMode.Line,
            trimExpandedText: '... show less',
            trimCollapsedText: '... show more',
            delimiter: null,
            lessStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontStyle: FontStyle.italic,
            ),
            moreStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontStyle: FontStyle.italic,
            ),
            delimiterStyle: TextStyle(
              color: Theme.of(context).accentColor,
              fontStyle: FontStyle.italic,
            ),
          );
  }
}
