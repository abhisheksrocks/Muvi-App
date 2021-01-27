// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

// 🌎 Project imports:
import '../widgets/button_with_text_icon.dart';
import '../widgets/icon_maker.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconMaker(
          icon: Icon(
            Icons.arrow_back,
          ),
          functionToPerform: () => Navigator.pop(context),
        ),
        title: Text(
          'About',
          style: Theme.of(context).textTheme.headline1.apply(fontSizeDelta: 4),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(),
                  SvgPicture.asset(
                    'assets/images/muvi_icon_white_bg.svg',
                    height: 110,
                  ),
                  SizedBox(),
                  SvgPicture.asset(
                    'assets/images/tmdb_full_logo.svg',
                    height: 110,
                  ),
                  SizedBox(),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Text(
              //   'This app is powered by The Movie Database API.',
              //   style: Theme.of(context).textTheme.bodyText1,
              // ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'This app is powered by ',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'The Movie Database API, ',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.white),
                    ),
                    TextSpan(
                      text: 'written in Dart with Flutter framework.',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
              Text(
                '\nWant to completely customize this app and give it your own flavour? This app is open-sourced! Click on the link below and follow the instructions.',
                style: Theme.of(context)
                    .textTheme
                    .bodyText2
                    .copyWith(color: Colors.white),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWithTextIcon(
                    icon: SvgPicture.asset(
                      'assets/images/github_icon_black.svg',
                      color: Colors.white,
                      height: 20,
                    ),
                    label: Text(
                      'Github Repository',
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () async {
                      const url = 'https://github.com/abhisheksrocks/Muvi-App';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    color: Color(0xFF2EA44F),
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Text(
                'About the Developer',
                style: Theme.of(context).textTheme.headline3,
              ),
              RichText(
                text: TextSpan(
                  text: '\nMade with all the ❤️ by',
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.white),
                  children: [
                    TextSpan(
                      text: ' Abhishek,',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: Colors.white),
                    ),
                    TextSpan(
                      text:
                          " a passion driven developer in Bangalore, India. This guy has been obsessed with computers his whole life, and his interest in programming is a result of that. But don't just take my word for it (what do I know, I'm just an app!😉), check out his profile below, talk to him if you like.",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.white),
                    ),
                    TextSpan(
                      text:
                          '\nPsst! Do mention that I("Muvi" App) sent you there. He loves hearing my name.',
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Colors.white,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonWithTextIcon(
                    icon: SvgPicture.asset(
                      'assets/images/linkedin_icon_blue.svg',
                      color: Colors.white,
                      height: 20,
                    ),
                    label: Text(
                      'LinkedIn Profile',
                      style: Theme.of(context).textTheme.button,
                    ),
                    onPressed: () async {
                      const url =
                          'https://www.linkedin.com/in/abhishek-97099b125/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    color: Color(0xFF0E76A8),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
