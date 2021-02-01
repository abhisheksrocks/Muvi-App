// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 🌎 Project imports:
import '../../../lib/cubit/carousel_page_controller_cubit.dart';
import '../../../lib/cubit/movies_now_showing_cubit.dart';
import '../../../lib/cubit/movies_popular_cubit.dart';
import '../../../lib/cubit/movies_upcoming_cubit.dart';
import '../../../lib/presentation/core/app_style.dart';
import '../../../lib/presentation/widgets/card_list_movies_carousel.dart';
import '../../../lib/presentation/widgets/card_list_movies_general.dart';
import '../../../lib/presentation/widgets/icon_maker.dart';
import '../../../lib/presentation/widgets/section_heading.dart';
import '../../../lib/presentation/widgets/view_all_button.dart';
import '../../../lib/presentation/screens/search_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.black54),
        child: Drawer(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  gradient: AppStyle().defaultLinearGradient(opacity: 0.7),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo_white.svg',
                      height: 40,
                    ),
                    Text(
                      'v0.0.1',
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(color: Colors.black),
                    ),
                    // Text(
                    //   "\nPowered by TMDb",
                    //   style: Theme.of(context).textTheme.bodyText1,
                    // ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {},
                child: ListTile(
                  title: Text(
                    'Change Region',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, '/about');
                },
                child: ListTile(
                  title: Text(
                    'About',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            // backgroundColor: Colors.white10,
            centerTitle: true,
            title: SvgPicture.asset(
              'assets/images/logo.svg',
              height: 38,
            ),
            // flexibleSpace: Container(
            //   decoration: BoxDecoration(
            //     gradient: LinearGradient(
            //       begin: Alignment.topCenter,
            //       end: Alignment.bottomCenter,
            //       colors: <Color>[
            //         Colors.grey.withOpacity(0.5),
            //         Colors.black,
            //       ],
            //     ),
            //   ),
            // ),
            leading: Builder(
              builder: (context) => IconMaker(
                semanticLabel: 'Open Side Drawer',
                icon: Icon(
                  Icons.menu,
                  size: 24,
                  // color: Theme.of(context).accentColor,
                ),
                functionToPerform: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 9.0),
                child: IconMaker(
                  semanticLabel: 'search button',
                  icon: Icon(
                    Icons.search,
                    size: 24,
                  ),
                  functionToPerform: () {
                    // print("Tapping");
                    showSearch(
                      context: context,
                      delegate: SearchBar(),
                    );
                  },
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9.0,
                    vertical: 6.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionHeading(text: 'Now Showing'),
                      // BlocBuilder<MoviesNowShowingCubit, MoviesNowShowingState>(
                      // builder: (context, state) {
                      // if (state is MoviesNowShowingLoaded) {
                      Builder(
                        builder: (context) {
                          if (context
                                  .watch<MoviesNowShowingCubit>()
                                  .listOfAllMoviesId
                                  .length >
                              0) {
                            return ViewAllButton(
                              functionToExecute: () {
                                Navigator.pushNamed(
                                  context,
                                  '/view-all-now-showing-movies',
                                );
                              },
                            );
                          }
                          // }
                          return ViewAllButton(
                            functionToExecute: null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                BlocProvider(
                  create: (context) => CarouselPageControllerCubit(),
                  child: Builder(
                    builder: (context) {
                      var cubit = context.watch<MoviesNowShowingCubit>();
                      return CardListMoviesCarousel(
                        totalHeight: 350,
                        parentCubit: cubit,
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 9,
                    right: 9,
                    bottom: 11,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionHeading(
                        text: 'Trending Now',
                      ),
                      Builder(
                        builder: (context) {
                          if (context
                                  .watch<MoviesPopularCubit>()
                                  .listOfAllMoviesId
                                  .length >
                              0) {
                            return ViewAllButton(
                              functionToExecute: () {
                                Navigator.pushNamed(
                                  context,
                                  '/view-all-popular-movies',
                                );
                              },
                            );
                          }
                          // }
                          return ViewAllButton(
                            functionToExecute: null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // BlocBuilder<MoviesPopularCubit, MoviesPopularState>(
                Builder(
                  builder: (context) {
                    var cubit = context.watch<MoviesPopularCubit>();
                    // if (cubit.listOfAllMoviesId.isEmpty) {
                    //   if (cubit.state is MoviesPopularFailed) {
                    //     return Center(
                    //       child: Icon(Icons.warning),
                    //     );
                    //   }
                    //   // else
                    //   // if (cubit.state is MoviesPopularLoading) {
                    //   //   return CircularProgressIndicator();
                    //   // }
                    // }
                    return CardListMoviesGeneral(
                      parentCubit: cubit,
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 9,
                    right: 9,
                    top: 15,
                    bottom: 11,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SectionHeading(text: 'Coming Soon'),
                      Builder(
                        builder: (context) {
                          if (context
                                  .watch<MoviesUpcomingCubit>()
                                  .listOfAllMoviesId
                                  .length >
                              0) {
                            return ViewAllButton(
                              functionToExecute: () {
                                Navigator.pushNamed(
                                  context,
                                  '/view-all-upcoming-movies',
                                );
                              },
                            );
                          }
                          // }
                          return ViewAllButton(
                            functionToExecute: null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Builder(
                  builder: (context) {
                    var cubit = context.watch<MoviesUpcomingCubit>();
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
                    return CardListMoviesGeneral(
                      parentCubit: cubit,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
