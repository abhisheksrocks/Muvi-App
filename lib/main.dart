// import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import 'package:muvi/cubit/animated_drawer_cubit.dart';
import 'package:muvi/cubit/genre_fetcher_cubit.dart';
import 'package:muvi/cubit/movies_now_showing_cubit.dart';
import 'package:muvi/cubit/movies_popular_cubit.dart';
import 'package:muvi/cubit/movies_search_cubit.dart';
import 'package:muvi/cubit/movies_upcoming_cubit.dart';
import 'package:muvi/presentation/core/app_router.dart';
import 'package:muvi/presentation/core/app_theme.dart';

import 'debug/app_bloc_observer.dart';

// import 'package:http/http.dart';

//TODO: Code Cleanup - jaise kahin tune widgets me width manga hai aur kahin height, make it consistent
//TODO: Jo baar baar reuse ho rhe hain widgets usko ek single file ya widget me banana
//TODO: Grid View Builder main rows ke beech me gap
// * Hero (Not getting required result for Carousel, so discarding :(, maybe will try experimenting with ListView instead )
// ! Found that it wont be possible with Since ListView doesn't automatically fixes its position
// ! if the user left it in middle of two list items
//TODO: About Page
//TODO: Settings Page(For later)
//TODO: Animated Logo for loading screen (Later, TBH Nothing to load initially)
void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIOverlays([]);

// SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
// var result = await get(
//     "https://api.themoviedb.org/3/movie/now_playing?api_key=e855e99d5f525d038de3b91dfff1c127&language=en-US&page=1");
// Map<String, dynamic> result1 = json.decode(result.body);
// print(result1['results']);
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(), // Wrap your app
  //   ),
  // );
  Bloc.observer = AppBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AnimatedDrawerCubit>(
          create: (context) => AnimatedDrawerCubit(),
        ),
        BlocProvider<GenreFetcherCubit>(
          create: (context) => GenreFetcherCubit(),
          lazy: false,
        ),
        BlocProvider<MoviesNowShowingCubit>(
          create: (context) => MoviesNowShowingCubit(
            genreFetcherCubit: context.read<GenreFetcherCubit>(),
          ),
        ),
        BlocProvider<MoviesPopularCubit>(
          create: (context) => MoviesPopularCubit(
            genreFetcherCubit: context.read<GenreFetcherCubit>(),
          ),
        ),
        BlocProvider<MoviesUpcomingCubit>(
          create: (context) => MoviesUpcomingCubit(
            genreFetcherCubit: context.read<GenreFetcherCubit>(),
          ),
        ),
        BlocProvider<MoviesSearchCubit>(
          create: (context) => MoviesSearchCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Muvi - All About Movies!',
        theme: AppTheme()(),
        onGenerateRoute: AppRouter(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
