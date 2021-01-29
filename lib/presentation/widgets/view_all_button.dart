// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../core/app_style.dart';

class ViewAllButton extends StatelessWidget {
  final Function functionToExecute;
  const ViewAllButton({
    Key key,
    this.functionToExecute,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        gradient: functionToExecute != null
            ? AppStyle().defaultLinearGradient()
            : null,
        color: functionToExecute != null ? null : Colors.grey,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: functionToExecute,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 6,
              vertical: 2,
            ),
            child: Text(
              'View All',
              semanticsLabel:
                  '${functionToExecute == null ? 'Disabled' : ''} View all button',
              style: functionToExecute != null
                  ? Theme.of(context).textTheme.button.copyWith(
                        color: Colors.black,
                      )
                  : Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.grey.shade800),
            ),
          ),
        ),
      ),
    );
  }
}
