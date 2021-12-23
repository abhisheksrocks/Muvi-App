// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../models/cast_bucket.dart';
import '../../models/cast_model.dart';
import '../core/app_style.dart';
import 'my_image_viewer.dart';
import 'subtitle_text.dart';
import 'title_text.dart';

class SingleListCastCard extends StatelessWidget {
  SingleListCastCard({
    Key? key,
    required this.cardHeight,
    required this.creditId,
    this.isFirst = false,
    this.leftEdgeInsets = 18,
  })  : castInfo = CastBucket().getCast(creditId: creditId),
        cardWidth = cardHeight * 2 / 3,
        super(key: key);

  final double cardWidth;
  final double cardHeight;
  final String creditId;
  final CastModel castInfo;
  final bool isFirst;
  final double leftEdgeInsets;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      height: cardHeight,
      margin: isFirst
          ? EdgeInsets.only(
              left: leftEdgeInsets,
              right: 8,
            )
          : EdgeInsets.symmetric(
              horizontal: 8,
            ),
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: ShaderMask(
              shaderCallback: AppStyle().defaultPosterShader,
              child: Center(
                // child: CachedNetworkImage(
                //   imageUrl: castInfo.person.avatarPath == null
                //       ? ""
                //       : "https://image.tmdb.org/t/p/w200${castInfo.person.avatarPath}",
                //   placeholder: (context, url) => ImageLoadingPlaceholder(),
                //   errorWidget: (context, url, error) =>
                //       ImageErrorWidget(imagePath: castInfo.person.avatarPath),
                //   fit: BoxFit.cover,
                // ),
                child: MyImageViewer(
                  imagePath: castInfo.person.avatarPath!,
                  widgetWidth: cardWidth,
                ),
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
                  title: '${castInfo.person.name}',
                  textStyle: Theme.of(context).textTheme.headline3!,
                ),
                (castInfo.characterName != null && castInfo.characterName != '')
                    ? SubtitleText(
                        textToDisplay: castInfo.characterName!,
                        textStyle: Theme.of(context).textTheme.bodyText2!,
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
