import 'dart:ui';
import 'package:agent/res/colors.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/forms/form_date.dart';
import 'package:agent/widgets/simple_area_filter.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:flutter/material.dart';
import 'package:agent/widgets/address_picker.dart';

class FilterBarController {
  FilterBarController();
  var index = -999;
  hide() {
    index = -999;
  }

  dispose() {}
}

class YsFilterBar extends StatefulWidget {
  final Widget child;
  final Widget? prepend;
  final Widget? append;
  final onChange;
  final List options;
  final Map<String, dynamic>? params;
  final MainAxisAlignment? mainAxisAlignment;

  YsFilterBar({
    Key? key,
    required this.child,
    this.prepend,
    this.append,
    this.onChange,
    required this.options,
    this.params,
    this.mainAxisAlignment,
  }) : super(key: key);

  @override
  YsFilterBarState createState() => YsFilterBarState();
}

class YsFilterBarState extends State<YsFilterBar> {
  List<Map> _barItemsData = [];

  FilterBarController _filterBarController = FilterBarController();

  Map<String, dynamic> _params = {};
  // bar的高
  double _barHeight = 40;
  // 处理默认数据和bardata
  init(opts, [lvl = 0]) {
    int activeNum = 0;
    for (var i = 0; i < opts.length; i++) {
      final _option = opts[i];
      if (Utils.isEmpty(_option)) {
        continue;
      }
      final List _items = _option['items'] ?? [];
      final String _type = _option['type'] ?? 'select';
      if (_type == 'render') {
        _barItemsData.add(_option);
        break;
      }
      String _prop = _option['prop'] ?? '';
      bool active = false;

      if (_items.isNotEmpty) {
        // more
        active = init(_items, lvl + 1);
      } else if (['checkbox', 'area'].contains(_type)) {
        // 数组相关处理
        _params[_prop] = _params[_prop] ?? (_type == 'area' ? <String>[] : []);
        active = _params[_prop].length > 0;
      } else {
        // 其它
        active = !(_params[_prop] == '-999' || _params[_prop] == null);
      }
      // 第一级时处理
      if (lvl == 0) {
        _barItemsData.add({
          'type_id': '-999',
          'type_name': _option['label'],
          'active': active,
          'width': _option['width']
        });
      }
      // 把已选中的累加
      if (active) {
        activeNum++;
      }
    }
    return activeNum > 0;
  }

  @override
  void initState() {
    super.initState();
    _params.addAll(widget.params ?? {});
    init(widget.options);
  }

