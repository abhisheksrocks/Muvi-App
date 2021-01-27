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
            centerTitle: true,
            title: SvgPicture.asset(
              'assets/images/logo.svg',
              height: 38,
            ),
            leading: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 24,
                ),
                onPressed: () {
                  context.read<AnimatedDrawerCubit>().changeCollapse();
                },
              ),
            ),
            actions: [
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
                      print(
                          "Screen Height: ${MediaQuery.of(context).size.height}");
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
                    var cubit = context.watch<MoviesPopularCubit>();

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

                    return CardListMoviesGeneral(
                      parentCubit: cubit,
                    );
                  },
                ),
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
