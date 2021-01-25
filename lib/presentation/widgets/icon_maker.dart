// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class IconMaker extends StatelessWidget {
  final Widget icon;
  final Function functionToPerform;
  final bool inverted;
  final bool alternateApproach;
  const IconMaker({
    Key key,
    @required this.icon,
    this.functionToPerform,
    this.inverted = false,
    this.alternateApproach = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: alternateApproach
          ? Container(
              decoration: buildCommonBoxDecoration(context),
              child: Material(
                color: Colors.transparent,
                child: buildCommonInkWell(context),
              ),
            )
          : Ink(
              decoration: buildCommonBoxDecoration(context),
              child: buildCommonInkWell(context),
            ),
    );
  }

  BoxDecoration buildCommonBoxDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color:
          inverted ? Theme.of(context).backgroundColor.withOpacity(0.3) : null,
      // : Theme.of(context).iconTheme.color.withOpacity(0.3),
    );
  }

  InkWell buildCommonInkWell(BuildContext context) {
    return InkWell(
      onTap: functionToPerform,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        margin: EdgeInsets.all(2),
        child: icon,
      ),
    );
  }
}
