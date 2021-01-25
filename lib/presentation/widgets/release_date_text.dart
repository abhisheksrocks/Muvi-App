// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:intl/intl.dart';

class ReleaseDateText extends StatelessWidget {
  final DateTime releaseDate;
  final TextStyle textStyle;
  final String dateFormat;
  const ReleaseDateText({
    Key key,
    @required this.releaseDate,
    @required this.textStyle,
    this.dateFormat = 'yMMMd',
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return releaseDate != null
        ? Text(
            "${DateFormat('$dateFormat').format(releaseDate)}",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textStyle,
          )
        : Text(
            'Unreleased',
            style: Theme.of(context).textTheme.subtitle1,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
  }
}
