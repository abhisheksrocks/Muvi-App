// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../core/app_style.dart';

class ButtonWithTextIcon extends StatelessWidget {
  final Widget? icon;
  final Color? color;
  final Gradient? gradient;
  final Widget label;
  final void Function()? onPressed;
  const ButtonWithTextIcon({
    Key? key,
    this.icon,
    this.color,
    this.gradient,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      borderRadius: buildBorderRadius(),
      gradient: (color == null && gradient == null)
          ? AppStyle().defaultLinearGradient()
          : gradient,
      color: color == null ? Colors.grey : color,
    );
  }

  BorderRadius buildBorderRadius() {
    return BorderRadius.circular(4);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Ink(
        decoration: buildBoxDecoration(),
        child: InkWell(
          borderRadius: buildBorderRadius(),
          onTap: onPressed,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 8,
              vertical: icon == null ? 8 : 6,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                icon ?? SizedBox(),
                icon == null
                    ? SizedBox()
                    : SizedBox(
                        width: 4,
                      ),
                label,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
