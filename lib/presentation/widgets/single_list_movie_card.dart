// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../models/movie_model.dart';
import '../core/app_style.dart';
import 'genre_text.dart';
import 'my_image_viewer.dart';
import 'release_date_text.dart';
import 'title_text.dart';

class SingleListMovieCard extends StatelessWidget {
  const SingleListMovieCard({
    Key key,
    @required this.cardWidth,
    @required MovieModel currentMovieModel,
    this.isUpcomingCard = false,
    this.isFirst = false,
    this.leftEdgeInsets = 8,
  })  : _currentMovieModel = currentMovieModel,
        cardHeight = cardWidth * 3 / 2,
        super(key: key);

  final double cardWidth;
  final double cardHeight;
  final MovieModel _currentMovieModel;
  final bool isUpcomingCard;
  final bool isFirst;
  final double leftEdgeInsets;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/movie-info', arguments: {
          'movieId': _currentMovieModel.id,
        });
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: isFirst
            ? EdgeInsets.only(left: leftEdgeInsets, right: 8)
            : EdgeInsets.symmetric(
                horizontal: 8,
              ),
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ShaderMask(
                shaderCallback: AppStyle().defaultPosterShader,
                child: MyImageViewer(
                  imagePath: _currentMovieModel.posterImagePath,
                  widgetWidth: cardWidth,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    title: _currentMovieModel.title,
                    textStyle: Theme.of(context).textTheme.headline3,
                  ),
                  !isUpcomingCard
                      ? GenreText(
                          genreIds: _currentMovieModel.genreIds,
                          textStyle: Theme.of(context).textTheme.subtitle2,
                        )
                      : ReleaseDateText(
                          releaseDate: _currentMovieModel.releaseDate,
                          textStyle: Theme.of(context).textTheme.subtitle2,
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
