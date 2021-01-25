// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../../cubit/movie_similar_fetcher_cubit.dart';
import '../widgets/icon_maker.dart';
import '../widgets/view_all_movies_grid_with_status_widget.dart';

class ViewAllSimilarMoviesScreen extends StatefulWidget {
  const ViewAllSimilarMoviesScreen({
    Key key,
  }) : super(key: key);

  @override
  _ViewAllSimilarMoviesScreenState createState() =>
      _ViewAllSimilarMoviesScreenState();
}

class _ViewAllSimilarMoviesScreenState
    extends State<ViewAllSimilarMoviesScreen> {
  double eachCardWidth;
  ScrollController _scrollController;

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
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    var state = context.read<MoviesSimilarFetcherCubit>().state;
    _scrollController.addListener(() {
      // print(_scrollController.position.pixels);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        // print("loading more");
        context.read<MoviesSimilarFetcherCubit>().loadResults();
      }
    });
    disposeScrollController(state);
    super.initState();
  }

  void disposeScrollController(MoviesSimilarFetcherState state) {
    if (state is MoviesSimilarFetcherLoaded) {
      if (state.isAllLoaded) {
        // print('disposing _scrollController since list completely loaded');
        _scrollController.dispose();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("Rebuilt");
    return MultiBlocListener(
      listeners: [
        BlocListener<MoviesSimilarFetcherCubit, MoviesSimilarFetcherState>(
          listener: (context, state) {
            disposeScrollController(state);
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconMaker(
            icon: Icon(Icons.arrow_back),
            functionToPerform: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Similar Movies',
            style:
                Theme.of(context).textTheme.headline1.apply(fontSizeDelta: 4),
          ),
        ),
        body: Builder(
          builder: (context) {
            var cubit = context.watch<MoviesSimilarFetcherCubit>();
            return ViewAllMoviesGridWithStatusWidget(
              scrollController: _scrollController,
              cubit: cubit,
              eachCardWidth: eachCardWidth,
            );
          },
        ),
      ),
    );
  }
}
