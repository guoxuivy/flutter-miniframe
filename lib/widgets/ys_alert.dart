import 'package:agent/res/colors.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:flutter/material.dart';

class YsAlert extends StatelessWidget {
  YsAlert({
    Key? key,
    this.color,
    this.textColor,
    this.type = 'info',
    this.text = true,
    this.mainAxisAlignment,
    this.padding,
    this.icon,
    this.title = '暂无内容！',
  }) : super(key: key);

  final Color? color;
  final Color? textColor;
  final String type;
  final bool text;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsets? padding;
  final String? icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    Map colorsMap = {
      'info': Color(0xffF2F4F9),
      'success': Colours.success,
      'warning': Colours.warning,
      'danger': Colours.danger,
    };
    Map textColorsMap = {
      'success': Color(0xff67c23a),
      'info': Color(0xff909399),
      'warning': Color(0xffe6a23c),
      'danger': Color(0xfff56c6c),
    };
    Color _color = color ?? colorsMap[type];
    Color _textColor = textColor ?? textColorsMap[type];

    List<Widget> _children = [];
    if (icon != null) {
      _children.add(YsIcon(
        color: _textColor,
        src: icon,
      ));
      _children.add(SizedBox(width: 5));
    }
    _children.add(Text(
      title,
      style: TextStyle(color: _textColor, fontSize: 13),
    ));
    return Container(
      color: text ? Colors.transparent : _color,
      padding: padding ?? EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment:
            mainAxisAlignment ?? (text ? MainAxisAlignment.center : MainAxisAlignment.start),
        children: _children,
      ),
    );
  }
}
