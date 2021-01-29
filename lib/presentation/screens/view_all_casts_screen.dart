// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../cubit/movie_cast_fetcher_cubit.dart';
import '../widgets/cast_grid_view_builder.dart';
import '../widgets/icon_maker.dart';

class ViewAllCastsScreen extends StatefulWidget {
  final MovieCastFetcherLoaded state;

  const ViewAllCastsScreen({
    Key key,
    @required this.state,
  }) : super(key: key);

  @override
  _ViewAllCastsScreenState createState() => _ViewAllCastsScreenState();
}

class _ViewAllCastsScreenState extends State<ViewAllCastsScreen> {
  double eachCardWidth;

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconMaker(
          semanticLabel: 'back button',
          icon: Icon(Icons.arrow_back),
          functionToPerform: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Cast',
          style: Theme.of(context).textTheme.headline1.apply(fontSizeDelta: 4),
        ),
      ),
      body: CastGridViewBuilder(
        state: widget.state,
        eachCardWidth: eachCardWidth,
      ),
    );
  }
}
