// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class DrawerWidget extends StatefulWidget {
  final AnimationController animationController;
  const DrawerWidget({
    Key key,
    @required this.animationController,
  }) : super(key: key);
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  Animation<Offset> _drawerSlideTransition;

  @override
  void initState() {
    _drawerSlideTransition = Tween<Offset>(
      begin: Offset(-0.6, 0),
      end: Offset(0, 0),
    )
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(widget.animationController);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black87,
      child: SlideTransition(
        position: _drawerSlideTransition,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              // color: Colors.black54,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: ListTile(
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset(
                      'assets/images/logo_white.svg',
                      height: 40,
                    ),
                    Text(
                      'v0.0.1',
                      style: Theme.of(context)
                          .textTheme
                          .headline3
                          .copyWith(color: Colors.pink),
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, '/about');
              },
              child: ListTile(
                title: Text(
                  'About',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                const url = 'https://www.linkedin.com/in/abhishek-97099b125/';
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: ListTile(
                title: Text(
                  'Visit the developer',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
