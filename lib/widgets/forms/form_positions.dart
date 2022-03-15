import 'package:agent/net/http_manager.dart';
import 'package:agent/net/result.dart';
import 'package:agent/res/colors.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:agent/widgets/ys_tabs.dart';
import 'package:flutter/material.dart';

// select
class FormPositions extends StatefulWidget {
  final String placeholder;
  final bool enabled;
  final value;
  final List? position;
  final onChanged;

  FormPositions({
    Key? key,
    this.placeholder = '请选择',
    this.enabled = true,
    this.value,
    this.position,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormPositionsState();
  }
}

class FormPositionsState extends State<FormPositions> {
  List _value = List.filled(3, null);
  // 区数据
  List _data = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void didUpdateWidget(covariant FormPositions oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    init();
  }

  init() {
    // 初始化value
    if (!Utils.isEmpty(widget.value)) {
      for (var i = 0; i < 3; i++) {
        _value[i] = widget.value.length > i ? widget.value[i] : null;
      }
    }
  }

  _getData() async {
    if (widget.position != null) {
      final ajax = HttpManager.instance;
      Result result = await ajax.get('/agentmobileapi/ajax/getRegion', data: {
        'code': widget.position![widget.position!.length - 1],
      });
      _data = result.data.d;
    }
  }

  // 过滤后的值
  _getFilteredValue(v) {
    return v.where((e) => e != null).toList();
  }

  _showModal(context) {
    int _tabIndex = 0;
    Dialogs.bottomPop(
      updateState: true,
      title: (setDialogState) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          YsTabs(
            padding: EdgeInsets.only(left: 15),
            tabs: [
              {'type_id': 0, 'type_name': '首选区域'},
              {'type_id': 1, 'type_name': '次选区域'},
              {'type_id': 2, 'type_name': '备选区域'},
            ],
            onPressed: (item, index) {
              _tabIndex = index;
              setDialogState(() {});
            },
          ),
          YsButton(
            title: '确定',
            text: true,
            width: 60,
            size: 'small',
            onPressed: () {
              List _valueNew = _getFilteredValue(_value);
              if (widget.onChanged != null && _valueNew.length > 0) {
                widget.onChanged(_valueNew);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: (setDialogState) {
        List<Widget> _children = [];
        Utils.forEach(_data, (item, i) {
          bool isSelected = _value[_tabIndex] == item['name'];
          bool disabled = !isSelected && _value.contains(item['name']);
          _children.add(
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      item['name'],
                      style: TextStyle(
                        fontSize: 15,
                        color: disabled
                            ? Color(0xffdddddd)
                            : (isSelected ? Colours.text_primary : Colours.text_info),
                      ),
                    ),
                    SizedBox(width: 5),
                    isSelected
                        ? YsIcon(
                            src: '&#xe621;',
                            color: Colours.primary,
                          )
                        : Container(),
                  ],
                ),
              ),
              onTap: () {
                // 已选择的不再选
                if (_value.contains(item['name'])) {
                  return;
                }
                // 取已选择的数据，后面的数据清除
                _value[_tabIndex] = item['name'];
                // print(_value);
                setDialogState(() {});
              },
            ),
          );
          _children.add(Divider(height: 1));
        });
        return Container(
          height: 300,
          padding: EdgeInsets.only(left: 15, top: 5, right: 15, bottom: 5),
          child: SingleChildScrollView(
            child: Column(
              children: _children,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isSet = !Utils.listIsEmpty(_value); // ? _value.every((item) => item != null) : false;
    return InkWell(
      child: Container(
        width: 180,
        child: Text(
          isSet ? _getFilteredValue(_value).join(',') : widget.placeholder,
          style: TextStyle(color: isSet ? Colours.text_info : Colours.text_muted),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
        ),
      ),
      onTap: () async {
        await _getData();
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
