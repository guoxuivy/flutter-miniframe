import 'package:flutter/material.dart';

class YsRate extends StatefulWidget {
  final int rate; // 评分值
  final double maxRate; // 最大评分值
  final int count; // 五角星个数
  final Widget unselectedImage; // 没有选中图片
  final Widget selectedImage; // 选中图片
  final double size; // 五角星大小
  final Color unselectedColor; // 没有选中的颜色
  final Color selectedColor; // 选中颜色

  YsRate({
    required this.rate,
    this.maxRate = 3,
    this.size = 18,
    this.unselectedColor = const Color(0xffbbbbbb),
    this.selectedColor = const Color(0xffFC9834),
    unselectedImage,
    selectedImage,
    this.count = 3,
  })  : unselectedImage = unselectedImage ??
            Icon(
              Icons.star,
              size: size,
              color: unselectedColor,
            ),
        selectedImage = selectedImage ??
            Icon(
              Icons.star,
              size: size,
              color: selectedColor,
            );

  @override
  _StarRatingState createState() => _StarRatingState();
}

/// 状态
class _StarRatingState extends State<YsRate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Row(
            children: getUnSelectImage(),
            mainAxisSize: MainAxisSize.min,
          ),
          Row(
            children: getSelectImage(),
            mainAxisSize: MainAxisSize.min,
          ),
        ],
      ),
    );
  }

  // 获取评星
  List<Widget> getUnSelectImage() {
    return List.generate(widget.count, (index) => widget.unselectedImage);
  }

  List<Widget> getSelectImage() {
    // 1.计算Star个数和剩余比例等
    double oneValue = widget.maxRate / widget.count; // 单个星分值
    int entireCount = (widget.rate / oneValue).floor();
    double leftValue = widget.rate - entireCount * oneValue;
    double leftRatio = leftValue / oneValue;

    // 2.获取start
    List<Widget> selectedImages = [];
    for (int i = 0; i < entireCount; i++) {
      selectedImages.add(widget.selectedImage);
    }

    // 3.计算
    Widget leftStar = ClipRect(
      clipper: MyRectClipper(width: leftRatio * widget.size),
      child: widget.selectedImage,
    );
    selectedImages.add(leftStar);

    return selectedImages;
  }
}

class MyRectClipper extends CustomClipper<Rect> {
  final double width;

  MyRectClipper({this.width=0});

  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(0, 0, width, size.height);
  }

  @override
  bool shouldReclip(MyRectClipper oldClipper) {
    return width != oldClipper.width;
  }
}