  //
  List<Widget> barItems(items) {
    List<Widget> _barItems = [];
    for (var i = 0; i < items.length; i++) {
      var item = items[i];
      bool _isActive = _filterBarController.index == i;
      // 平均分 6 是父级的padding
      double _width = (MediaQuery.of(context).size.width - 6) / items.length;
      if (item['type'] == 'render') {
        _barItems.add(item['render']());
      } else {
        _barItems.add(GestureDetector(
          child: Container(
            alignment: Alignment.center,
            width: item['width'] ?? _width,
            // height: _barHeight,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: _width - 12, //设置最大高度（必要）
                  ),
                  child: Text(
                    item['type_name'],
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: (item['active'] || _isActive) ? Colours.primary : Colours.info,
                    ),
                  ),
                ),
                SizedBox(width: 5),
                YsIcon(
                  src: _isActive ? '&#xe712;' : '&#xe61c;',
                  color: (item['active'] || _isActive) ? Colours.primary : Colours.muted,
                  size: 6,
                )
              ],
            ),
          ),
          onTap: () {
            if (_isActive) {
              _filterBarController.index = -999;
            } else {
              _filterBarController.index = i;
            }
            setState(() {});
          },
        ));
      }
    }
    return _barItems;
  }

  // 弹窗内容
  Widget barContent() {
    Widget _content;
    Map _option = widget.options[_filterBarController.index];
    // 更多时的items
    final List _items = _option['items'] ?? [];

    if (_items.isNotEmpty) {
      _content = _buildMoreWidget(_option);
    } else if (_option['type'] == 'date') {
      _content = _buildDateWidget(_option);
    } else if (_option['type'] == 'checkbox') {
      _content = _buildCheckboxWidget(_option);
    } else if ((_option['type'] == 'radio')) {
      _content = _buildRadioWidget(_option);
    } else if ((_option['type'] == 'area')) {
      _content = _buildAreaWidget(_option);
    } else {
      // select
      _content = _buildSelectWidget(_option);
    }
    return _content;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        // 注意列表顺序
        // filterbar
        Container(
          height: _barHeight - 1,
          padding: EdgeInsets.only(left: 3, right: 3),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[200]!, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
            children: barItems(_barItemsData),
          ),
        ),
        // 页面内容
        Container(
          margin: EdgeInsets.only(top: _barHeight),
          width: double.infinity,
          child: widget.child,
        ),
        widget.append ?? Container(),
        // 弹窗遮罩层
        _filterBarController.index != -999
            ? GestureDetector(
                onTap: () {
                  _filterBarController.index = -999;
                  setState(() {});
                },
                child: Container(
                  margin: EdgeInsets.only(top: _barHeight),
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black.withOpacity(.5),
                  child: Container(),
                ),
              )
            : Container(),
        // 内容
        _filterBarController.index != -999
            ? Container(
                margin: EdgeInsets.only(top: _barHeight),
                width: double.infinity,
                color: Colors.white,
                child: barContent(),
              )
            : Container(),
      ],
    );
  }

  _onChange() {
    if (widget.onChange != null) {
      widget.onChange(_params);
      setState(() {});
      // widget.onChange({_option['prop']: _params[_option['prop']]});
    }
  }

  _buildMoreWidget(_option) {
    int index = _filterBarController.index;
    List<Widget> items = [];
    int activeNum = 0;
    for (var i = 0; i < _option['items'].length; i++) {
      final item = _option['items'][i];
      if (item == null || item.isEmpty) {
        continue;
      }
      final _prop = item['prop'];
      Widget wItem;
      if (item['type'] == 'checkbox') {
        wItem = Fcheckbox(
          data: item['data'],
          label: item['label'],
          subLabel: item['subLabel'],
          value: _params[_prop],
          noneValue: item['noneValue'],
          onChange: (value) {
            _params[_prop] = value;
            setState(() {});
          },
        );
      } else {
        wItem = Fradio(
          data: item['data'],
          label: item['label'],
          value: _params[_prop],
          onChange: (value, p) {
            if (_params[_prop] == value) {
              _params[_prop] = '-999';
            } else {
              _params[_prop] = value;
            }
            setState(() {});
            // 有额外的参数需要一并加入
            if (p != null) {
              _params.addAll(p);
            }
          },
        );
      }
      items.add(wItem);
      // 选中时统计一次
      if (!(_params[_prop] == '-999' || _params[_prop] == null)) {
        activeNum++;
      }
    }
    _barItemsData[index]['active'] = activeNum > 0;
    return Fpopup(
      child: Column(
        children: items,
      ),
      onReset: () {
        // _params[_option['prop']] = [];
        for (var i = 0; i < _option['items'].length; i++) {
          final item = _option['items'][i];
          if (item['type'] == 'checkbox') {
            _params[item['prop']] = [];
          } else {
            _params[item['prop']] = '-999';
          }
        }

        setState(() {});
      },
      onSubmit: () {
        _filterBarController.hide();
        _onChange();
      },
    );
  }

  _buildRadioWidget(_option) {
    return Fpopup(
      child: Fradio(
        data: _option['data'],
        label: _option['label'],
        value: _params[_option['prop']],
        onChange: (value, p) {
          _params[_option['prop']] = value;
          setState(() {});
        },
      ),
      onReset: () {
        _params[_option['prop']] = '-999';
        setState(() {});
      },
      onSubmit: () {
        _filterBarController.hide();
        _onChange();
      },
    );
  }

  _buildCheckboxWidget(_option) {
    return Fpopup(
      child: Fcheckbox(
        data: _option['data'],
        label: _option['label'],
        value: _params[_option['prop']],
        onChange: (value) {
          _params[_option['prop']] = value;
          setState(() {});
        },
      ),
      onReset: () {
        _params[_option['prop']] = [];
        setState(() {});
      },
      onSubmit: () {
        _filterBarController.hide();
        _onChange();
      },
    );
  }

  _buildAreaWidget(_option) {
    double h = (_option as Map).containsKey('height') ? _option['height'] : 190.0;
    // 简单地址选择　or Area Picker
    bool _isSimple = true;
    if (_isSimple) {
      return Fpopup(
        child: SimpleAreaFilter(
            label: _option['label'],
            value: _params[_option['prop']],
            onChange: (value) {
              //trace('_buildAreaWidget: ' + value.toString());
              _params[_option['prop']] = value;
              setState(() {});
            },
            useUserFilter: _option['userFilter'] != null && _option['userFilter'] == true),
        onReset: () {
          _params[_option['prop']] = <String>[];
          setState(() {});
        },
        onSubmit: () {
          _filterBarController.hide();
          _onChange();
        },
        height: h,
      );
    } else {
      return FBlock(
        child: AddressPicker(
            label: _option['label'],
            value: _params[_option['prop']],
            onChange: (value) {
              //trace('_buildAreaWidget: ' + value.toString());
              _params[_option['prop']] = value;
              //setState(() {});
            },
            height: h,
            useUserFilter: _option['userFilter'] != null && _option['userFilter'] == true),
        onReset: () {
          _params[_option['prop']] = <String>[];
          setState(() {});
        },
        onSubmit: () {
          setState(() {});
          if (_filterBarController != null) {
            _filterBarController.hide();
          }
          _onChange();
        },
        height: h,
      );
    }
  }

  List _dataValue = ['', ''];
  // date
  _buildDateWidget(_option) {
    var _now = DateTime.now();
    String _today = '${_now.year}-${_now.month}-${_now.day}';
    String _yesterday = '${_now.year}-${_now.month}-${_now.day - 1}';
    _option.addAll({
      'data': [
        {'type_id': '$_today|$_today', 'type_name': '今天'},
        {'type_id': '$_yesterday|$_yesterday', 'type_name': '昨天'},
        {
          'render': () {
            return Container(
              padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FormDate(
                    value: _dataValue[0],
                    padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                    placeholder: '开始时间',
                    border: true,
                    onChanged: (v, [isInit]) {
                      _dataValue[0] = v;
                      if (!isInit) {
                        setState(() {});
                      }
                    },
                  ),
                  Text('至'),
                  FormDate(
                    value: _dataValue[1],
                    padding: EdgeInsets.only(left: 30, right: 30, top: 10, bottom: 10),
                    placeholder: '结束时间',
                    border: true,
                    onChanged: (v, [isInit]) {
                      _dataValue[1] = v;
                      if (!isInit) {
                        setState(() {});
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
      ]
    });
    // return _buildSelectWidget(_option);
    return Fpopup(
      child: Column(
        children: [_buildSelectWidget(_option)],
      ),
      onReset: () {
        _params[_option['prop']] = [];
        _dataValue = ['', ''];
        setState(() {});
      },
      onSubmit: () {
        _params[_option['prop']] = _dataValue.join('|');
        _filterBarController.hide();
        _onChange();
      },
    );
  }

  _buildSelectWidget(_option) {
    int i = _filterBarController.index;
    final _prop = _option['prop'];
    return ListView.separated(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemCount: _option['data'].length,
      // item 的个数
      separatorBuilder: (BuildContext context, int index) => Divider(height: 1.0),
      // 添加分割线
      itemBuilder: (BuildContext context, int index) {
        Map item = _option['data'][index];
        if (item['render'] != null) {
          return item['render']();
        }
        final bool _active = _params[_prop] == item['type_id'];
        return InkWell(
          onTap: () {
            if (_active) {
              // 选中时再次点击取消选中
              _barItemsData[i] = {
                'type_id': '-999',
                'type_name': _option['label'],
                'active': false,
              };
              _params[_prop] = '-999';
            } else {
              // _dropDownHeaderItems[i]['label'] =
              // item['type_id'] == '-999' ? _option['label'] : item['type_name'];
              _barItemsData[i] = {
                ...item,
                'active': true,
              };
              _params[_prop] = item['type_id'];
              if (item['params'] != null) {
                _params.addAll(item['params']);
              }
            }
            _filterBarController.hide();
            _onChange();
          },
          child: Container(
            height: 40,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                Expanded(
                  child: Text(
                    item['type_name'],
                    style: TextStyle(
                      color: _active ? Colours.primary : Colours.info,
                    ),
                  ),
                ),
                _active
                    ? Icon(
                        Icons.check,
                        color: Colours.primary,
                        size: 16,
                      )
                    : SizedBox(),
                SizedBox(
                  width: 16,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    // 释放
    _filterBarController.dispose();
    super.dispose();
  }
}

class Fpopup extends StatelessWidget {
  final Widget? child;
  final onReset;
  final onSubmit;
  final double? height;

  Fpopup({
    Key? key,
    this.child,
    this.onReset,
    this.onSubmit,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            constraints: BoxConstraints(
              minHeight: 0,
              maxHeight: MediaQuery.of(context).size.height * 0.6 - 60, //设置最大高度（必要）
            ),
            child: SingleChildScrollView(
              child: child,
            ),
          ),
          Divider(height: 1),
          SizedBox(height: 5),
          Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              YsButton(
                padding: EdgeInsets.only(left: 16, right: 16),
                title: '重置',
                icon: '&#xe60d;',
                type: 'info',
                height: 46,
                iconSize: 20,
                size: 'mini',
                text: true,
                iconPosition: 'top',
                space: 5,
                onPressed: () {
                  onReset();
                },
              ),
              Expanded(
                child: YsButton(
                  // width: MediaQuery.of(context).size.width - 70,
                  title: '确定',
                  onPressed: () {
                    onSubmit();
                  },
                ),
              ),
              SizedBox(width: 15)
            ],
          ),
          SizedBox(height: 5),
          Divider(height: 1),
        ],
      ),
    );
  }
}

Widget _getButton({
  String title = '',
  double? width,
  double? height,
  Color? color,
  onPressed,
  textStyle,
  size,
}) {
  return InkWell(
    child: Container(
      width: width,
      height: height,
      color: color,
      alignment: Alignment.center,
      child: Text(title, style: textStyle),
    ),
    onTap: onPressed,
  );
}

class Fcheckbox extends StatelessWidget {
  final List data;
  final List value;
  final String label;
  final String? subLabel;
  final onChange;
  final noneValue;

  Fcheckbox({
    Key? key,
    required this.data,
    required this.value,
    this.label = '',
    this.subLabel,
    this.onChange,
    this.noneValue = '-999',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      bool isActive = value.contains(item['type_id']);
      items.add(_getButton(
        width: 73,
        height: 36,
        size: 'small',
        color: isActive ? Color(0xffEAF4FF) : Color(0xfff2f2f2),
        textStyle: TextStyle(color: isActive ? Color(0xff198AFF) : Color(0xff333333), fontSize: 13),
        title: item['type_name'],
        onPressed: () {
          if (item['type_id'] == noneValue) {
            value.clear();
            // value = [item['type_id']];
            value.add(item['type_id']);
          } else {
            value.remove(noneValue);
            if (isActive) {
              value.remove(item['type_id']);
            } else {
              value.add(item['type_id']);
            }
          }
          onChange(value);
        },
      ));
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(children: [
              TextSpan(
                text: label,
                style: TextStyle(
                  color: Color(0xff333333),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subLabel != null
                  ? TextSpan(
                      text: subLabel,
                      style: TextStyle(
                        color: Color(0xff999999),
                        fontSize: 13,
                      ),
                    )
                  : TextSpan(text: ''),
            ]),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  //Expanded 包裹wrap 防止对齐异常
                  child: Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: items,
              ))
            ],
          ),
          // Wrap(
          //   spacing: 10.0,
          //   runSpacing: 10.0,
          //   children: items,
          // )
        ],
      ),
    );
  }
}

class Fradio extends StatelessWidget {
  final List data;
  final value;
  final String label;
  final onChange;

  // final _value;
  Fradio({
    Key? key,
    required this.data,
    required this.value,
    this.label = '',
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var _value = value;
    // _value = value;
    List<Widget> items = [];
    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      bool isActive = value == item['type_id'];
      items.add(_getButton(
        width: 73,
        height: 36,
        size: 'small',
        color: isActive ? Color(0xffEAF4FF) : Color(0xfff2f2f2),
        textStyle: TextStyle(color: isActive ? Color(0xff198AFF) : Color(0xff333333), fontSize: 13),
        title: item['type_name'],
        onPressed: () {
          _value = item['type_id'];
          onChange(_value, item['params'] ?? <String, dynamic>{});
        },
      ));
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xff333333),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  //Expanded 包裹wrap 防止对齐异常
                  child: Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: items,
              ))
            ],
          ),
          // Wrap(
          //   spacing: 10.0,
          //   runSpacing: 10.0,
          //   children: items,
          // )
        ],
      ),
    );
  }
}

class FBlock extends StatelessWidget {
  final Widget? child;
  final onReset;
  final onSubmit;
  final controller;
  final height;
  FBlock({Key? key, this.child, this.onReset, this.onSubmit, this.controller, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /*Expanded(
          child: Container(
            child: child,
          ),
        ),*/
        Expanded(
          child: Container(
            height: height,
            child: child,
          ),
        ),
        Divider(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            YsButton(
              padding: EdgeInsets.only(left: 16, right: 16),
              title: '重置',
              icon: '&#xe60d;',
              type: 'info',
              height: 46,
              iconSize: 20,
              size: 'mini',
              text: true,
              iconPosition: 'top',
              space: 5,
              onPressed: () {
                onReset();
              },
            ),
            YsButton(
              width: MediaQuery.of(context).size.width - 70,
              title: '确定',
              onPressed: () {
                onSubmit();
                //controller.hide();
              },
            )
          ],
        ),
        Divider(height: 5),
      ],
    );
  }
}
