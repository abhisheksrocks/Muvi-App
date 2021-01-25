// 🐦 Flutter imports:
import 'package:Muvi/presentation/widgets/icon_maker.dart';
import 'package:flutter/material.dart';

class PageNotFound extends StatelessWidget {
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
          'Page Not Found',
          style: Theme.of(context).textTheme.headline1.apply(fontSizeDelta: 4),
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
