import 'package:agent/res/colors.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:agent/widgets/ys_icon.dart';

// select
class FormMultiSelect extends StatefulWidget {
  final String placeholder;
  final bool enabled;
  final List? data;
  final value;
  final onChanged;

  FormMultiSelect({
    Key? key,
    this.placeholder = '请选择',
    this.enabled = true,
    this.data,
    this.value,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormMultiSelectState();
  }
}

class FormMultiSelectState extends State<FormMultiSelect> {
  List _value = [];
  _onChanged(val) {
    if (_value.contains(val)) {
      _value.remove(val);
    } else {
      _value.add(val);
    }
  }

  showModal(context) {
    _getChildren(setDialogState) {
      List<Widget> _children = [];
      for (var item in widget.data!) {
        _children.add(
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _value.contains(item['type_id'])
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
              _onChanged(item['type_id']);
              setDialogState(() {});
            },
          ),
        );
        _children.add(Divider(height: 1));
      }
      return _children;
    }

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
        children: _getChildren(setDialogState),
      ),
    );
  }

  _getTitles(List val) {
    List titles = [];
    List<String?> _keys = val.map((e) {
      if (e is Map) {
        var _e = e as Map<String, dynamic>;
        if (_e.containsKey('id')) {
          return _e['id'].toString();
        }
      } else {
        return e.toString();
      }
    }).toList();
    for (var d in widget.data!) {
      if (_keys.contains(d['type_id'].toString())) {
        titles.add(d['type_name']);
      }
    }
    return titles;
  }

  @override
  void initState() {
    super.initState();
    // 初始化value
    _value = widget.value is List ? widget.value : [];
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) {
      return Text('请设置data');
    }
    // controller.text = widget.value;
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
        showModal(context);
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
