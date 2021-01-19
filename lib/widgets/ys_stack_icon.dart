import 'package:flutter/material.dart';

/// icon 叠加角标数量
class YsStackIcon extends StatelessWidget {
  const YsStackIcon(this.icon, this.count,
      {this.showNum = true, this.radiusSize});

  final int count;
  final Icon icon;
  final bool showNum;
  final double radiusSize;

  @override
  Widget build(BuildContext context) {
    final double _radiusSize = radiusSize ?? (showNum ? 7.0 : 4.0);

    final Widget num = showNum
        ? Text(
            "$count", //通知数量
            style: TextStyle(
              color: Colors.white,
              fontSize: _radiusSize,
            ),
            // textAlign: TextAlign.center,
          )
        : null;

    return count == 0
        ? icon
        : Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              icon,
              Positioned(
                right: -_radiusSize,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(_radiusSize),
                  ),
                  constraints: BoxConstraints(
                    minWidth: _radiusSize * 2,
                    minHeight: _radiusSize * 2,
                  ),
                  child: num,
                ),
              )
            ],
          );
  }
}
