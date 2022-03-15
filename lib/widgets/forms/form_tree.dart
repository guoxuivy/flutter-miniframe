import 'package:agent/net/http_manager.dart';
import 'package:agent/net/result.dart';
import 'package:agent/res/colors.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:agent/widgets/ys_icon.dart';

// select
class FormTree extends StatefulWidget {
  final String placeholder;
  final bool enabled;
  final List? data;
  final value;
  final onChanged;

  FormTree({
    Key? key,
    this.placeholder = '请选择',
    this.enabled = true,
    this.data,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormTreeState();
  }
}

class FormTreeState extends State<FormTree> {
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

  _getItems({required List data, int level = 0,required List value, setDialogState}) {
    List<Widget> _children = [];
    for (var i = 0; i < data.length; i++) {
      var item = data[i];
      Map activeItem = value.singleWhere(
            (it) => it['type_id'] == item['type_id'],
        orElse: () => <String, dynamic>{},
      );
      bool _isActive = activeItem.isNotEmpty;
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
                item['type_name'] ?? '',
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
              value.add(Map<String, dynamic>.from(item));
            } else {
              final _last = value[value.length - 1];
              if ((_last['index'] ?? 0) > i) {
                value.insert(0, Map<String, dynamic>.from(item));
              } else {
                value.add(Map<String, dynamic>.from(item));
              }
            }
            /* if (level == 0 && item['children'].length == 0) {
                //子集
                _getChildren(item, (_data) {
                  item['children'] = _data ?? [];
                  setDialogState(() {});
                });
              } */
          }
          setDialogState(() {});
        },
      ));
      // 自动加载二级
      // if (level == 0 && item['children'] == 0 && _isActive) {
      // item['requested'] 保证只请求一次
      if (level == 0 && item['requested'] == null && _isActive) {
        _getChildren(item, (_data) {
          item['children'] = _data ?? [];
          item['requested'] = 1;
          setDialogState(() {});
        });
      }
      // 无限处理
      if (level < 1) {
        _children.addAll(_getItems(
          data: item['children'],
          value: item['selectedChildren'],
          setDialogState: setDialogState,
          level: level + 1,
        ));
      }

      if (level == 0) {
        _children.add(Divider(height: 1));
      }
    }
    return _children;
  }
  _showModal(context) {

    Dialogs.bottomPop(
      title: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text('取消'),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  '请选择',
                  style: TextStyle(fontSize: 16, color: Color(0xff3333333)),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                widget.onChanged(_value);
                Navigator.pop(context);
                setState(() {});
              },
              child: Text('确认'),
            ),
          ],
        ),
      ),
      updateState: true,
      bodyPadding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      body: (setDialogState) => Column(
        children: _getItems(
          data: widget.data??[],
          value: _value,
          setDialogState: setDialogState,
        ),
      ),
    );
  }

  _getTitles(List val) {
    List titles = [];
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
  void didUpdateWidget(covariant FormTree oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 180,
        child: Text(
          _value.length > 0 ? _getTitles(_value).join(',') : widget.placeholder,
          style: TextStyle(color: _value.length > 0 ? Colours.text_info : Colours.text_muted),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
        ),
      ),
      onTap: () {
        _showModal(context);
      },
    );
  }

  @override
  void dispose() {
    // 释放
    // controller.dispose();
    super.dispose();
  }
}
