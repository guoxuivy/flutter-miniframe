import 'package:agent/res/colors.dart';
import 'package:agent/utils/utils.dart';
import 'package:flutter/material.dart';

class YsImg extends StatelessWidget {
  YsImg(
      {Key? key,
      required this.src,
      this.width,
      this.height,
      this.borderRadius = 3,
      this.fit,
      this.margin,
      this.thumb = false})
      : super(key: key);

  final String src;
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxFit? fit;
  final EdgeInsets? margin;
  final bool thumb;

  @override
  Widget build(BuildContext context) {
    bool _isLocal = src.contains('assets');
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: margin ?? EdgeInsets.all(0),
      child: _isLocal
          ? Image.asset(
              src,
              width: width ?? 130.0,
              height: height ?? 90.0,
              fit: fit ?? BoxFit.cover,
            )
          : Image.network(
              Utils.imgUrl(src, thumb),
              width: width ?? 130.0,
              height: height ?? 90.0,
              fit: fit ?? BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Color(0xffeeeeee),
                  width: width ?? 130.0,
                  height: height ?? 90.0,
                  alignment: Alignment.center,
                  child: Text(
                    '图片异常',
                    style: TextStyle(fontSize: 12, color: Colours.muted),
                  ),
                );
              },
            ),
    );
  }
}
