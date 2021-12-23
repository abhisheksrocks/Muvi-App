// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../cubit/movie_cast_fetcher_cubit.dart';
import 'loading_card_list_main.dart';
import 'network_error_card_list_main.dart';
import 'no_elements_card_list_main.dart';
import 'single_list_cast_card.dart';

class CardListCastGeneral extends StatelessWidget {
  final MovieCastFetcherCubit parentCubit;
  final double cardHeight;
  final double leftEdgeInsets;

  const CardListCastGeneral({
    Key? key,
    required this.parentCubit,
    this.cardHeight = 160,
    this.leftEdgeInsets = 18,
  }) : super(key: key);

  Widget childSwitcher({
    required BuildContext context,
  }) {
    var state = parentCubit.state;
    if (state is MovieCastFetcherLoading) {
      return LoadingCardListMain(
        key: ValueKey(1),
        cardHeight: cardHeight,
        leftEdgePadding: leftEdgeInsets,
        state: state,
        functionToExecute: parentCubit.research,
      );
    } else if (state is MovieCastFetcherLoaded) {
      if (state.listOfCasts.length == 0) {
        return NoElementsCardListMain(
          key: ValueKey(4),
          cardHeight: cardHeight,
          leftEdgePadding: leftEdgeInsets,
        );
      }
      return Container(
        key: ValueKey(3),
        height: cardHeight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: BouncingScrollPhysics(),
          itemCount:
              state.listOfCasts.length > 15 ? 15 : state.listOfCasts.length,
          itemBuilder: (context, index) {
            if (index == 0) {
              return SingleListCastCard(
                cardHeight: cardHeight,
                creditId: state.listOfCasts.elementAt(index),
                leftEdgeInsets: leftEdgeInsets,
                isFirst: true,
              );
            }
            return SingleListCastCard(
              cardHeight: cardHeight,
              creditId: state.listOfCasts.elementAt(index),
            );
          },
        ),
      );
    }
    return NetworkErrorCardListMain(
      key: ValueKey(2),
      cardHeight: cardHeight,
      leftEdgeInsets: leftEdgeInsets,
      functionToExecute: parentCubit.research,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(seconds: 2),
      child: childSwitcher(context: context),
    );
  }
}
