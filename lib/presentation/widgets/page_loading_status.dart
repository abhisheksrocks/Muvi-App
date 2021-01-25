// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../cubit/movie_similar_fetcher_cubit.dart';
import '../../cubit/movies_now_showing_cubit.dart';
import '../../cubit/movies_popular_cubit.dart';
import '../../cubit/movies_upcoming_cubit.dart';

class PageLoadingStatus extends StatelessWidget {
  const PageLoadingStatus({
    Key key,
    @required this.cubit,
  }) : super(key: key);

  final dynamic cubit;

  Widget childFinder(dynamic cubit) {
    var state = cubit.state;
    if (state is MoviesNowShowingLoaded ||
        state is MoviesPopularLoaded ||
        state is MoviesUpcomingLoaded ||
        state is MoviesSimilarFetcherLoaded) {
      // if (state.allLoaded) {
      //   print("All Loaded");
      //   return Container(
      //     key: ValueKey(4),
      //     width: double.maxFinite,
      //     height: 20,
      //     color: Colors.blue,
      //     alignment: Alignment.center,
      //     child: Text('Loading Failed!'),
      //   );
      // }
      return Container(
        key: ValueKey(1),
        width: double.maxFinite,
      );
    } else if (state is MoviesNowShowingFailed ||
        state is MoviesPopularFailed ||
        state is MoviesUpcomingFailed ||
        state is MoviesSimilarFetcherFailed) {
      return Container(
        key: ValueKey(2),
        width: double.maxFinite,
        height: 20,
        color: Colors.red,
        alignment: Alignment.center,
        child: const Text('Loading Failed!'),
      );
    } else if (state is MoviesNowShowingLoading ||
        state is MoviesPopularLoading ||
        state is MoviesUpcomingLoading ||
        state is MoviesSimilarFetcherLoading) {
      return Container(
        key: ValueKey(3),
        width: double.maxFinite,
        height: 20,
        color: Colors.green,
        alignment: Alignment.center,
        child: state.timeoutExhausted
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Taking longer than usual...'),
                  GestureDetector(
                    onTap: () {
                      cubit.reloadResult();
                    },
                    child: Text(
                      'Retry?',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
            : const Text('Loading...'),
      );
    }
    return Container(
        key: ValueKey(5),
        width: double.maxFinite,
        height: 20,
        color: Colors.red,
        alignment: Alignment.center,
        child: const Text('SOME ERROR OCCURED'));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 500),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeOut,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0))
              .animate(animation),
          child: child,
        );
      },
      child: childFinder(cubit),
    );
  }
}
