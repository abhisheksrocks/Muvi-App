// 🎯 Dart imports:
import 'dart:math';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../../cubit/carousel_page_controller_cubit.dart';
import '../../cubit/movie_similar_fetcher_cubit.dart';
import '../../cubit/movies_now_showing_cubit.dart';
import '../../cubit/movies_popular_cubit.dart';
import '../../cubit/movies_upcoming_cubit.dart';
import '../../models/movie_bucket.dart';
import '../../models/movie_model.dart';
import '../core/app_style.dart';
import 'loading_shimmer_placeholder.dart';
import 'loading_timeout_overlay.dart';
import 'network_error_movie_card.dart';
import 'network_error_overlay.dart';
import 'no_elements_overlay.dart';
import 'single_carousel_movie_card.dart';

class CardListMoviesCarousel extends StatefulWidget {
  final parentCubit;
  final double totalHeight;

  const CardListMoviesCarousel({
    Key? key,
    required this.parentCubit,
    this.totalHeight = 350,
  }) : super(key: key);
  @override
  _CardListMoviesCarouselState createState() => _CardListMoviesCarouselState();
}

class _CardListMoviesCarouselState extends State<CardListMoviesCarousel> {
  PageController _controller = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    // print("Screen width: $width");
    // print("Screen height: $height");
    context
        .read<CarouselPageControllerCubit>()
        .setViewportFraction(1 / (width / 180));
    _controller.dispose();
    _controller = PageController(
      initialPage:
          context.read<CarouselPageControllerCubit>().state.currentPage.toInt(),
      viewportFraction:
          context.read<CarouselPageControllerCubit>().state.viewportFraction,
    );
    _controller.addListener(() {
      // print("current page: ${_controller.page}");
      context.read<CarouselPageControllerCubit>().setPage(_controller.page!);
    });
    super.didChangeDependencies();
  }

  PageView buildPageViewBuilder({
    required Widget widgetToShow,
  }) {
    return PageView.builder(
      controller: _controller,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return BlocBuilder<CarouselPageControllerCubit,
            CarouselPageControllerState>(
          builder: (context, state) {
            double difference = index - state.currentPage;
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..setEntry(
                    3,
                    0,
                    -0.004 *
                        (difference > 0.5
                            ? 0.5
                            : difference < -0.5
                                ? -0.5
                                : difference))
                ..setEntry(
                    3,
                    3,
                    1 /
                        ((0.4 * cos(difference) + 0.7) < 0.8
                            ? 0.8
                            : (0.4 * cos(difference) + 0.7))),
              alignment: FractionalOffset.center,
              child: widgetToShow,
            );
          },
        );
      },
    );
  }

  Widget childSwitcher() {
    // print('rebuilt');
    // print("Current state: ${widget.parentCubit.state}");
    if (widget.parentCubit.listOfAllMoviesId.length == 0) {
      if (widget.parentCubit.state is MoviesNowShowingLoading ||
          widget.parentCubit.state is MoviesUpcomingLoading ||
          widget.parentCubit.state is MoviesPopularLoading ||
          widget.parentCubit.state is MoviesSimilarFetcherLoading) {
        var state = widget.parentCubit.state;

        return Container(
          key: ValueKey(1),
          height: widget.totalHeight,
          width: double.maxFinite,
          child: Stack(
            alignment: Alignment.center,
            children: [
              buildPageViewBuilder(
                widgetToShow: Center(
                  child: LoadingShimmerPlaceholder(
                    baseColor: Theme.of(context).accentColor.withOpacity(0.2),
                    highlightColor: Theme.of(context).accentColor,
                  ),
                ),
              ),
              // PageView.builder(
              //   controller: _controller,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     return BlocBuilder<CarouselPageControllerCubit,
              //         CarouselPageControllerState>(
              //       builder: (context, state) {
              //         double difference = index - state.currentPage;
              //         return Transform(
              //           transform: Matrix4.identity()
              //             ..setEntry(3, 2, 0.001)
              //             ..setEntry(
              //                 3,
              //                 0,
              //                 -0.004 *
              //                     (difference > 0.5
              //                         ? 0.5
              //                         : difference < -0.5
              //                             ? -0.5
              //                             : difference))
              //             ..setEntry(
              //                 3,
              //                 3,
              //                 1 /
              //                     ((0.4 * cos(difference) + 0.7) < 0.8
              //                         ? 0.8
              //                         : (0.4 * cos(difference) + 0.7))),
              //           alignment: FractionalOffset.center,
              //           child: Center(
              //             child: LoadingShimmerPlaceholder(
              //               baseColor:
              //                   Theme.of(context).accentColor.withOpacity(0.2),
              //               highlightColor: Theme.of(context).accentColor,
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),
              if (state.timeoutExhausted)
                LoadingTimeoutOverlay(
                    functionToExecute: widget.parentCubit.reloadResult),
            ],
          ),
        );
      } else if (widget.parentCubit.state is MoviesNowShowingFailed ||
          widget.parentCubit.state is MoviesUpcomingFailed ||
          widget.parentCubit.state is MoviesPopularFailed ||
          widget.parentCubit.state is MoviesSimilarFetcherFailed) {
        return Container(
          key: ValueKey(3),
          height: widget.totalHeight,
          width: double.maxFinite,
          child: Stack(
            children: [
              buildPageViewBuilder(
                widgetToShow: Center(
                  child: NetworkErrorMovieCard(),
                ),
              ),
              // PageView.builder(
              //   controller: _controller,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     return BlocBuilder<CarouselPageControllerCubit,
              //         CarouselPageControllerState>(
              //       builder: (context, state) {
              //         double difference = index - state.currentPage;
              //         return Transform(
              //           transform: Matrix4.identity()
              //             ..setEntry(3, 2, 0.001)
              //             ..setEntry(
              //                 3,
              //                 0,
              //                 -0.004 *
              //                     (difference > 0.5
              //                         ? 0.5
              //                         : difference < -0.5
              //                             ? -0.5
              //                             : difference))
              //             ..setEntry(
              //                 3,
              //                 3,
              //                 1 /
              //                     ((0.4 * cos(difference) + 0.7) < 0.8
              //                         ? 0.8
              //                         : (0.4 * cos(difference) + 0.7))),
              //           alignment: FractionalOffset.center,
              //           child: Center(
              //             child: NetworkErrorMovieCard(),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),
              NetworkErrorOverlay(
                functionToExecute: widget.parentCubit.reloadResult,
              ),
            ],
          ),
        );
      } else {
        return Container(
          key: ValueKey(4),
          height: widget.totalHeight,
          width: double.maxFinite,
          child: Stack(
            children: [
              buildPageViewBuilder(
                widgetToShow: Center(
                  child: ShaderMask(
                    shaderCallback: AppStyle().defaultPosterShader,
                    child: NetworkErrorMovieCard(),
                  ),
                ),
              ),
              // PageView.builder(
              //   controller: _controller,
              //   physics: NeverScrollableScrollPhysics(),
              //   itemBuilder: (context, index) {
              //     return BlocBuilder<CarouselPageControllerCubit,
              //         CarouselPageControllerState>(
              //       builder: (context, state) {
              //         double difference = index - state.currentPage;
              //         return Transform(
              //           transform: Matrix4.identity()
              //             ..setEntry(3, 2, 0.001)
              //             ..setEntry(
              //                 3,
              //                 0,
              //                 -0.004 *
              //                     (difference > 0.5
              //                         ? 0.5
              //                         : difference < -0.5
              //                             ? -0.5
              //                             : difference))
              //             // -0.004 * difference.clamp(-0.5, 0.5))
              //             ..setEntry(
              //                 3,
              //                 3,
              //                 1 /
              //                     ((0.4 * cos(difference) + 0.7) < 0.8
              //                         ? 0.8
              //                         : (0.4 * cos(difference) + 0.7))),
              //           // 1 /
              //           //     ((0.4 * cos(difference) + 0.8)
              //           //         .clamp(0.8, 0.81))),
              //           alignment: FractionalOffset.center,
              //           child: Center(
              //             child: ShaderMask(
              //               shaderCallback: AppStyle().defaultPosterShader,
              //               child: NetworkErrorMovieCard(),
              //             ),
              //           ),
              //         );
              //       },
              //     );
              //   },
              // ),
              NoElementsOverlay(),
            ],
          ),
        );
      }
    } else
      return Container(
        key: ValueKey(2),
        height: widget.totalHeight,
        width: double.maxFinite,
        child: PageView.builder(
          clipBehavior: Clip.none,
          physics: BouncingScrollPhysics(),
          // physics: NeverScrollableScrollPhysics(),
          // itemCount: widget.parentCubit.listOfAllMoviesId.length,
          controller: _controller,

          itemBuilder: (context, index) {
            return BlocBuilder<CarouselPageControllerCubit,
                CarouselPageControllerState>(
              builder: (context, state) {
                double difference = index - state.currentPage;
                MovieModel _currentMovieModel = MovieBucket().getInfo(
                  widget.parentCubit.listOfAllMoviesId.elementAt(
                    index %
                        (widget.parentCubit.listOfAllMoviesId.length > 15
                            ? 15
                            : widget.parentCubit.listOfAllMoviesId
                                .length), //Newly added
                  ),
                );
                // print("Difference: $difference");
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..setEntry(
                        3,
                        0,
                        // -0.004 *
                        //     (difference > 0.5
                        //         ? 0.5
                        //         : difference < -0.5
                        //             ? -0.5
                        //             : difference))
                        -0.004 * (difference).clamp(-0.5, 0.5))
                    ..setEntry(
                        3,
                        3,
                        // 1 /
                        //     ((0.4 * cos(difference) + 0.7) < 0.7
                        //         ? 0.7
                        //         : (0.4 * cos(difference) + 0.7))),
                        1 / ((0.4 * cos(difference) + 0.7).clamp(0.7, 1.1))),
                  alignment: FractionalOffset.center,
                  child: SingleCarouselMovieCard(
                    currentMovieModel: _currentMovieModel,
                    cardHeight: widget.totalHeight,
                    difference: difference,
                  ),
                );
              },
            );
          },
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      // transitionBuilder: (child, animation) {
      //   return FadeTransition(
      //     opacity: animation,
      //     child: child,
      //   );
      // },
      child: childSwitcher(),
    );
  }
}
