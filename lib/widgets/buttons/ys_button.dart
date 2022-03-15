import 'package:agent/res/colors.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:flutter/material.dart';

class YsButton extends StatefulWidget {
  final icon;
  final String iconPosition;
  final String title;
  final String type;
  final String size;
  final bool plain;
  final bool round;
  final bool text;
  final double? height;
  final double width;
  final double space;
  final Color? iconColor;
  final double? iconSize;
  final Color? color;
  final margin;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onPressed;
  final bool disabled;

  const YsButton({
    Key? key,
    this.icon,
    this.iconPosition = 'left',
    this.title = '',
    this.margin,
    this.textStyle,
    this.type = 'primary',
    this.size = 'medium',
    this.width = 0,
    // icon和文字在间距
    this.space = 5,
    this.plain = false,
    this.round = false,
    this.text = false,
    this.height,
    this.iconColor,
    this.iconSize,
    this.color,
    this.padding,
    this.onPressed,
    this.disabled = false,
  }) : super(key: key);

  @override
  YsButtonState createState() {
    return YsButtonState();
  }
}

class YsButtonState extends State<YsButton> {
  @override
  Widget build(BuildContext context) {
    VoidCallback onPressed = widget.onPressed ?? (() {});
    Map colorMap = {
      'primary': Colours.primary,
      'danger': Colours.danger,
      'info': Colours.info,
      'warning': Colours.warning,
      'muted': Color(0xffeeeeee),
    };
    /* Map plainColorMap = {
      'primary': Color(0xffEAF4FF),
      'danger': Color(0xfffbc4c4),
      'info': Color(0xffd3d4d6),
    }; */
    Map textColorMap = {
      'primary': Colours.text_primary,
      'danger': Colours.text_danger,
      'warning': Colours.text_warning,
      'info': Colours.text_info,
      'muted': Colours.text_muted,
    };
    Map sizeMap = {
      'large': 16.0,
      'medium': 15.0,
      'small': 14.0,
      'mini': 13.0,
      'pocket': 12.0,
    };
    Map heightMap = {
      'large': 46.0,
      'medium': 42.0,
      'small': 34.0,
      'mini': 28.0,
      'pocket': 26.0,
    };

    String _size = widget.size;
    var textColor = Colors.white;
    var color = widget.color ?? colorMap[widget.type];
    var height = widget.height ?? heightMap[_size];
    var _decoration;
    Border? _border;

    String _type = widget.disabled ? 'muted' : widget.type;
    if (widget.text) {
      textColor = textColorMap[_type];
      color = widget.color ?? Colors.transparent;
      _border = Border.all(color: textColor, style: BorderStyle.none, width: 1.0);
    } else if (widget.disabled) {
      color = colorMap['muted'];
      textColor = Colours.muted;
    } else if (widget.plain) {
      // textColor = color;
      textColor = textColorMap[_type];
      color = Colors.white;
      // color = plainColorMap[widget.type];
      _border = Border.all(color: colorMap[_type], width: 1.0);
    } else {
      // 单独设置muted
      if (widget.type == 'muted') {
        textColor = Colours.info;
      }
    }
    final _circular = widget.round ? height : 2.0;
    _decoration = BoxDecoration(
      color: color,
      border: _border,
      borderRadius: BorderRadius.all(Radius.circular(_circular)),
    );

    double? width = widget.width == 0 ? null widget.width; // ?? double.infinity;
    Widget child = Text(
      widget.title,
      style: widget.textStyle ??
          TextStyle(
            fontSize: sizeMap[_size],
            color: textColor,
          ),
    );
    // 带图标
    if (widget.icon != null) {
      final Widget _icon = widget.icon is Widget
          ? widget.icon
          : YsIcon(
              src: widget.icon,
              size: widget.iconSize ?? sizeMap[_size],
              color: widget.iconColor ?? textColor,
            );
      if (['top', 'bottom'].contains(widget.iconPosition)) {
        // icon上下
        child = Column(
          verticalDirection: {
            'top': VerticalDirection.down,
            'bottom': VerticalDirection.up,
          }[widget.iconPosition]!,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon,
            SizedBox(height: widget.space),
            child,
          ],
        );
      } else {
        // icon左右
        child = Row(
          textDirection: {
            'left': TextDirection.ltr,
            'right': TextDirection.rtl,
          }[widget.iconPosition],
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _icon,
            SizedBox(width: widget.title == '' ? 0 : widget.space),
            child,
          ],
        );
      }
    }
    // 圆角
    double _radius =
        (widget.title == '' || ['top', 'bottom'].contains(widget.iconPosition)) ? 30 : 0;
    return Material(
      // 不受父级color的影响需要Material
      color: Colors.transparent,
      child: Ink(
        decoration: _decoration,
        width: width,
        height: height,
        child: InkWell(
          child: Container(
            padding: widget.padding ?? EdgeInsets.all(0),
            child: child,
            alignment: Alignment.center,
          ),
          onTap: widget.disabled ? null : onPressed,
          borderRadius: BorderRadius.all(Radius.circular(_radius)),
        ),
      ),
    );
  }
}
