import 'package:agent/utils/global_key_ext.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:flutter/material.dart';

class YsPopupMenu extends StatefulWidget {
  final String title;
  final double itemHeight;
  final List<Map<String, dynamic>> items;
  final Function? onTap;
  final double popupWidth;

  YsPopupMenu({
    Key? key,
    this.title = 'title',
    required this.items,
    this.itemHeight = 40,
    this.onTap,
    this.popupWidth = 100,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _YsPopupMenu();
}

class _YsPopupMenu extends State<YsPopupMenu> {
  final GlobalKey btnKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final List<PopupMenuEntry> popupMenuItems = [];
    double _overlayHeight = 30;
    for (var item in widget.items) {
      if (item['show'] ?? true) {
        _overlayHeight += widget.itemHeight;
        popupMenuItems.add(
          PopupMenuItem(
            child: Text(item['title']),
            value: item, //兼容旧代码
            height: widget.itemHeight,
            // padding: EdgeInsets.all(0),
            textStyle: TextStyle(
              fontSize: 13,
              color: Color(0xffc5c5c5),
            ),
          ),
        );
      }
    }

    return YsButton(
      key: btnKey,
      title: widget.title,
      text: true,
      size: 'small',
      onPressed: () {
        Offset _offset = btnKey.globalOffset();
        showMenu(
          context: context,
          position: RelativeRect.fromLTRB(0, _offset.dy - _overlayHeight, 0, 0),
          items: popupMenuItems,
          color: Colors.black.withOpacity(.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
        ).then<void>((newValue) {
          if (!mounted) return null;
          if (newValue == null) {
            // widget.onCanceled?.call();
            return null;
          }
          if (newValue['onTap'] != null) {
            newValue['onTap']();
          }
          if (widget.onTap != null) {
            widget.onTap?.call(newValue);
          }
        });
      },
    );
  }
}
