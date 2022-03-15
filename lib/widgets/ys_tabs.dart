import 'package:agent/res/colors.dart';
import 'package:agent/utils/utils.dart';
import 'package:flutter/material.dart';

enum TabsType {
  text,
  card,
  bgcard,
  capsule,
}

class YsTabs extends StatefulWidget {
  const YsTabs({
    Key? key,
    required this.tabs,
    this.active = 0,
    this.isRouter = false,
    this.hasBorder = true,
    this.contentScroll = false,
    this.onPressed,
    this.renderContent,
    this.mainAxisAlignment,
    this.padding,
    // card bgcard capsule
    this.type = TabsType.text,
    this.size = 'medium',
  }) : super(key: key);

  final List tabs;
  final int active;
  final bool isRouter;
  final bool hasBorder;
  final bool contentScroll;
  final onPressed;
  final renderContent;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsets? padding;
  final TabsType type;
  final String size;

  @override
  State<StatefulWidget> createState() {
    return YsTabsState();
  }
}

class YsTabsState extends State<YsTabs> {
  Widget? _body;
  int _index = 0;
  List _tabsData = [];

  init() {
    _tabsData = widget.tabs;
    if (!widget.isRouter && widget.renderContent != null) {
      _body = widget.renderContent(_tabsData[_index], _index);
    }
  }

  @override
  void initState() {
    _index = widget.active;
    super.initState();
    init();
  }

  void setIndex(index) {
    _index = index;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant YsTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    init();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _tabs = [];
    bool _hasBorder = widget.type == TabsType.card ? false : widget.hasBorder;
    // item
    _getButton(item, isActive) {
      Map _size = {
        'large': 44.0,
        'medium': 36.0,
        'small': 32.0,
        'mini': 28.0,
      };
      if (widget.type == TabsType.card) {
        return Container(
          color: isActive ? Color(0xffEAF4FF) : Color(0xffF2F2F2),
          height: _size[widget.size],
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 9, right: 9),
          child: Text(
            item['type_name'],
            style: TextStyle(
              fontSize: 13,
              color: isActive ? Colours.text_primary : Colours.text_info,
            ),
          ),
        );
      } else if (widget.type == TabsType.capsule) {
        BoxDecoration _decoration = BoxDecoration(
          color: isActive ? Color(0xff000000) : Colors.white,
          border: Border.all(color: isActive ? Colors.white : Color(0xffdddddd), width: .5),
          borderRadius: BorderRadius.all(Radius.circular(_size[widget.size])),
        );
        return Container(
          decoration: _decoration,
          height: _size[widget.size],
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Text(
            item['type_name'],
            style: TextStyle(
              fontSize: 13,
              color: isActive ? Colors.white : Colours.text_info,
            ),
          ),
        );
      } else if (widget.type == TabsType.bgcard) {
        return Container(
          decoration: BoxDecoration(
            color: isActive ? Color(0xffEAF4FF) : Color(0xffF2F2F2),
            border: Border(
              bottom: BorderSide(
                color: isActive ? Colours.primary : Color(0xffF2F2F2),
                width: 2,
              ),
            ),
          ),
          height: _size[widget.size],
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Text(
            item['type_name'] ?? '',
            style: TextStyle(
              fontSize: 13,
              color: isActive ? Colours.text_primary : Colours.text_info,
            ),
          ),
        );
      }
      return Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colours.primary : Colors.white,
              width: 2,
            ),
          ),
        ),
        child: Text(
          item['type_name'] ?? '',
          style: TextStyle(
            fontSize: {'medium': 16.0, 'small': 14.0, 'mini': 12.0}[widget.size],
            fontWeight: FontWeight.bold,
            color: isActive ? Colours.text_info : Colours.text_muted,
          ),
        ),
      );
    }

    Utils.forEach(_tabsData, (item, i) {
      final isActive = _index == i;
      _tabs.add(
        InkWell(
          child: _getButton(item, isActive),
          onTap: () {
            if (!isActive) {
              setIndex(i);
              if (widget.onPressed != null) {
                widget.onPressed(item, _index);
                // Routers.go(context, item['type_id']);
              }
              if (widget.renderContent != null) {
                _body = widget.renderContent(item, _index);
              }
              setState(() {});
            }
          },
        ),
      );

      if (widget.type != TabsType.bgcard) {
        _tabs.add(SizedBox(width: 10));
      }
    });
    List<Widget> children = [];
    if (widget.type == TabsType.bgcard) {
      children.add(Container(
        color: Color(0xffF2F2F2),
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
            children: _tabs,
          ),
        ),
      ));
    } else {
      children.add(Row(
        mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.start,
        children: _tabs,
      ));
    }
    if (_hasBorder) {
      children.add(Divider());
    }
    if (_body != null) {
      // 内容有滚动时需要Expanded
      if (widget.contentScroll) {
        children.add(Expanded(child: _body!));
      } else {
        children.add(_body!);
      }
    }
    return Container(
      padding: widget.padding ?? EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
