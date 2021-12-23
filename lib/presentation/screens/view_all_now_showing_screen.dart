// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../../cubit/movies_now_showing_cubit.dart';
import '../widgets/icon_maker.dart';
import '../widgets/view_all_movies_grid_with_status_widget.dart';

class ViewAllNowShowingScreen extends StatefulWidget {
  const ViewAllNowShowingScreen({
    Key? key,
  }) : super(key: key);

  @override
  _ViewAllNowShowingScreenState createState() =>
      _ViewAllNowShowingScreenState();
}

class _ViewAllNowShowingScreenState extends State<ViewAllNowShowingScreen> {
  late double eachCardWidth;
  late ScrollController _scrollController;

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
    var state = context.read<MoviesNowShowingCubit>().state;
    _scrollController.addListener(() {
      // print(_scrollController.position.pixels);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        // print("loading more");
        context.read<MoviesNowShowingCubit>().loadResults();
      }
    });
    disposeScrollController(state);
    super.initState();
  }

  void disposeScrollController(MoviesNowShowingState state) {
    if (state is MoviesNowShowingLoaded) {
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
        BlocListener<MoviesNowShowingCubit, MoviesNowShowingState>(
          listener: (context, state) {
            disposeScrollController(state);
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: IconMaker(
            semanticLabel: 'back button',
            icon: Icon(Icons.arrow_back),
            functionToPerform: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            'Now Showing',
            style:
                Theme.of(context).textTheme.headline1!.apply(fontSizeDelta: 4),
          ),
        ),
        body: Builder(
          builder: (context) {
            var cubit = context.watch<MoviesNowShowingCubit>();
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
