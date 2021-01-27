// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import 'package:Muvi/presentation/widgets/loading_shimmer_placeholder.dart';
import 'package:Muvi/presentation/widgets/network_error_movie_card.dart';
import 'package:Muvi/presentation/widgets/network_error_overlay.dart';
import '../../models/video_bucket.dart';
import '../../models/video_model.dart';
import '../core/app_style.dart';
import 'icon_maker.dart';
import 'subtitle_text.dart';
import 'title_text.dart';

class SingleListVideoCard extends StatelessWidget {
  SingleListVideoCard({
    Key key,
    @required this.cardHeight,
    @required this.videoId,
    this.isFirst = false,
    this.leftEdgePadding = 18,
  })  : videoInfo = VideoBucket().getVideo(id: videoId),
        cardWidth = cardHeight * 16 / 9,
        super(key: key);

  final double cardWidth;
  final double cardHeight;
  final String videoId;
  final VideoModel videoInfo;
  final bool isFirst;
  final double leftEdgePadding;

  void playVideo() async {
    String url = "https://youtu.be/${videoInfo.path}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // print("Can't play video");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: playVideo,
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: isFirst
            ? EdgeInsets.only(
                left: leftEdgePadding,
                right: 8,
              )
            : EdgeInsets.symmetric(
                horizontal: 8,
              ),
        child: Stack(
          alignment: AlignmentDirectional.bottomStart,
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: ShaderMask(
                shaderCallback: AppStyle().defaultPosterShader,
                child: CachedNetworkImage(
                  imageUrl: videoInfo.path == null
                      ? ""
                      : "https://i.ytimg.com/vi/${videoInfo.path}/hqdefault.jpg",
                  placeholder: (context, url) => Container(
                    color: Colors.grey[900],
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Stack(
                    fit: StackFit.expand,
                    children: [
                      NetworkErrorMovieCard(),
                      NetworkErrorOverlay(),
                    ],
                  ),
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // AutoSizeText(
                  //   '${castInfo.person.name}',
                  //   style: Theme.of(context).textTheme.headline3,
                  //   minFontSize: 8,
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  TitleText(
                    title: '${videoInfo.title}',
                    textStyle: Theme.of(context).textTheme.headline3,
                  ),
                  SubtitleText(
                    textToDisplay: videoInfo.provider,
                    textStyle: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
            if (videoInfo.path != '' || videoInfo.path != null)
              IconMaker(
                icon: Icon(Icons.play_arrow),
                functionToPerform: playVideo,
                inverted: true,
                alternateApproach: true,
              ),
          ],
        ),
      ),
    );
  }
}
