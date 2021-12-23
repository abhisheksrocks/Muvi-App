// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../models/movie_model.dart';
import '../core/app_style.dart';
import 'genre_text.dart';
import 'my_image_viewer.dart';
import 'title_text.dart';

class SingleCarouselMovieCard extends StatelessWidget {
  final double cardHeight;
  final double difference;
  const SingleCarouselMovieCard({
    Key? key,
    required MovieModel currentMovieModel,
    required this.cardHeight,
    required this.difference,
  })   : _currentMovieModel = currentMovieModel,
        super(key: key);

  final MovieModel _currentMovieModel;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/movie-info', arguments: {
          'movieId': _currentMovieModel.id,
        });
      },
      child: Center(
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: ShaderMask(
                  shaderCallback: AppStyle().defaultPosterShader,
                  child: MyImageViewer(
                    imagePath: _currentMovieModel.posterImagePath!,
                    widgetWidth: cardHeight * 2 / 3,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(
                    title: _currentMovieModel.title!,
                    textStyle: Theme.of(context).textTheme.headline2!,
                  ),
                  GenreText(
                    genreIds: _currentMovieModel.genreIds!,
                    textStyle: Theme.of(context).textTheme.subtitle1!,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
