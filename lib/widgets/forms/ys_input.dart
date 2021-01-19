import 'package:flutter/material.dart';
import 'package:agent/widgets/ys_icon.dart';

class YsInput extends StatefulWidget {
  const YsInput({
    Key key,
    this.hintText = '请输入',
    this.stype = 'default',
    this.type = 'input',
    this.prefixIcon,
    this.size = 'medium',
    this.plain = false,
    this.enabled = true,
    this.height,
    this.value,
    this.margin,
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.onPressed,
    this.suffix,
  }) : super(key: key);

  final String hintText;
  final String type;
  final String stype;
  final String size;
  final prefixIcon;
  final TextAlign textAlign;
  final bool plain;
  final bool enabled;
  final double height;
  final onChanged;
  final value;
  final margin;
  final GestureTapCallback onPressed;
  final suffix;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YsInputState();
  }
}

class YsInputState extends State<YsInput> {
  final controller = TextEditingController();
  bool _isShowClear = false;

  @override
  void initState() {
    super.initState();
    // 初始化value
    controller.text = widget.value;
    // 添加监听
    controller.addListener(() {
      if (controller.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // var sizeMap = {'small': 14.0, 'mini': 12.0, 'medium': 16.0, 'large': 30.0};
    var heightMap = {'small': 32.0, 'medium': 44.0};
    var height = widget.height ?? heightMap[widget.size];

    var filled = false;
    var fillColor;
    var obscureText = false;
    var border;
    if (widget.stype == 'dark') {
      filled = true;
      fillColor = Color(0xffF4F4F4);
      border = InputBorder.none;
    }
    if (widget.type == 'password') {
      obscureText = true;
    }
    var suffixIcon;
    if (_isShowClear) {
      suffixIcon = IconButton(
        icon: YsIcon(
          src: '&#xe61b;',
          color: 'cccccc',
        ),
        onPressed: () {
          controller.clear();
          widget.onChanged('');
        },
      );
    }
    final InputDecoration decoration = InputDecoration(
      hintText: widget.hintText,
      hintStyle: TextStyle(color: Color(0xff999999)),
      filled: filled,
      fillColor: fillColor,
      enabled: widget.enabled,
      prefixIcon: YsIcon(src: widget.prefixIcon),
      suffix: widget.suffix,
      suffixIcon: suffixIcon,
      border: border,
      // errorText: 'xxxx',
    );
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      width: double.infinity,
      height: height,
      margin: widget.margin,
      child: TextField(
        controller: controller,
        decoration: decoration,
        obscureText: obscureText,
        onChanged: (value) {
          widget.onChanged(value);
        },
        textAlign: widget.textAlign,
      ),
    );
  }

  @override
  void dispose() {
    // 释放
    controller.dispose();
    super.dispose();
  }
}
