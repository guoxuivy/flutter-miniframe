import 'package:flutter/material.dart';

class YsTitle extends StatelessWidget {
  const YsTitle({
    Key? key,
    this.title = '标题',
    this.actions,
    this.padding,
    this.textStyle,
    this.color,
  }) : super(key: key);

  final title;
  final List<Widget>? actions;
  final EdgeInsets? padding;
  final TextStyle? textStyle;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [
      title is Widget
          ? title
          : Text(
              title,
              style: textStyle ??
                  TextStyle(
                    fontSize: 18.0,
                    color: Color(0xff333333),
                    fontWeight: FontWeight.bold,
                  ),
            )
    ];
    if (actions != null) {
      children.add(Row(
        children: actions!,
      ));
    }
    return Container(
      padding: padding,
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: children,
      ),
    );
  }
}
