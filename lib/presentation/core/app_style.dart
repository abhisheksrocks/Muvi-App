// 🐦 Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'app_theme.dart';

@immutable
class AppStyle {
  Shader defaultPosterShader(Rect bounds) {
    ThemeData themeInfo = AppTheme().call();
    Color background = themeInfo.backgroundColor;
    Color foreground = themeInfo.iconTheme.color!;
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      stops: [0, 0.4, 1],
      colors: [
        // Colors.white,
        // Colors.white,
        // Colors.black,
        foreground,
        foreground,
        background,
      ],
    ).createShader(bounds);
  }

  LinearGradient defaultLinearGradient({double opacity = 1}) {
    return LinearGradient(
      colors: [
        Color(0xFFFF7274).withOpacity(opacity),
        Color(0xFFFF007C).withOpacity(opacity),
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    );
  }

  // LinearGradient disabledLinearGradient() {
  //   return LinearGradient(
  //     colors: [
  //       Colors.grey,
  //       Colors.black,
  //     ],
  //     begin: Alignment.bottomLeft,
  //     end: Alignment.topRight,
  //   );
  // }

  // LinearGradient noImageErrorLinearGradient() {
  //   return LinearGradient(
  //     colors: [
  //       Color(0xFFFF007C),
  //       Colors.blue,
  //     ],
  //     begin: Alignment.bottomLeft,
  //     end: Alignment.topRight,
  //   );
  // }

  // LinearGradient networkErrorLinearGradient() {
  //   return LinearGradient(
  //     colors: [
  //       Color(0xFFFF007C),
  //       Colors.grey,
  //     ],
  //     begin: Alignment.bottomLeft,
  //     end: Alignment.topRight,
  //   );
  // }
}
