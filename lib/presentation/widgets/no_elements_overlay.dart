// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class NoElementsOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.grey.withOpacity(0.2),
        child: Text(
          'No matching result!',
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: Colors.white),
        ),
      ),
    );
  }
}
