// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:auto_size_text/auto_size_text.dart';

class TitleText extends StatelessWidget {
  final String title;
  final TextStyle textStyle;
  const TitleText({
    Key? key,
    required this.title,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      "$title",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: textStyle,
      minFontSize: 12,
    );
  }
}
