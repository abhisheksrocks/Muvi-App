// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../cubit/movie_cast_fetcher_cubit.dart';
import 'single_list_cast_card.dart';

class CastGridViewBuilder extends StatelessWidget {
  const CastGridViewBuilder({
    Key? key,
    required this.state,
    required this.eachCardWidth,
  }) : super(key: key);

  final MovieCastFetcherLoaded state;
  final double eachCardWidth;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: state.listOfCasts.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent:
            eachCardWidth + 16 + 1, //ie. + padding + 1 extra for safety
        childAspectRatio: (eachCardWidth + 16) / (eachCardWidth * 3 / 2),
      ),
      itemBuilder: (context, index) => SingleListCastCard(
        cardHeight: eachCardWidth * 3 / 2,
        creditId: state.listOfCasts.elementAt(index),
      ),
    );
  }
}
