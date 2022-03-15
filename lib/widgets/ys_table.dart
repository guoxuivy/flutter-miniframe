import 'package:agent/res/colors.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/utils/field_title.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/ys_alert.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:flutter/material.dart';

class YsTable extends StatelessWidget {
  final double fontSize;
  final double? labelWidth;
  final String labelPosition;
  final EdgeInsets? itemPadding;
  final EdgeInsets? padding;
  final TextAlign textAlign;
  final bool hasBorder;
  final bool hasArrow;
  final Map data;
  final List<Map<String, dynamic>> items;
  final Color? color;
  // 不能自动获取，手动设置，可能会出现溢出
  final double? itemWidth;
  final MainAxisAlignment? mainAxisAlignment;

  YsTable({
    this.fontSize = 15,
    this.labelWidth, //每项左边label宽度
    this.labelPosition = 'left', //
    this.textAlign = TextAlign.start, //每项label右侧对其方式
    this.itemPadding, //每项之间bottom间距
    this.padding,
    this.hasBorder = false, //是否有borderBottom
    this.hasArrow = false, //是否有borderBottom
    data,
    items,
    this.color,
    this.itemWidth,
    this.mainAxisAlignment,
  })  : data = data ?? {},
        items = items ?? [];

  Widget _getChild(item, context) {
    List<Widget> _children = [];
    // label
    if (item['label'] != null) {
      _children.add(Container(
        width: labelWidth,
        child: Text(
          item['label'],
          style: TextStyle(fontSize: fontSize, color: Colours.text_muted),
        ),
      ));
    }
    // value
    String? _type = item['type'];
    String? _prop = item['prop'];
    var _value = data[_prop];
    if (_prop != null) {
      // 支持.选择
      List _lProp = _prop.split('.');
      if (_lProp.length == 1) {
        _value = data[_lProp[0]];
      } else if (_lProp.length == 2 && data[_lProp[0]] != null) {
        _value = data[_lProp[0]][_lProp[1]];
      }
    }
    Widget _itemValue;
    // if (_type == 'render') {
    if (item['render'] != null) {
      // render
      _itemValue = item['render'](_value ?? '', data);
    } else if (_type == 'date' || _type == 'dateTime') {
      // date
      var _format = 'yyyy-MM-dd HH:mm:ss';
      if (_type == 'date') {
        _format = 'yyyy-MM-dd';
      }
      _itemValue = Text(Utils.date(_value, _format));
    } else if (_type == 'fieldTitle') {
      // fieldTitle
      _itemValue = fieldTitle(
        value: _value,
        prop: item['alias'] ?? _prop,
        data: item['data'] ?? [],
        render: (it) => Text(
          '${item['prefix'] ?? ''} ${it['type_name']} ${item['suffix'] ?? ''}',
          style: TextStyle(color: it['color']),
        ),
      );
    } else if (_type == 'image') {
      _value = _value ?? [];
      if (_value is String) {
        _value = [_value];
      }
      List<Widget> _items = [];
      for (var i = 0; i < _value.length; i++) {
        final v = _value[i];
        _items.add(GestureDetector(
          child: Image.network(
            Utils.imgUrl(v),
            fit: BoxFit.fill,
          ),
          onTap: () {
            Routers.go(context, '/image_preview', {
              'items': _value,
              'initialIndex': i,
            });
          },
        ));
      }
      _itemValue = GridView(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: item['crossAxisCount'] ?? 4,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: item['childAspectRatio'] ?? 1,
        ),
        children: _items,
        physics: NeverScrollableScrollPhysics(), //禁止滚动
      );
    } else {
      // text
      _value = (_value != null && _value != '') ? _value : '--';
      _itemValue = Text(
        '${item['prefix'] ?? ''} $_value ${item['suffix'] ?? ''}',
        style: TextStyle(fontSize: fontSize, color: item['color']),
      );
    }

    // 布局
    Widget _child;
    if (labelPosition == 'top' || _type == 'image' || item['labelPosition'] == 'top') {
      _children.add(SizedBox(height: 5));
      _children.add(_itemValue);
      _child = Container(
        // height: _type == 'image' ? 120 : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _children,
        ),
      );
    } else {
      if (mainAxisAlignment == MainAxisAlignment.spaceBetween) {
        _children.add(Spacer());
        _children.add(_itemValue);
      } else {
        _children.add(Expanded(
          child: _itemValue,
        ));
      }
      bool hasArrow = item['hasArrow'] ?? false;
      if (hasArrow) {
        _children.add(YsIcon(
          src: '&#xe627;',
          color: Colours.muted,
          size: 13,
        ));
      }
      _child = Row(
        // hasArrow 有箭头的要居中显示
        crossAxisAlignment: hasArrow ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: _children,
      );
    }
    return Container(
      width: item['width'] ?? itemWidth ?? double.infinity,
      decoration: BoxDecoration(
        // color: Colors.black,
        border: hasBorder ? Border(bottom: BorderSide(color: Color(0xffeeeeee), width: 0.5)) : null,
      ),
      padding: itemPadding != null ? itemPadding : EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: _child,
    );
  }

  bool _getShow(item, data) {
    if (item['show'] is Function) {
      return item['show'](data ?? {});
    } else {
      return item['show'] ?? true;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Container(
        padding: padding ?? EdgeInsets.all(0),
        child: YsAlert(),
        // child: Column(mainAxisSize: MainAxisSize.min, children: _children),
      );
    }
    List<Widget> _children = [];
    for (var item in items) {
      final _show = _getShow(item, data);
      String _type = item['type']??'';
      if (_show) {
        if (_type == 'block') {
          if (item['render'] != null) {
            _children.add(item['render']());
          }
        } else if (_type == 'line') {
          _children.add(Divider(height: 10));
        } else {
          _children.add(_getChild(item, context));
        }
      }
    }
    return Container(
      color: color,
      padding: padding ?? EdgeInsets.all(0),
      child: Wrap(
        children: _children,
      ),
      // child: Column(mainAxisSize: MainAxisSize.min, children: _children),
    );
  }
}
