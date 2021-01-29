// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../../cubit/movies_upcoming_cubit.dart';
import '../widgets/icon_maker.dart';
import '../widgets/view_all_movies_grid_with_status_widget.dart';

class ViewAllUpcomingScreen extends StatefulWidget {
  const ViewAllUpcomingScreen({
    Key key,
  }) : super(key: key);

  @override
  _ViewAllUpcomingScreenState createState() => _ViewAllUpcomingScreenState();
}

class _ViewAllUpcomingScreenState extends State<ViewAllUpcomingScreen> {
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
    var state = context.read<MoviesUpcomingCubit>().state;
    _scrollController.addListener(() {
      // print(_scrollController.position.pixels);
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent) {
        // print("loading more");
        context.read<MoviesUpcomingCubit>().loadResults();
      }
    });
    disposeScrollController(state);
    super.initState();
  }

  void disposeScrollController(MoviesUpcomingState state) {
    if (state is MoviesUpcomingLoaded) {
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
        BlocListener<MoviesUpcomingCubit, MoviesUpcomingState>(
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
            'Coming Soon',
            style:
                Theme.of(context).textTheme.headline1.apply(fontSizeDelta: 4),
          ),
        ),
        body: Builder(
          builder: (context) {
            var cubit = context.watch<MoviesUpcomingCubit>();
            return ViewAllMoviesGridWithStatusWidget(
              scrollController: _scrollController,
              cubit: cubit,
              eachCardWidth: eachCardWidth,
              isUpcomingCard: true,
            );
          },
        ),
      ),
    );
  }
}
