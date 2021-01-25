// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

// 🌎 Project imports:
import '../../cubit/animated_drawer_cubit.dart';
import '../../cubit/carousel_page_controller_cubit.dart';
import '../../cubit/movies_now_showing_cubit.dart';
import '../../cubit/movies_popular_cubit.dart';
import '../../cubit/movies_upcoming_cubit.dart';
import '../widgets/card_list_movies_carousel.dart';
import '../widgets/card_list_movies_general.dart';
import '../widgets/section_heading.dart';
import '../widgets/view_all_button.dart';
import 'search_bar.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: CustomScrollView(
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
              // builder: (context) => IconMaker(
              //   icon: Icon(
              //     Icons.menu,
              //     size: 24,
              //     // color: Theme.of(context).accentColor,
              //   ),
              //   functionToPerform: () {
              //     // Scaffold.of(context).openDrawer();
              //     context.read<AnimatedDrawerCubit>().changeCollapse();
              //   },
              // ),
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 24,
                ),
                onPressed: () {
                  // print("Clicked");
                  context.read<AnimatedDrawerCubit>().changeCollapse();
                },
              ),
            ),
            actions: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 9.0),
              //   child: IconMaker(
              //     icon: Icon(
              //       Icons.search,
              //       size: 24,
              //     ),
              //     functionToPerform: () {
              //       showSearch(
              //         context: context,
              //         delegate: SearchBar(),
              //       );
              //     },
              //   ),
              // ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  size: 24,
                ),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: SearchBar(),
                  );
                },
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
                // Container(
                //   padding: EdgeInsets.symmetric(
                //     vertical: 20,
                //   ),
                //   child: Text(
                //     'END OF PAGE',
                //     style: Theme.of(context).textTheme.bodyText1,
                //   ),
                // ),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'END OF PAGE',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
