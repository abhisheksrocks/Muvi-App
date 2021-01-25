// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../models/movie_bucket.dart';
import 'movie_grid_view_builder.dart';
import 'page_loading_status.dart';

class ViewAllMoviesGridWithStatusWidget extends StatelessWidget {
  const ViewAllMoviesGridWithStatusWidget({
    Key key,
    @required this.scrollController,
    @required this.cubit,
    @required this.eachCardWidth,
  }) : super(key: key);

  final ScrollController scrollController;
  final cubit;
  final double eachCardWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MovieGridViewBuilder(
          scrollController: scrollController,
          cubit: cubit,
          eachCardWidth: eachCardWidth,
          movieBucketObject: MovieBucket(),
        ),
        PageLoadingStatus(
          cubit: cubit,
        ),
      ],
    );
  }
}
