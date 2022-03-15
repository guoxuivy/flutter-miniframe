import 'package:flutter/material.dart';

class YsIcon extends StatelessWidget {
  const YsIcon({
    Key? key,
    this.color = '73777A',
    this.src,
    this.type = 'primary',
    this.size = 16,
  }) : super(key: key);

  final String type;
  final src;
  final double size;
  final color;

  @override
  Widget build(BuildContext context) {
    final _color = color is Color
        ? color
        : Color(
            int.parse('0xff' + color),
          );
    if (src is IconData) {
      return Icon(
        src,
        size: size,
        color: _color,
      );
    }
    final _code = int.parse(src.replaceAll('&#', '0').replaceAll(';', ''));
    return Icon(
      IconData(_code, fontFamily: 'Iconfont'),
      size: size,
      color: _color,
    );
  }
}
