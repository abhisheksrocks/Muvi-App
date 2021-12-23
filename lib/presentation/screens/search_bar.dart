import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../cubit/movies_search_cubit.dart';
import '../../models/movie_bucket.dart';
import '../core/app_style.dart';
import '../widgets/icon_maker.dart';
import '../widgets/loading_shimmer_placeholder.dart';
import '../widgets/network_error_overlay.dart';
import '../widgets/no_elements_movie_card.dart';
import '../widgets/no_elements_overlay.dart';
import '../widgets/single_list_movie_card.dart';

class SearchBar extends SearchDelegate<String> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        tooltip: 'Clear all text',
        icon: Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconMaker(
      semanticLabel: 'Back button',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      functionToPerform: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Builder(
      builder: (context) {
        var cubit = context.watch<MoviesSearchCubit>();

        cubit.searchForMovie(searchQuery: query);

        return SearchResults(cubit: cubit, searchQuery: query);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Builder(
      builder: (context) {
        var cubit = context.watch<MoviesSearchCubit>();

        cubit.searchForMovie(searchQuery: query);

        return SearchResults(cubit: cubit, searchQuery: query);
      },
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }
}

class SearchResults extends StatefulWidget {
  final MoviesSearchCubit cubit;
  final String searchQuery;
  const SearchResults({
    Key? key,
    required this.cubit,
    required this.searchQuery,
  }) : super(key: key);
  @override
  _SearchResultsState createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late double eachCardWidth;
  late ScrollController _scrollController;

  late double _maxCrossAxisExtent;
  late double _childAspectRatio;

  double findEachCardWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardHorizontalPadding = 16;
    double minCardWidth = 104;
    int maxCards = screenWidth ~/ (minCardWidth + cardHorizontalPadding);
    return (screenWidth / maxCards - cardHorizontalPadding).toInt().toDouble();
  }

  @override
  void didChangeDependencies() {
    eachCardWidth = findEachCardWidth(context);
    _maxCrossAxisExtent = eachCardWidth + 16 + 1;
    _childAspectRatio = (eachCardWidth + 16) / (eachCardWidth * 3 / 2);
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    var state = context.read<MoviesSearchCubit>().state;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        context.read<MoviesSearchCubit>().searchForMovie(
              searchQuery: widget.searchQuery,
              fromDrag: true,
            );
      }
    });
    disposeScrollController(state);
    super.initState();
  }

  void disposeScrollController(MoviesSearchState state) {
    if (state is MoviesSearchLoaded) {
      if (state.isAllLoaded) {
        _scrollController.dispose();
      }
    }
  }

  Widget childFinder(dynamic state) {
    if (state is MoviesSearchLoaded) {
      return Container(
        key: ValueKey(1),
        width: double.maxFinite,
      );
    } else if (state is MoviesSearchFailed) {
      return Container(
        key: ValueKey(2),
        width: double.maxFinite,
        height: 20,
        color: Colors.red,
        alignment: Alignment.center,
        child: const Text('Loading Failed!'),
      );
    } else if (state is MoviesSearchLoading) {
      return Container(
        key: ValueKey(3),
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(vertical: 2),
        color: Colors.green,
        alignment: Alignment.center,
        child: state.timeoutExhausted
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Taking longer than usual...'),
                  GestureDetector(
                    onTap: () {
                      widget.cubit.research();
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
    );
  }

  GridView buildGridViewBuilder({
    Widget widgetToShow = const NoElementsMovieCard(),
  }) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: _maxCrossAxisExtent,
        childAspectRatio: _childAspectRatio,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      itemBuilder: (context, index) {
        return widgetToShow;
      },
    );
  }

  Widget widgetFinder(BuildContext context) {
    if (widget.cubit.listOfAllMoviesId.length > 0) {
      return GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: _maxCrossAxisExtent,
          childAspectRatio: _childAspectRatio,
          mainAxisSpacing: 5,
        ),
        itemCount: widget.cubit.listOfAllMoviesId.length,
        itemBuilder: (context, index) {
          return SingleListMovieCard(
            cardWidth: eachCardWidth,
            currentMovieModel: MovieBucket().getInfo(
              widget.cubit.listOfAllMoviesId.elementAt(index),
            ),
          );
        },
      );
    } else {
      var state = widget.cubit.state;
      if (state is MoviesSearchLoading) {
        return Stack(
          children: [
            ShaderMask(
              shaderCallback: AppStyle().defaultPosterShader,
              child: Shimmer.fromColors(
                baseColor: Colors.white10,
                highlightColor: Theme.of(context).accentColor,
                child: buildGridViewBuilder(
                  widgetToShow: LoadingShimmerPlaceholder(),
                ),
              ),
            ),
            if (state.timeoutExhausted)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Taking Longer than usual...'),
                    TextButton(
                      onPressed: () {
                        widget.cubit.research();
                      },
                      style: TextButton.styleFrom(
                        primary: Colors.grey.withOpacity(0.2),
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
          ],
        );
      } else if (state is MoviesSearchFailed) {
        return Stack(
          children: [
            ShaderMask(
              shaderCallback: AppStyle().defaultPosterShader,
              child: buildGridViewBuilder(),
            ),
            Center(
              child: NetworkErrorOverlay(
                functionToExecute: widget.cubit.research,
              ),
            )
          ],
        );
      }
      return Stack(
        children: [
          ShaderMask(
            shaderCallback: AppStyle().defaultPosterShader,
            child: buildGridViewBuilder(),
          ),
          Center(
            child: NoElementsOverlay(),
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: widgetFinder(context),
          ),
        ),
        AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeOut,
          transitionBuilder: (child, animation) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 1),
                end: Offset(0, 0),
              ).animate(animation),
              child: child,
            );
          },
          child: childFinder(widget.cubit.state),
        ),
      ],
    );
  }
}
