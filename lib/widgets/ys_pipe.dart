import 'package:flutter/material.dart';

class YsPipe extends StatelessWidget {
  YsPipe({
    Key? key,
    this.color,
    this.width = 20,
    this.height = 15,
  }) : super(key: key);

  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    Color _color = color ?? Color(0xffdddddd);
    return Container(
      height: height,
      child: VerticalDivider(
        color: _color,
        width: width,
        thickness: .8,
      ),
    );
  }
}
