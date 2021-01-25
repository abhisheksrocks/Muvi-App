import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// 🌎 Project imports:
import '../../cubit/image_manager_cubit.dart';
import 'network_error_movie_card.dart';

class MyImageViewer extends StatelessWidget {
  final String imagePath;
  final double widgetWidth;
  const MyImageViewer({
    Key key,
    @required this.imagePath,
    this.widgetWidth = 100,
  }) : super(key: key);

  // Widget childSwitcher(BuildContext context) {
  //   var cubit = context.watch<ImageManagerCubit>();
  //   var state = cubit.state;
  //   if (state is ImageManagerFailed) {
  //     return Container(
  //       key: ValueKey(1),
  //       width: widgetWidth,
  //       child: AspectRatio(
  //         aspectRatio: 2 / 3,
  //         child: Container(
  //           decoration: BoxDecoration(
  //             border: Border.all(
  //               color: Colors.white10,
  //               width: 2,
  //             ),
  //             borderRadius: BorderRadius.circular(14),
  //             color: Colors.grey.withOpacity(0.1),
  //           ),
  //           child: Center(
  //             child: Icon(Icons.warning),
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  //   return Container(
  //     key: new UniqueKey(),
  //     width: widgetWidth,
  //     child: AspectRatio(
  //       aspectRatio: 2 / 3,
  //       child: imageMaker(cubit),
  //     ),
  //   );
  // }

  // Widget imageMaker(ImageManagerCubit cubit) {
  //   String imageUrl = cubit.imageUrl;
  //   String placeholderUrl = cubit.placeholderUrl;
  //   if (imageUrl != null) {
  //     return CachedNetworkImage(
  //       imageUrl: imageUrl,
  //       fit: BoxFit.cover,
  //       placeholder: (context, url) {
  //         if (placeholderUrl != null) {
  //           return CachedNetworkImage(
  //             imageUrl: placeholderUrl,
  //             fit: BoxFit.cover,
  //           );
  //         } else {
  //           return Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //       },
  //     );
  //   }
  //   return Center(
  //     child: CircularProgressIndicator(),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ImageManagerCubit(
        posterImagePath: imagePath,
        placeholderWidth: widgetWidth,
      ),
      lazy: false,
      child: MyAnimatedSwitcher(
        imagePath: imagePath,
        widgetWidth: widgetWidth,
      ),
    );
  }
}

class MyAnimatedSwitcher extends StatelessWidget {
  final String imagePath;
  final double widgetWidth;
  MyAnimatedSwitcher({
    Key key,
    @required this.imagePath,
    @required this.widgetWidth,
  }) : super(key: key);

  Widget childSwitcher(BuildContext context) {
    var cubit = context.watch<ImageManagerCubit>();
    var state = cubit.state;
    // print("imageUrl: ${cubit.imageUrl}");
    // print("placeholderUrl: ${cubit.placeholderUrl}");
    if (state is ImageManagerFailed) {
      if (state.isImagepathEmpty) {
        return Container(
          key: ValueKey(1),
          width: widgetWidth,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey[700],
              width: 2,
            ),
            borderRadius: BorderRadius.circular(14),
            color: Colors.grey[800],
          ),
          child: Center(
            child: Icon(Icons.warning),
          ),
        );
      } else {
        return NetworkErrorMovieCard(
          key: ValueKey(1),
        );
        // return Container(
        //   height: double.infinity,
        //   width: double.infinity,
        //   key: ValueKey(2),
        //   decoration: BoxDecoration(
        //     border: Border.all(
        //       color: Colors.grey[700],
        //       width: 2,
        //     ),
        //     borderRadius: BorderRadius.circular(14),
        //     color: Colors.grey[800],
        //   ),
        //   child: Padding(
        //     padding: EdgeInsets.symmetric(horizontal: 10),
        //     child: Column(
        //       crossAxisAlignment: CrossAxisAlignment.center,
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       mainAxisSize: MainAxisSize.min,
        //       children: [
        //         Icon(
        //           Icons.error,
        //           color: Colors.white38,
        //         ),
        //         AutoSizeText(
        //           'Network Error',
        //           style: Theme.of(context).textTheme.caption,
        //           maxLines: 1,
        //         )
        //       ],
        //     ),
        //   ),
        // );
      }
    }
    return Container(
      width: double.infinity,
      height: double.infinity,
      key: ValueKey(3),
      child: imageMaker(cubit),
    );
  }

  Widget imageMaker(ImageManagerCubit cubit) {
    String imageUrl = cubit.imageUrl;
    String placeholderUrl = cubit.placeholderUrl;
    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) {
          if (placeholderUrl != null) {
            return CachedNetworkImage(
              imageUrl: placeholderUrl,
              fit: BoxFit.cover,
            );
          } else {
            return Container(
              color: Colors.grey[900],
              // color: Colors.grey.withOpacity(0.1),
              child: Center(
                child: CircularProgressIndicator(
                  key: ValueKey("Load"),
                ),
              ),
            );
          }
        },
        errorWidget: (context, url, error) {
          cubit.emitNetworkFailState();
          return NetworkErrorMovieCard();
          return Container(
            width: widgetWidth,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[700],
                width: 2,
              ),
              borderRadius: BorderRadius.circular(14),
              color: Colors.grey[800],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error,
                    color: Colors.white38,
                  ),
                  AutoSizeText(
                    'Network Error',
                    style: Theme.of(context).textTheme.caption,
                    maxLines: 1,
                  )
                ],
              ),
            ),
          );
        },
      );
    }
    if (placeholderUrl != null) {
      return CachedNetworkImage(
        imageUrl: placeholderUrl,
        fit: BoxFit.cover,
      );
    }
    return Container(
      color: Colors.grey[900],
      // color: Colors.grey.withOpacity(0.1),
      // child: Center(
      //   child: CircularProgressIndicator(
      //     key: ValueKey("Load"),
      //   ),
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(
        seconds: 1,
      ),
      child: childSwitcher(context),
    );
  }
}
