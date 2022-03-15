import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:flutter/material.dart';
import 'package:agent/res/colors.dart';

class YsButtonBack extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final bool round;
  final params;

  const YsButtonBack({
    Key? key,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.round = false,
    this.params,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YsButton(
      round: round,
      text: true,
      color: backgroundColor,
      padding: EdgeInsets.all(10),
      icon: '&#xedb0;',
      iconSize: 18.0,
      iconColor: color ?? Colours.info,
      onPressed: onPressed ??
          () {
            // Navigator.of(context).pop();
            Navigator.pop(context, this.params);
          },
    );
  }
}
