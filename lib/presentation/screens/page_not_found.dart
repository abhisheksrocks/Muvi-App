// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import 'package:muvi/presentation/widgets/icon_maker.dart';

class PageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconMaker(
          semanticLabel: 'back button',
          icon: Icon(
            Icons.arrow_back,
          ),
          functionToPerform: () => Navigator.pop(context),
        ),
        title: Text(
          'Page Not Found',
          style: Theme.of(context).textTheme.headline1!.apply(fontSizeDelta: 4),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'ERROR 404',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w800,
            ),
          ),
          Text("Page you were looking for couldn't be found"),
          SizedBox(
            height: 20,
          ),
          IconMaker(
            semanticLabel: 'back button',
            icon: Icon(
              Icons.arrow_back,
            ),
            functionToPerform: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
