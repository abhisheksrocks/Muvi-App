// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class SectionHeading extends StatelessWidget {
  final String text;
  // final bool alternate;
  const SectionHeading({
    Key? key,
    required this.text,
    // this.alternate = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
