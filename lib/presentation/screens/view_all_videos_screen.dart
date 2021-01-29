// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../cubit/movie_videos_fetcher_cubit.dart';
import '../widgets/icon_maker.dart';
import '../widgets/single_list_video_card.dart';

class ViewAllVideosScreen extends StatefulWidget {
  final MovieVideosFetcherLoaded state;

  const ViewAllVideosScreen({
    Key key,
    @required this.state,
  }) : super(key: key);

  @override
  _ViewAllVideosScreenState createState() => _ViewAllVideosScreenState();
}

class _ViewAllVideosScreenState extends State<ViewAllVideosScreen> {
  double eachCardWidth;

  double findEachCardWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardHorizontalPadding = 16;
    double minCardWidth = 200;
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
          semanticLabel: 'Back Button',
          icon: Icon(Icons.arrow_back),
          functionToPerform: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Videos',
          style: Theme.of(context).textTheme.headline1.apply(fontSizeDelta: 4),
        ),
      ),
      body: SingleChildScrollView(
        child: Wrap(
          runSpacing: 10,
          children: (widget.state.listOfVideos)
              .map((videoId) => SingleListVideoCard(
                    cardHeight: eachCardWidth * 9 / 16,
                    videoId: videoId,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
