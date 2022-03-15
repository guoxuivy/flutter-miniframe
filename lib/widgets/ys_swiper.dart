import 'package:agent/routers/routers.dart';
import 'package:agent/utils/utils.dart';
import 'package:flutter/material.dart';

class YsSwiper extends StatefulWidget {
  YsSwiper({
    Key? key,
    required this.data,
    this.extraPicHeight,
    this.append,
  }) : super(key: key);
  final List<String> data;

  // 图片的高度
  final double? extraPicHeight;
  final append;

  @override
  State<StatefulWidget> createState() {
    return YsSwiperState();
  }
}

class YsSwiperState extends State<YsSwiper> {
  int currentIndex = 0;

  void onPageChanged(int index) {
    currentIndex = index;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [];
    widget.data.forEach((item) {
      if (item != '') {
        _children.add(Container(
          //缩放的图片
          width: MediaQuery.of(context).size.width,
          child: InkWell(
            child: Image.network(
              Utils.imgUrl(item),
              height: widget.extraPicHeight,
              fit: BoxFit.fill,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/images/no_pic.png',
                  height: widget.extraPicHeight,
                  fit: BoxFit.fill,
                );
              },
            ),
            onTap: () {
              Routers.go(context, '/image_preview', {
                'items': widget.data,
                'initialIndex': currentIndex,
              });
            },
          ),
        ));
      }
    });
    // 默认图片
    if (_children.length == 0) {
      _children.add(Container(
        width: MediaQuery.of(context).size.width,
        child: Image.asset('assets/images/no_pic.png',
            height: widget.extraPicHeight, fit: BoxFit.fill),
      ));
    }
    return Stack(
      children: [
        PageView(
          children: _children,
          scrollDirection: Axis.horizontal,
          onPageChanged: onPageChanged,
        ),
        Positioned(
          right: 10,
          bottom: 10,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0x47000000),
            ),
            height: 24,
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Text(
              '${currentIndex + 1}/${_children.length}',
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
        widget.append != null ? widget.append(currentIndex) : Container(),
      ],
    );
  }
}
