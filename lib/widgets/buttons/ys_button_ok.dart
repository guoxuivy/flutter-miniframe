import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:flutter/material.dart';
import 'package:agent/res/colors.dart';

class YsButtonOk extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;

  const YsButtonOk({
    Key? key,
    this.onPressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return YsButton(
      text: true,
      padding: EdgeInsets.all(10),
      icon: Icons.done,
      iconSize: 20.0,
      iconColor: color ?? Colours.info,
      onPressed: onPressed ??
          () {
            Navigator.of(context).pop();
          },
    );
  }
}
