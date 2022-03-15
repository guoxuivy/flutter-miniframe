import 'package:flutter/material.dart';

/// icon 叠加角标数量
class YsStackIcon extends StatelessWidget {
  const YsStackIcon({
    this.count,
    this.child,
    this.showNum = true,
    this.radiusSize,
  });

  final int? count;
  final Widget? child;
  final bool showNum;
  final double? radiusSize;

  @override
  Widget build(BuildContext context) {
    final double _radiusSize = radiusSize ?? (showNum ? 8.0 : 6.0);
    int _count = count ?? 0;
    final Widget? num = showNum
        ? Text(
            '$_count', //通知数量
            style: TextStyle(
              color: Colors.white,
              fontSize: _radiusSize,
            ),
          )
        : null;
    Widget _badge = Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 3, right: 3),
      decoration: BoxDecoration(
        color: Colors.red,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(_radiusSize),
      ),
      constraints: BoxConstraints(
        minWidth: _radiusSize * 2,
        minHeight: _radiusSize * 2,
      ),
      child: num,
    );
    return _count == 0
        ? child ?? Container()
        : child != null
            ? Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  child!,
                  Positioned(
                    right: -_radiusSize,
                    top: -4,
                    child: _badge,
                  )
                ],
              )
            : _badge;
  }
}
