// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../cubit/movie_videos_fetcher_cubit.dart';
import 'loading_card_list_main.dart';
import 'network_error_card_list_main.dart';
import 'no_elements_card_list_main.dart';
import 'single_list_video_card.dart';

class CardListVideoGeneral extends StatelessWidget {
  final MovieVideosFetcherCubit parentCubit;
  final double cardHeight;
  final double leftEdgePadding;

  const CardListVideoGeneral({
    Key? key,
    required this.parentCubit,
    this.cardHeight = 148,
    this.leftEdgePadding = 18,
  }) : super(key: key);

  Widget childSwitcher({
    required BuildContext context,
  }) {
    var state = parentCubit.state;
    // print("Video general state: $state");
    if (state is MovieVideosFetcherLoaded) {
      if (state.listOfVideos.length == 0) {
        return NoElementsCardListMain(
          key: ValueKey(1),
          aspectRatio: 16 / 9,
          cardHeight: cardHeight,
          leftEdgePadding: leftEdgePadding,
        );
      } else {
        return Container(
          key: ValueKey(2),
          height: cardHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: BouncingScrollPhysics(),
            itemCount:
                state.listOfVideos.length > 5 ? 5 : state.listOfVideos.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SingleListVideoCard(
                  cardHeight: cardHeight,
                  videoId: state.listOfVideos.elementAt(index),
                  leftEdgePadding: leftEdgePadding,
                  isFirst: true,
                );
              }
              return SingleListVideoCard(
                cardHeight: cardHeight,
                videoId: state.listOfVideos.elementAt(index),
              );
            },
          ),
        );
      }
    } else if (state is MovieVideosFetcherLoading) {
      return LoadingCardListMain(
        key: ValueKey(4),
        cardHeight: cardHeight,
        leftEdgePadding: leftEdgePadding,
        functionToExecute: parentCubit.research,
        state: state,
        aspectRatio: 16 / 9,
      );
    }
    return NetworkErrorCardListMain(
      key: ValueKey(3),
      cardHeight: cardHeight,
      leftEdgeInsets: leftEdgePadding,
      functionToExecute: parentCubit.research,
      aspectRatio: 16 / 9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(seconds: 1),
      child: childSwitcher(
        context: context,
      ),
    );
  }
}
