// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../models/genre_bucket.dart';

class GenreText extends StatelessWidget {
  // final MovieModel currentMovie;
  final List<int> genreIds;
  final TextStyle textStyle;
  const GenreText({
    Key? key,
    required this.genreIds,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return genreIds.isNotEmpty
        ? Builder(
            builder: (context) {
              GenreBucket _genresBucket = GenreBucket();
              int index = 0;
              String _genreMaker =
                  '${_genresBucket.getGenre(id: genreIds.elementAt(index++))}';
              for (; index < genreIds.length; index++) {
                if (_genreMaker.trim() != '') {
                  _genreMaker =
                      "$_genreMaker, ${_genresBucket.getGenre(id: genreIds.elementAt(index))}";
                }
              }
              if (_genreMaker.trim() != '') {
                return Text(
                  // "Action, Crime, Drama ",
                  "$_genreMaker",
                  semanticsLabel: "Genre includes $_genreMaker",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle,
                );
              } else {
                return SizedBox();
              }
            },
          )
        : SizedBox();
  }
}
