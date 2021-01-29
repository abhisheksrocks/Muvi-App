// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../../cubit/movie_cast_fetcher_cubit.dart';
import '../../cubit/movie_certification_cubit.dart';
import '../../cubit/movie_reviews_fetcher_cubit.dart';
import '../../cubit/movie_runtime_cubit.dart';
import '../../cubit/movie_similar_fetcher_cubit.dart';
import '../../cubit/movie_videos_fetcher_cubit.dart';
import '../../models/movie_bucket.dart';
import '../../models/movie_model.dart';
import '../core/app_style.dart';
import '../widgets/card_list_cast_general.dart';
import '../widgets/card_list_movies_general.dart';
import '../widgets/card_list_video_general.dart';
import '../widgets/genre_text.dart';
import '../widgets/horizontal_divider_small.dart';
import '../widgets/icon_maker.dart';
import '../widgets/my_image_viewer.dart';
import '../widgets/rating_with_text.dart';
import '../widgets/release_date_text.dart';
import '../widgets/review_maker.dart';
import '../widgets/section_heading.dart';
import '../widgets/summary_review_text.dart';
import '../widgets/title_text.dart';
import '../widgets/view_all_button.dart';

class MovieInfoScreen extends StatelessWidget {
  final int movieId;
  MovieInfoScreen({
    Key key,
    @required this.movieId,
  })  : _currentMovieModel = MovieBucket().getInfo(movieId),
        super(key: key);

