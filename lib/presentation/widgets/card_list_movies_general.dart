// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../cubit/movie_similar_fetcher_cubit.dart';
import '../../cubit/movies_now_showing_cubit.dart';
import '../../cubit/movies_popular_cubit.dart';
import '../../cubit/movies_upcoming_cubit.dart';
import '../../models/movie_bucket.dart';
import '../../models/movie_model.dart';
import 'loading_card_list_main.dart';
import 'network_error_card_list_main.dart';
import 'no_elements_card_list_main.dart';
import 'single_list_movie_card.dart';

class CardListMoviesGeneral extends StatelessWidget {
  final parentCubit;
  final double cardHeight;
  final bool isUpcomingCard;
  final double leftEdgePadding;

  const CardListMoviesGeneral({
    Key key,
    @required this.parentCubit,
    this.cardHeight = 173,
    this.isUpcomingCard = false,
    this.leftEdgePadding = 8,
  }) : super(key: key);

  Widget childSwitcher({
    @required BuildContext context,
  }) {
    // print("Here ${parentCubit.state}");
    if (parentCubit.listOfAllMoviesId.length == 0) {
      if (parentCubit.state is MoviesNowShowingLoading ||
          parentCubit.state is MoviesUpcomingLoading ||
          parentCubit.state is MoviesPopularLoading ||
          parentCubit.state is MoviesSimilarFetcherLoading) {
        return LoadingCardListMain(
          key: ValueKey(1),
          cardHeight: cardHeight,
          leftEdgePadding: leftEdgePadding,
          state: parentCubit.state,
          functionToExecute: parentCubit.reloadResult,
        );
      } else if (parentCubit.state is MoviesNowShowingFailed ||
          parentCubit.state is MoviesUpcomingFailed ||
          parentCubit.state is MoviesPopularFailed ||
          parentCubit.state is MoviesSimilarFetcherFailed) {
        return NetworkErrorCardListMain(
          key: ValueKey(2),
          cardHeight: cardHeight,
          leftEdgeInsets: leftEdgePadding,
          functionToExecute: parentCubit.reloadResult,
        );
      } else {
        return NoElementsCardListMain(
          key: ValueKey(4),
          cardHeight: cardHeight,
          leftEdgePadding: leftEdgePadding,
        );
      }
    } else {
      return Container(
        key: ValueKey(3),
        height: cardHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount: parentCubit.listOfAllMoviesId.length > 15
              ? 15
              : parentCubit.listOfAllMoviesId.length,
          itemBuilder: (context, index) {
            MovieModel _currentMovieModel = MovieBucket()
                .getInfo(parentCubit.listOfAllMoviesId.elementAt(index));

            if (index == 0) {
              return SingleListMovieCard(
                cardWidth: cardHeight * 2 / 3,
                currentMovieModel: _currentMovieModel,
                isUpcomingCard: isUpcomingCard,
                isFirst: true,
                leftEdgeInsets: leftEdgePadding,
              );
            }
            return SingleListMovieCard(
              cardWidth: cardHeight * 2 / 3,
              currentMovieModel: _currentMovieModel,
              isUpcomingCard: isUpcomingCard,
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      child: childSwitcher(context: context),
    );
  }
}
