// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class AppTheme {
  // double homeScreenTextSize() {
  //   return 40;
  // }

  // double get homeScreenTextSize => 40;

  ThemeData call() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      backgroundColor: Colors.black,
      primaryColor: Colors.black,
      accentColor: Color(0xFFFF007C),
      dividerColor: Color(0xFFFF007C),
      iconTheme: IconThemeData(
        size: 32,
        color: Colors.white,
      ),
      fontFamily: 'ParentFont',
      textTheme: TextTheme(
        //------------------------------------------------
        //Default Section Title -> attention seeking
        headline1: TextStyle(
          //All Titles like "Now Showing", "Trending now", etc
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),
        //Alternate Section Title -> non-attention seeking
        headline5: TextStyle(
          //All Titles like "Now Showing", "Trending now", etc
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        //------------------------------------------------

        //------------------------------------------------
        //Carousel Card
        headline2: TextStyle(
          //Movie-Info Screen Title & Carousel Card Title e.g. Movie Card, Cast Card -> "Tenet"
          fontSize: 20,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        subtitle1: TextStyle(
          //Carousel Card Genre e.g. Movie Card, Cast Card -> Action, Adventure
          fontSize: 12,
          color: Colors.white38,
          fontWeight: FontWeight.w500,
        ),
        //------------------------------------------------

        //------------------------------------------------
        //General Card
        headline3: TextStyle(
          //General Card Title e.g. Movie Card, Cast Card -> "Tenet" and "v1.0" in Drawer
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        subtitle2: TextStyle(
          //General Card Subtile e.g. Movie Card, Cast Card -> Action, Adventure
          fontSize: 8,
          color: Colors.white38,
          // color: Color(0xFFD5D5D5),
          fontWeight: FontWeight.w500,
        ),
        bodyText2: TextStyle(
          //Movie-info screen cast card characters
          fontSize: 12,
          color: Colors.white38,
          fontWeight: FontWeight.w400,
        ),
        //------------------------------------------------

        //------------------------------------------------
        //Movie Info Screen-> info about movie title
        headline4: TextStyle(
          //Movie-Info Screen Title
          fontSize: 36,
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        bodyText1: TextStyle(
          //Movie-info screen body text style and "Powered by TMDb" in Drawer
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.w300,
        ),
        //------------------------------------------------

        //------------------------------------------------
        overline: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: Colors.white38,
        ),
        headline6: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: Colors.white,
        ),
        //------------------------------------------------

        button: TextStyle(
          // Reserved for "View All" Buttons
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        caption: TextStyle(
          // For "NO IMAGE / NETWORK ERROR" cards status
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      appBarTheme: AppBarTheme(
        // color: Colors.white10,
        color: Colors.black,
      ),
    );
  }
}