  final MovieModel _currentMovieModel;
  @override
  Widget build(BuildContext context) {
    // print(
    //     "MediaQuery.of(context).size.width * 1.5 : ${MediaQuery.of(context).size.width * 1.5}");
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              MovieCertificationCubit(movieId: _currentMovieModel.id),
        ),
        BlocProvider(
          create: (context) =>
              MovieRuntimeCubit(movieId: _currentMovieModel.id),
        ),
        BlocProvider(
          create: (context) =>
              MovieCastFetcherCubit(movieId: _currentMovieModel.id),
        ),
        BlocProvider(
          create: (context) =>
              MovieVideosFetcherCubit(movieId: _currentMovieModel.id),
        ),
        BlocProvider(
          create: (context) =>
              MovieReviewsFetcherCubit(movieId: _currentMovieModel.id),
        ),
        BlocProvider(
          create: (context) =>
              MoviesSimilarFetcherCubit(movieId: _currentMovieModel.id),
        ),
      ],
      child: Scaffold(
        body: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height >
                            MediaQuery.of(context).size.width
                        ? MediaQuery.of(context).size.width * 1.5
                        : MediaQuery.of(context).size.height / 2,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      fit: StackFit.expand,
                      children: [
                        Tooltip(
                          message: 'Movie Poster',
                          child: ShaderMask(
                            shaderCallback: AppStyle().defaultPosterShader,
                            child: MyImageViewer(
                              imagePath: _currentMovieModel.posterImagePath,
                              widgetWidth: MediaQuery.of(context).size.width,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BlocBuilder<MovieCertificationCubit,
                                      MovieCertificationState>(
                                    builder: (context, state) {
                                      if (state is MovieCertificationLoaded) {
                                        return Text(
                                          state.certificate,
                                          semanticsLabel: state.certificate ==
                                                  'N/A'
                                              ? "Couldn't find a valid rating or the movie hasn't been rated yet"
                                              : "This movie is rated - ${state.certificate}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        );
                                      } else if (state
                                          is MovieCertificationLoading) {
                                        return SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          "--",
                                          semanticsLabel:
                                              "Couldn't find a valid rating or the movie hasn't been rated yet",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        );
                                      }
                                    },
                                  ),
                                  HorizontalDividerSmall(),
                                  Expanded(
                                    child: GenreText(
                                      genreIds: _currentMovieModel.genreIds,
                                      textStyle:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: TitleText(
                                  title: _currentMovieModel.title,
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  BlocBuilder<MovieRuntimeCubit,
                                      MovieRuntimeState>(
                                    builder: (context, state) {
                                      if (state is MovieRuntimeLoaded) {
                                        return Text(
                                          "${state.minutesInString}", //TO-do
                                          semanticsLabel:
                                              "${state.semanticLabel}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        );
                                      } else if (state is MovieRuntimeLoading) {
                                        return SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        );
                                      } else {
                                        return Text(
                                          "--",
                                          semanticsLabel:
                                              "Couldn't fetch Movie runtime minutes",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                        );
                                      }
                                    },
                                  ),
                                  HorizontalDividerSmall(),
                                  ReleaseDateText(
                                    releaseDate: _currentMovieModel.releaseDate,
                                    textStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    dateFormat: 'dd MMM yyyy',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 9.0, bottom: 15, left: 18, right: 18),
                    child: SummaryReviewText(
                      textData: _currentMovieModel.summary,
                      textStyle: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    alignment: Alignment.topLeft,
                    child: RatingWithText(
                      avgRatingOutOfTen: _currentMovieModel.avgRatingOutOfTen,
                      totalRatingCount: _currentMovieModel.totalRatingCount,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 23, bottom: 12, left: 18, right: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SectionHeading(
                          text: 'Cast',
                          // alternate: true,
                        ),
                        BlocBuilder<MovieCastFetcherCubit,
                            MovieCastFetcherState>(
                          builder: (context, state) {
                            if (state is MovieCastFetcherLoaded) {
                              if (state.listOfCasts.length > 0) {
                                return ViewAllButton(
                                  functionToExecute: () {
                                    Navigator.pushNamed(
                                        context, '/view-all-casts',
                                        arguments: {
                                          'state': state,
                                        });
                                  },
                                );
                              }
                            }
                            return ViewAllButton();
                          },
                        )
                      ],
                    ),
                  ),
                  // BlocBuilder<MovieCastFetcherCubit, MovieCastFetcherState>(
                  //   builder: (context, state) {
                  Builder(
                    builder: (context) {
                      var cubit = context.watch<MovieCastFetcherCubit>();
                      // if (cubit.listOfAllMoviesId.isEmpty) {
                      //   if (cubit.state is MoviesUpcomingFailed) {
                      //     return Center(
                      //       child: Icon(Icons.warning),
                      //     );
                      //   }
                      //   // else
                      //   // if (cubit.state is MoviesUpcomingLoading) {
                      //   //   return CircularProgressIndicator();
                      //   // }
                      // }
                      // if (state is MovieCastFetcherFailed) {
                      //   return Center(
                      //     child: Icon(Icons.warning),
                      //   );
                      // } else if (state is MovieCastFetcherLoaded) {
                      //   return CircularProgressIndicator();
                      // }
                      return CardListCastGeneral(parentCubit: cubit);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 23, bottom: 12, left: 18, right: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SectionHeading(
                          text: 'Videos',
                          // alternate: true,
                        ),
                        BlocBuilder<MovieVideosFetcherCubit,
                            MovieVideosFetcherState>(
                          builder: (context, state) {
                            if (state is MovieVideosFetcherLoaded) {
                              if (state.listOfVideos.length > 0) {
                                return ViewAllButton(
                                  functionToExecute: () {
                                    Navigator.pushNamed(
                                        context, '/view-all-videos',
                                        arguments: {
                                          'state': state,
                                        });
                                  },
                                );
                              }
                            }
                            return ViewAllButton();
                          },
                        ),
                      ],
                    ),
                  ),
                  // BlocBuilder<MovieVideosFetcherCubit,
                  //     MovieVideosFetcherState>(
                  //   builder: (context, state) {
                  Builder(
                    builder: (context) {
                      var cubit = context.watch<MovieVideosFetcherCubit>();
                      return CardListVideoGeneral(parentCubit: cubit);
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 23, bottom: 12, left: 18, right: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SectionHeading(
                          text: 'Review',
                          // alternate: true,
                        ),
                        BlocBuilder<MovieReviewsFetcherCubit,
                            MovieReviewsFetcherState>(
                          builder: (context, state) {
                            if (state is MovieReviewsFetcherLoaded) {
                              if (state.listOfReviews.length > 0) {
                                return ViewAllButton(
                                  functionToExecute: () {
                                    Navigator.pushNamed(
                                        context, '/view-all-reviews',
                                        arguments: {
                                          'state': state,
                                        });
                                  },
                                );
                              }
                            }
                            return ViewAllButton();
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child:
                        // BlocBuilder<MovieReviewsFetcherCubit,
                        //     MovieReviewsFetcherState>(
                        //   builder: (context, state) {
                        Builder(
                      builder: (context) {
                        var cubit = context.watch<MovieReviewsFetcherCubit>();

                        return ReviewMaker(parentCubit: cubit);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 23, bottom: 12, left: 18, right: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SectionHeading(
                          text: 'Similar Movies',
                          // alternate: true,
                        ),
                        // BlocBuilder<MoviesSimilarFetcherCubit,
                        //     MoviesSimilarFetcherState>(
                        //   builder: (context, state) {
                        Builder(
                          builder: (context) {
                            var cubit =
                                context.watch<MoviesSimilarFetcherCubit>();
                            if (cubit.state is MoviesSimilarFetcherLoaded) {
                              if (cubit.listOfAllMoviesId.length > 0) {
                                return ViewAllButton(
                                  functionToExecute: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/view-all-similar-movies',
                                      arguments: {
                                        'context': context,
                                      },
                                    );
                                  },
                                );
                              }
                            }
                            return ViewAllButton();
                          },
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    // child: BlocBuilder<MoviesSimilarFetcherCubit,
                    //     MoviesSimilarFetcherState>(
                    // builder: (context, state) {
                    child: Builder(
                      builder: (context) {
                        var cubit = context.watch<MoviesSimilarFetcherCubit>();
                        // if (cubit.state is MoviesSimilarFetcherFailed) {
                        //   return Center(
                        //     child: Icon(Icons.warning),
                        //   );
                        // } else if (cubit.state
                        //     is MoviesSimilarFetcherLoaded) {
                        // }
                        return CardListMoviesGeneral(
                          parentCubit: cubit,
                          leftEdgePadding: 18,
                        );
                        // if (cubit.listOfAllMoviesId.isEmpty) {
                        //   if (cubit.state is MoviesSimilarFetcherFailed) {
                        //     return Center(
                        //       child: Icon(Icons.warning),
                        //     );
                        //   }
                        //   // else
                        //   // if (cubit.state is MoviesUpcomingLoading) {
                        //   //   return CircularProgressIndicator();
                        //   // }
                        // }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
            SizedBox(
              height: 120,
              width: 55,
              child: IconMaker(
                semanticLabel: 'back button',
                icon: Icon(Icons.arrow_back),
                functionToPerform: () {
                  Navigator.of(context).pop();
                },
                inverted: true,
                alternateApproach: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
