import 'package:agent/net/http_manager.dart';
import 'package:agent/net/result.dart';
import 'package:agent/res/colors.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:flutter/material.dart';

// select
class FormPosition extends StatefulWidget {
  final String? placeholder;
  final bool enabled;
  final List? value;
  final int level;
  final onChanged;

  FormPosition({
    Key? key,
    this.placeholder,
    this.enabled = true,
    this.value,
    this.level = 4,
    this.onChanged,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormPositionState();
  }
}

class FormPositionState extends State<FormPosition> {
  List _value = [];
  Map _datas = {};
  _onChanged() {
    if (widget.onChanged != null) {
      // 最后一级的数据, 增加需求时可能用
      // List _lastDatas = _datas[_value[_value.length - 1]] ?? [];
      widget.onChanged(
        _value,
        // _lastDatas,
      );
    }

    // setState(() {});
  }

  _initValue() async {
    _value = widget.value ?? _value;
    await _getDatas(value: _value);

    setState(() {});
    // _onChanged();
  }

  @override
  void didUpdateWidget(covariant FormPosition oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    _initValue();
  }

  // 省市区镇
  _getDatas({List? value}) async {
    List urls = [
      '/agentmobileapi/ajax/getProvince',
      '/agentmobileapi/ajax/getCity',
      '/agentmobileapi/ajax/getRegion',
      '/agentmobileapi/ajax/getTown',
    ];
    final ajax = HttpManager.instance;
    List _vals = [0];
    if(value!=null){
      _vals.addAll(value);
    }
    for (var i = 0; i < _vals.length; i++) {
      var val = _vals[i];
      // 最后一级不处理, 最多到4级
      if (_datas[val] == null && i < 4) {
        Result result = await ajax.get(urls[i], data: {
          'code': val,
        });
        var d = result.data.d;
        _datas[val] = d;
      }
    }
  }

  _getItem({onTap, item}) {
    bool isSelected = _value.contains(item['code']);
    return InkWell(
      child: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(top: 10, left: 10, right: 5, bottom: 10),
        child: Text(
          item['name'],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 15,
            color: isSelected ? Colours.text_primary : Colours.text_info,
          ),
        ),
      ),
      onTap: onTap,
    );
  }

  _showModal(context) {
    Dialogs.bottomPop(
      updateState: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          YsButton(
            text: true,
            height: 42,
            size: 'small',
            width: 60,
            title: '取消',
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          Text('请选择'),
          YsButton(
            text: true,
            height: 42,
            size: 'small',
            width: 60,
            title: '确认',
            onPressed: () {
              // 必须选择到最后一级
              if (_value.length < widget.level) {
                return;
              }
              Navigator.of(context).pop();
              _onChanged();
            },
          ),
        ],
      ),
      body: (setDialogsState) {
        //列
        List<Widget> _children = [];
        List _vals = [0, ..._value];
        // 最后一级不处理
        for (var i = 0; i < _vals.length; i++) {
          var v = _vals[i];
          // 列里面的项
          List<Widget> _items = [];

          // if (_datas[v] == null || i >= widget.level) {
          // 按级数显示列
          if (i >= widget.level) {
            break;
          }
          Utils.forEach(_datas[v], (item, j) {
            _items.add(_getItem(
              item: item,
              onTap: () async {
                // 取已选择的数据，后面的数据清除
                _value = _value.sublist(0, i);
                _value.add(item['code']);
                await _getDatas(value: _value);
                setDialogsState(() {});
              },
            ));

            _items.add(Divider(height: 1));
          });
          _children.add(Container(
            decoration: BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xffeeeeee), width: .5)),
            ),
            height: 250,
            width: (MediaQuery.of(context).size.width - 0) / widget.level,
            child: SingleChildScrollView(
              child: Column(
                children: _items,
              ),
            ),
          ));
        }
        return Row(
          children: _children,
        );
      },
    );
  }

  _getTitles(vals) {
    List _title = [];
    List _vals = [0, ...vals];
    // 最后一级不处理
    for (var i = 0; i < _vals.length - 1; i++) {
      var val = _vals[i];
      if (_datas[val] != null) {
        _title.add(_datas[val]
            .singleWhere((item) => item['code'] == _vals[i + 1], orElse: () => {})['name']);
      }
    }
    return _title;
  }

  @override
  void initState() {
    super.initState();
    // 初始化value
    _value = widget.value ?? [];
    _initValue();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        width: 180,
        child: Text(
          !Utils.listIsEmpty(_value) ? _getTitles(_value).join(',') : widget.placeholder,
          style: TextStyle(
              color: (!Utils.listIsEmpty(_value) && widget.enabled)
                  ? Colours.text_info
                  : Colours.text_muted),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
        ),
      ),
      onTap: () {
        if (widget.enabled) {
          _showModal(context);
        }
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
