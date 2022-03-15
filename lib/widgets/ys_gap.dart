import 'package:flutter/material.dart';

class YsGap extends StatelessWidget {
  YsGap({
    Key? key,
    this.color,
    this.height = 5,
  }) : super(key: key);

  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Color _color = color ?? Color(0xfff6f7f9);
    return Container(height: height, color: _color);
  }
}
