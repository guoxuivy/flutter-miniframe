import 'package:flutter/material.dart';

class YsButton extends StatefulWidget {
  final IconData iconData;
  final String title;
  final String type;
  final String size;
  final bool plain;
  final double height;
  final margin;
  final textStyle;
  final VoidCallback onPressed;

  const YsButton({
    Key key,
    this.iconData,
    this.title,
    this.margin,
    this.textStyle,
    this.type,
    this.size,
    this.plain = false,
    this.height,
    this.onPressed,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YsButtonState();
  }
}

class YsButtonState extends State<YsButton> {
  TextStyle get textStyle {
    return widget.textStyle;
  }

  String get title {
    return widget.title;
  }

  String get size {
    return widget.size ?? 'medium';
  }

  String get type {
    return widget.type ?? 'primary';
  }

  VoidCallback get onPressed {
    return widget.onPressed;
  }

  @override
  Widget build(BuildContext context) {
    if (type == 'text') {
      return GestureDetector(
        child: Text(
          title,
          style: textStyle,
        ),
        onTap: onPressed,
      );
    }
    var colorMap = {'primary': Color(0xff198AFF), 'danger': Colors.red};
    var sizeMap = {'small': 14.0, 'mini': 12.0, 'medium': 16.0, 'large': 30.0};
    var heightMap = {'mini': 24.0, 'small': 32.0, 'medium': 44.0, 'large': 50.0};
    var textColor = Colors.white;
    var color = colorMap[type];
    var height = widget.height ?? heightMap[size];
    var shape;
    if (type == 'info') {
      textColor = Color(0xff888888);
    }
    if (widget.plain) {
      textColor = color;
      color = Colors.white;
      shape = RoundedRectangleBorder(side: BorderSide(color: textColor));
    }
    var width = double.infinity;
    return Column(children: [
      Container(
        width: width,
        height: height,
        margin: widget.margin,
        child: RaisedButton(
          shape: shape,
          color: color,
          textColor: textColor,
          child: Text(
            title == null ? "" : title,
            style: TextStyle(
              fontSize: sizeMap[size],
              color: textColor,
            ),
          ),
          onPressed: onPressed,
        ),
      )
    ]);
  }
}
