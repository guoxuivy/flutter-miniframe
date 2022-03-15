import 'package:agent/res/colors.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:flutter/material.dart';

class YsListItem extends StatelessWidget {
  YsListItem({
    Key? key,
    this.media,
    this.title,
    this.trailing,
    this.hasArrow = false,
    this.titleAlignment,
    this.padding,
    this.margin,
    this.crossAxisAlignment,
    this.color,
    this.onTap,
    this.append,
  }) : super(key: key);

  final Widget? media;
  final Widget? title;
  final Widget? trailing;
  final bool hasArrow;
  final Alignment? titleAlignment;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final CrossAxisAlignment? crossAxisAlignment;
  final Color? color;
  final void Function()? onTap;
  final Widget? append;

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [];
    // 左边
    if (media != null) {
      _children.add(media!);
      _children.add(SizedBox(width: 10));
    }
    // 中间
    if (title != null) {
      _children.add(Expanded(
        flex: 100,
        child: Container(
          child: title,
          alignment: titleAlignment,
        ),
      ));
    }
    // 右边
    _children.add(Spacer());
    if (trailing != null) {
      _children.add(trailing!);
    }
    if (hasArrow) {
      _children.add(YsIcon(
        src: '&#xe627;',
        size: 14,
        color: Colours.muted,
      ));
    }

    return InkWell(
      child: Container(
          alignment: Alignment.topLeft,
          decoration: BoxDecoration(
            color: color ?? Colors.transparent,
            border: Border(bottom: BorderSide(color: Colors.grey[200]!, width: 0.5)),
          ),
          padding: padding ?? EdgeInsets.only(top: 10, bottom: 10),
          margin: margin ?? EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
                  children: _children),
              append ?? Container()
            ],
          )),
      onTap: onTap,
    );
  }
}
