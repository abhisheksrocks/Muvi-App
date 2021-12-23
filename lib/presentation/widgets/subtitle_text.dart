// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:auto_size_text/auto_size_text.dart';

class SubtitleText extends StatelessWidget {
  const SubtitleText({
    Key? key,
    required this.textToDisplay,
    required this.textStyle,
  }) : super(key: key);

  final String textToDisplay;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      '$textToDisplay',
      style: textStyle,
      maxLines: 1,
      minFontSize: 10,
      overflow: TextOverflow.ellipsis,
    );
  }
}
