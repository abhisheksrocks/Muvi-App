// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../../cubit/movie_similar_fetcher_cubit.dart';
import '../screens/about_screen.dart';
import '../screens/home_and_drawer_container.dart';
import '../screens/movie_info_screen.dart';
import '../screens/page_not_found.dart';
import '../screens/view_all_casts_screen.dart';
import '../screens/view_all_now_showing_screen.dart';
import '../screens/view_all_popular_screen.dart';
import '../screens/view_all_reviews_screen.dart';
import '../screens/view_all_similar_movies_screen.dart';
import '../screens/view_all_upcoming_screen.dart';
import '../screens/view_all_videos_screen.dart';

class AppRouter {
  Route call(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: Tween<double>(begin: 0.3, end: 1).animate(animation),
            child: HomeAndDrawerContainer(),
          ),
        );

      case '/about':
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: Tween<double>(begin: 0.3, end: 1).animate(animation),
            child: AboutScreen(),
          ),
        );

      case '/movie-info':
        final arguments = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => MovieInfoScreen(
            movieId: arguments['movieId'],
          ),
        );

      case '/view-all-now-showing-movies':
        // final arguments = routeSettings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: Tween<double>(begin: 0.3, end: 1).animate(animation),
            child: ViewAllNowShowingScreen(
                // parentCubit: arguments['parentCubit'],
                ),
          ),
        );

      case '/view-all-popular-movies':
        // final arguments = routeSettings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: Tween<double>(begin: 0.3, end: 1).animate(animation),
            child: ViewAllPopularScreen(
                // parentCubit: arguments['parentCubit'],
                ),
          ),
        );

      case '/view-all-upcoming-movies':
        // final arguments = routeSettings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: Tween<double>(begin: 0.3, end: 1).animate(animation),
            child: ViewAllUpcomingScreen(
                // parentCubit: arguments['parentCubit'],
                ),
          ),
        );

      case '/view-all-similar-movies':
        final arguments = routeSettings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              BlocProvider.value(
            value: (arguments['context'] as BuildContext)
                .read<MoviesSimilarFetcherCubit>(),
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.3, end: 1).animate(animation),
              child: ViewAllSimilarMoviesScreen(
                  // parentCubit: arguments['parentCubit'],
                  ),
            ),
          ),
        );

      case '/view-all-casts':
        final arguments = routeSettings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: Tween<double>(begin: 0.3, end: 1).animate(animation),
            child: ViewAllCastsScreen(
              state: arguments['state'],
            ),
          ),
        );

      case '/view-all-videos':
        final arguments = routeSettings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: Tween<double>(begin: 0.3, end: 1).animate(animation),
            child: ViewAllVideosScreen(
              state: arguments['state'],
            ),
          ),
        );

      case '/view-all-reviews':
        final arguments = routeSettings.arguments as Map<String, dynamic>;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              FadeTransition(
            opacity: Tween<double>(begin: 0.3, end: 1).animate(animation),
            child: ViewAllReviewsScreen(
              state: arguments['state'],
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => PageNotFound(),
        );
    }
  }
}
