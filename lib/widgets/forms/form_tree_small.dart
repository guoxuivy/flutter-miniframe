import 'package:agent/net/http_manager.dart';
import 'package:agent/net/result.dart';
import 'package:agent/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:agent/widgets/ys_icon.dart';

// select
class FormTreeSmall extends StatefulWidget {
  final String placeholder;
  final bool enabled;
  final List? data;
  final value;
  final onChanged;

  FormTreeSmall({
    Key? key,
    this.placeholder = '请选择',
    this.enabled = true,
    this.data,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormTreeSmallState();
  }
}

class FormTreeSmallState extends State<FormTreeSmall> {
  // 楼层
  _getChildren(item, cb) async {
    final ajax = HttpManager.instance;
    Result result =
        await ajax.get('/agentapi/Floor/getSimpleByBID', data: {'building_id': item['type_id']});
    List _data = [];
    if (result['list'].d != null) {
      for (var i = 0; i < result['list'].d.length; i++) {
        final _item = result['list'].d[i];
        _data.add({
          'index': i,
          'type_id': _item['id'],
          'type_name': _item['number'].toString() + '层',
          'floor_total_area': _item['total_area'],
          'floor_id': _item['id'],
          'floor_name': _item['number'].toString() + '层',
          // 'building_id': item['type_id'],
          'building_name': item['type_name'],
          // 'building_total_area': item['total_area'],
          // 'building_total_floor': item['total_floor'],
          ..._item
        });
      }
    }
    if (cb != null) {
      cb(_data);
    }
  }

  List _value = [];

  _getTitles(List val) {
    List titles = [];
    if(widget.data==null){
      return titles;
    }
    for (var d in widget.data!) {
      for (var v in val) {
        if (v['type_id'] == d['type_id']) {
          titles.add(d['type_name']);
        }
      }
    }
    return titles;
  }

  _init() {
    // 初始化value
    _value = widget.value is List ? widget.value : [];
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant FormTreeSmall oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    _getItems({required List data, int level = 0, required List value}) {
      List<Widget> _children = [];

      for (var i = 0; i < data.length; i++) {
        var item = data[i];
        var activeItem = value.singleWhere(
          (it) => it['type_id'] == item['type_id'],
          orElse: () => null,
        );

        bool _isActive = activeItem != null;

        item.addAll({
          'index': i,
          'children': item['children'] ?? (_isActive ? activeItem['children'] : []),
          'selectedChildren':
              item['selectedChildren'] ?? (_isActive ? activeItem['selectedChildren'] : []),
        });

        // 一级
        _children.add(InkWell(
          child: Container(
            padding: level == 0
                ? EdgeInsets.only(top: 10, bottom: 10)
                : EdgeInsets.only(top: 5, bottom: 5, left: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _isActive
                    ? YsIcon(
                        src: '&#xe614;',
                        color: Colours.primary,
                      )
                    : YsIcon(
                        src: '&#xe606;',
                      ),
                SizedBox(width: 5),
                Text(
                  item['type_name'],
                  style: TextStyle(fontSize: 15, color: Color(0xff333333)),
                ),
                SizedBox(width: 12),
              ],
            ),
          ),
          onTap: () {
            if (_isActive) {
              value.removeWhere((it) => it['type_id'] == item['type_id']);
              item['selectedChildren'] = [];
            } else {
              // 保证选中后的顺序
              if (value.length == 0) {
                value.add(item);
              } else {
                final _last = value[value.length - 1];
                if ((_last['index'] ?? 0) > i) {
                  value.insert(0, item);
                } else {
                  value.add(item);
                }
              }
            }
            setState(() {});
          },
        ));
      }
      return _children;
    }

    return Column(
      children: _getItems(
        data: [
          {'type_id': -999, 'type_name': '整栋'},
          {'type_id': -3, 'type_name': '-3层'},
          {'type_id': -2, 'type_name': '-2层'},
          {'type_id': -1, 'type_name': '-1层'},
          {'type_id': 1, 'type_name': '1层'},
          {'type_id': 2, 'type_name': '2层'},
          {'type_id': 3, 'type_name': '3层'},
        ],
        value: _value,
      ),
    );
  }

  @override
  void dispose() {
    // 释放
    // controller.dispose();
    super.dispose();
  }
}
