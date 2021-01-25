// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class NetworkErrorOverlay extends StatelessWidget {
  final Function functionToExecute;
  const NetworkErrorOverlay({
    Key key,
    this.functionToExecute,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(Icons.error),
          Container(
            padding: EdgeInsets.all(8),
            // color: Theme.of(context).errorColor.withOpacity(0.5),
            color: Theme.of(context).accentColor.withOpacity(0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.error,
                  color: Colors.white,
                ),
                Text(
                  'NETWORK ERROR',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1
                      .copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          if (functionToExecute != null)
            FlatButton(
              onPressed: functionToExecute,
              color: Colors.grey.withOpacity(0.2),
              child: const Text('Reload'),
            ),
        ],
      ),
    );
  }
}
