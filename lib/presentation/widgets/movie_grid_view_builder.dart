// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../models/movie_bucket.dart';
import 'single_list_movie_card.dart';

class MovieGridViewBuilder extends StatelessWidget {
  const MovieGridViewBuilder(
      {Key key,
      @required this.scrollController,
      @required this.cubit,
      @required this.eachCardWidth,
      @required this.movieBucketObject})
      : super(key: key);

  final ScrollController scrollController;
  final dynamic cubit;
  final double eachCardWidth;
  final MovieBucket movieBucketObject;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        controller: scrollController,
        itemCount: cubit.listOfAllMoviesId.length,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent:
              eachCardWidth + 16 + 1, //ie. + padding + 1 extra for safety
          childAspectRatio: (eachCardWidth + 16) / (eachCardWidth * 3 / 2),
          // crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemBuilder: (context, index) => SingleListMovieCard(
          cardWidth: eachCardWidth,
          currentMovieModel: movieBucketObject.getInfo(
            cubit.listOfAllMoviesId.elementAt(index),
          ),
        ),
      ),
    );
  }
}
