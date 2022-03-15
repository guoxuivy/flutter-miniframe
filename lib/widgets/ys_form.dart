import 'package:agent/net/http_manager.dart';
import 'package:agent/res/colors.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/forms/form_autocomplete.dart';
import 'package:agent/widgets/forms/form_checkbox.dart';
import 'package:agent/widgets/forms/form_date.dart';
import 'package:agent/widgets/forms/form_input.dart';
import 'package:agent/widgets/forms/form_item.dart';
import 'package:agent/widgets/forms/form_multi_select.dart';
import 'package:agent/widgets/forms/form_page_picker.dart';
import 'package:agent/widgets/forms/form_position.dart';
import 'package:agent/widgets/forms/form_radio.dart';
import 'package:agent/widgets/forms/form_select.dart';
import 'package:agent/widgets/forms/form_upload.dart';
import 'package:agent/widgets/price_unit.dart';
import 'package:agent/widgets/ys_belong_agent.dart';
import 'package:flutter/material.dart';

// controller
class FormController {
  String url;
  Map<String, dynamic> data;
  Map<String, dynamic>? copyData;
  Function? submitted;
  Map<String, dynamic> validateOptions;
  var submitBefore;
  bool _waiting = false;

  FormController({this.url = '', this.submitted, data, validateOptions, submitBefore})
      : data = Map<String, dynamic>.from(data ?? {}),
        validateOptions = validateOptions ?? {},
        submitBefore = submitBefore ??
            ((d) {
              return true;
            }),
        copyData = Map<String, dynamic>.from(data ?? {});

  setOption({url, data, submitted, submitBefore, validateOptions}) {
    this.url = url ?? this.url;
    // 类型兼容
    this.data = Map<String, dynamic>.from(data ?? this.data);
    this.submitted = submitted ?? this.submitted;
    this.validateOptions.addAll(validateOptions ?? {});
    this.submitBefore = submitBefore ?? this.submitBefore;
  }

  reset() {
    if (this.copyData != null) {
      this.data = Map.from(this.copyData!);
    }
  }

  getValue(name) {
    var _value;
    if (name == null) {
      return null;
    }
    // 处理'.'选择
    if (name.contains('.')) {
      List _names = name.split('.');
      if (_names.length == 3) {
        int _index = int.tryParse(_names[1])!;
        if (!Utils.isEmpty(this.data[_names[0]]) && !Utils.isEmpty(this.data[_names[0]][_index])) {
          _value = this.data[_names[0]][_index][_names[2]];
        }
      } else if (_names.length == 2) {
        _value = this.data[_names[0]][_names[1]];
      }
    } else {
      // print('ys_form');
      // print(this.data);
      _value = this.data[name];
    }
    return _value;
  }

  setValue(name, val) {
    if (name != null) {
      // 处理'.'选择
      if (name.contains('.')) {
        List _names = name.split('.');
        if (_names.length == 3) {
          int _index = int.parse(_names[1]);
          if (!Utils.isEmpty(this.data[_names[0]]) && this.data[_names[0]][_index] != null) {
            this.data[_names[0]][_index][_names[2]] = val;
          }
        } else if (_names.length == 2) {
          this.data[_names[0]][_names[1]] = val;
        }
      } else {
        this.data[name] = val;
      }
    }
  }

  // 单个验证
  String validateItem(name, [rules]) {
    List<Map<String, dynamic>> _rules =
        new List<Map<String, dynamic>>.from(rules ?? validateOptions[name]);
    String? message;
    Utils.forEach(_rules, (rule, i) {
      var _value = getValue(name);
      bool _required = rule['required'] ?? false;
      if (_required && Utils.isEmpty(_value)) {
        // rules=[{'required' true, 'message': '必填'}]
        message = rule['message'];
        return false;
      } else if (rule['validator'] != null) {
        // 自定义 rules=[{'validator': () { return false }}]
        // 需要返回提示信息
        message = rule['validator'](_value);
        if (message != null) {
          return false;
        }
      }
    });

    if (message != null) {
      Dialogs.showToast(
        msg: message!,
        type: 'warning',
      );
    }
    return message ?? '';
  }

  // 全部验证
  bool validateItems([List<String>? names]) {
    String message = '';
    final Iterable<String> _names = names ?? validateOptions.keys;
    for (var name in _names) {
      message = validateItem(name);
      // 一个一个验证
      if (message.isNotEmpty) {
        break;
      }
    }
    return message.isEmpty;
  }

  void submit() async {
    print('formData: ');
    print(data);
    if (!validateItems()) {
      return;
    }
    if (!submitBefore(data)) {
      this.setOption(data: {});
      return;
    }
    if (_waiting) {
      return;
    }
    final ajax = HttpManager.instance;
    _waiting = true;
    ajax.post(url, data: data).then((value) {
      print(value.isOk && submitted != null);
      if (value.isOk && submitted != null) {
        submitted!(value);
        // 最后重置数据
        this.setOption(data: {});
      }
    });
  }

  dispose() {
    this.data = {};
    this.copyData = {};
    this.validateOptions = {};
  }
}

// form
class YsForm extends StatefulWidget {
  const YsForm({
    Key? key,
    // this.data,
    required this.formItems,
    this.submitted,
    this.setDialogState,
    this.controller,
    this.border = true,
  }) : super(key: key);

  // final List data;
  final List<Map<String, dynamic>> formItems;
  final submitted;
  final setDialogState;
  final controller;
  final bool border;
  @override
  State<StatefulWidget> createState() {
    return YsFormState();
  }
}

class YsFormState extends State<YsForm> {
  /* @override
  void didUpdateWidget(covariant YsForm oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
  } */

  @override
  void initState() {
    super.initState();
    // setState(() {});
  }

  _getShow(item) {
    if (item['show'] != null) {
      if (item['show'] is bool) {
        return item['show'];
      } else {
        return item['show'](widget.controller.data);
      }
    }
    return true;
  }

  _getValue(item) {
    Map _item = item ?? {};
    String? _type = _item['type'];
    String? _name = _item['name'];
    if (_name == null) {
      return;
    }
    var _value = widget.controller.getValue(_name);
    // 处理默认值
    if (_value == null && ['checkbox', 'multiSelect', 'position'].contains(_type)) {
      widget.controller.setValue(_name, []);
    }
    return _value;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.formItems.length,
      itemBuilder: (BuildContext context, int i) {
        final Map _item = Map.from(widget.formItems[i]);
        final String _type = _item['type'] ?? '';
        //trace('itemBuilder in YSform ' + _item['label']);
        // 不显示
        if (!_getShow(_item)) {
          // 去掉对应的验证
          widget.controller.validateOptions.remove(_item['name']);
          return Container();
        }
        if (_item['rules'] != null && _item['name'] != null) {
          Map<String, dynamic> opt = {_item['name']: _item['rules']};
          widget.controller.validateOptions.addAll(opt);
        }
        _onChanged(val) {
          widget.controller.setValue(_item['name'], val);
          if (_item['onChanged'] != null) {
            _item['onChanged'](val);
          }
          if (widget.setDialogState != null) {
            widget.setDialogState(() {});
          }
        }

        // 自定义
        if (_type == 'block') {
          return _item['render']();
        }
        // title
        if (_type == 'title') {
          return Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _item['label'],
                  style: TextStyle(fontSize: 13, color: Colours.text_muted),
                ),
                _item['render'] != null ? _item['render']() : Container(),
              ],
            ),
            color: Color(0xfff5f5f5),
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            height: 36,
          );
        }
        // 表单项
        Widget _itemValue;

        final _value = _getValue(_item);
        if (_item['render'] != null) {
          _itemValue = _item['render'](widget.controller.data);
        } else if (_type == 'select') {
          _item['hasArrow'] = _item['hasArrow'] ?? true;
          _itemValue = FormSelect(
            value: _value,
            placeholder: _item['placeholder'] ?? '请选择',
            data: _item['data'],
            // width: _item['width'],
            onSelectedClose: _item['onSelectedClose'] ?? true,
            modalAppend: _item['modalAppend'],
            onChanged: (val, [it]) {
              _onChanged(val);
              setState(() {});
            },
          );
        } else if (_type == 'multiSelect') {
          _item['hasArrow'] = _item['hasArrow'] ?? true;
          _itemValue = FormMultiSelect(
            value: _value,
            placeholder: _item['placeholder'] ?? '请选择',
            data: _item['data'],
            onChanged: (val) {
              _onChanged(val);
              setState(() {});
            },
          );
        } else if (_type == 'position') {
          _item['hasArrow'] = _item['hasArrow'] ?? true;
          _itemValue = FormPosition(
            value: _value,
            placeholder: _item['placeholder'] ?? '请选择',
            level: _item['level'] ?? 4,
            enabled: _item['enabled'] ?? true,
            onChanged: (val) {
              _onChanged(val);
              setState(() {});
            },
          );
        } else if (_type == 'date') {
          _item['hasArrow'] = _item['hasArrow'] ?? true;
          // 根据类型自动判断格式
          String _format = _item['format'] ?? (_value is int ? 'timestamp' : 'yyyy-MM-dd');
          _itemValue = FormDate(
            value: _value,
            placeholder: _item['placeholder'] ?? '请选择',
            onChanged: (val, [isInit]) {
              _onChanged(val);
              // 初始化时不需要
              if (isInit == null) {
                setState(() {});
              }
            },
            format: _format,
            min: _item['min'],
            max: _item['max'],
          );
        } else if (_type == 'input' || ['number', 'phone', 'email', 'url'].contains(_type)) {
          // 如果input本身已经有border,取消formitem的border
          if (_item['onlyInput'] ?? false) {
            _item['border'] = false;
          }
          TextInputType keyboard;
          switch (_type) {
            case 'number':
              keyboard = TextInputType.number;
              break;
            case 'phone':
              keyboard = TextInputType.phone;
              break;
            case 'email':
              keyboard = TextInputType.emailAddress;
              break;
            case 'url':
              keyboard = TextInputType.url;
              break;
            default:
              keyboard = TextInputType.text;
              break;
          }
          _itemValue = FormInput(
            width: _item['width'],
            value: _value,
            maxLines: 1,
            border: _item['onlyInput'] ?? false,
            enabled: _item['enabled'] ?? true,
            placeholder: _item['placeholder'] ?? '请输入',
            onChanged: _onChanged,
            keyboardType: keyboard,
          );
        } else if (_type == 'textarea') {
          _item['labelPosition'] = _item['labelPosition'] ?? 'top';
          _item['border'] = false;

          _itemValue = FormInput(
            value: _value,
            maxLines: _item['maxLines'] ?? 4,
            enabled: _item['enabled'] ?? true,
            border: false,
            placeholder: _item['placeholder'] ?? '请输入',
            onChanged: _onChanged,
          );
        } else if (_type == 'autocomplete') {
          _itemValue = FormAutocomplete(
            placeholder: _item['placeholder'] ?? '请输入',
            value: _value,
            renderItem: _item['renderItem'],
            fromField: _item['fromField'] ?? _item['name'],
            onChanged: (val, selectItem) {
              // val 选中的一条记录或者输入值
              widget.controller.setValue(_item['name'], val);
              if (_item['onChanged'] != null) {
                _item['onChanged'](val, selectItem, widget.controller.data);
              }
              setState(() {});
            },
            url: _item['url'],
            searchWord: _item['searchWord'] ?? 'phone',
          );
        } else if (_type == 'radio') {
          // print(_value);
          _item['labelPosition'] = _item['labelPosition'] ?? 'top';

          _itemValue = FormRadio(
            data: _item['data'],
            enabled: _item['enabled'] ?? true,
            value: _value,
            onChanged: (val) {
              _onChanged(val);
              setState(() {});
            },
            append: _item['append'] != null ? _item['append'](widget.controller.data) : null,
          );
        } else if (_type == 'checkbox') {
          _item['labelPosition'] = _item['labelPosition'] ?? 'top';

          _itemValue = FormCheckbox(
            data: _item['data'] ?? [],
            noneValue: _item['noneValue'],
            value: _value,
            onChanged: (val) {
              _onChanged(val);
              setState(() {});
            },
          );
        } else if (_type == 'image') {
          _item['labelPosition'] = _item['labelPosition'] ?? 'top';
          _itemValue = FormUpload(
            placeholder: _item['placeholder'],
            value: _value,
            camera: true,
            remote: _item['remote'] ?? false,
            onChanged: (val) {
              _onChanged(val);
              setState(() {});
            },
            accept: _item['accept'],
            crossAxisCount: _item['crossAxisCount'] ?? 4,
            fileKey: _item['key'],
            water: _item['water'],
          );
        } else if (_type == 'YsBelongAgent') {
          List<String> _props = ['agent_enterprise', 'agent_id'];
          List<Map<String, dynamic>> _options = _item['options'] ?? [];
          Map<String, dynamic> _params = {};
          [0, 1].forEach((i) {
            if (_options.length > i && _options[i].isNotEmpty && _options[i].containsKey('prop')) {
              _props[i] = _options[i]['prop'];
            }
            _params[_props[i]] = widget.controller.getValue(_props[i]);
          });
          _item['hasArrow'] = _item['hasArrow'] ?? true;
          _itemValue = YsBelongAgent(
            params: _params,
            options: _options,
            onChange: (List r) {
              //print('form.onchange');
              //print(r.toString());
              widget.controller.data[_props[0]] = r[0];
              widget.controller.data[_props[1]] = r.length > 1 ? r[1] : null;
              if (widget.setDialogState != null) {
                widget.setDialogState(() {});
              }
              setState(() {});
            },
          );
        } else if (_type == 'PriceAndUnit') {
          _item['hasArrow'] = _item['hasArrow'] ?? true;
          bool _isRent = _item['isRent'] ?? true;
          List<String> _uprops = _item['unitProps'];
          List<int> _uvals = [];
          _uprops.forEach((up) {
            _uvals.add(widget.controller.data[up] ?? 1);
          });
          _itemValue = Row(
            children: [
              FormInput(
                width: _item['inputWidth'] ?? 75,
                value: _value,
                maxLines: 1,
                border: _item['onlyInput'] ?? true,
                placeholder: _item['placeholder'] ?? '请输入',
                onChanged: _onChanged,
              ),
              SizedBox(width: 5),
              PriceUnitSelect(
                isRent: _isRent,
                value: _uvals,
                width: _item['unitWidth'] ?? 145,
                onChange: (List<int?> _v) {
                  _uprops.forEach((up) {
                    int i = _uprops.indexOf(up);
                    widget.controller.data[up] = _v[i] ?? 0;
                  });
                  setState(() {});
                },
              )
            ],
          );
        } else if (_type == 'pagePicker') {
          _item['hasArrow'] = _item['hasArrow'] ?? true;
          _itemValue = FormPagePicker(
            value: _value,
            // params: _item['params'](widget.controller.data),
            placeholder: _item['placeholder'] ?? '请选择',
            url: _item['url'],
            onRoute: _item['onRoute'],
            onChanged: (val) {
              _onChanged(val);
              setState(() {});
            },
          );
        } else {
          _itemValue = Text(
            '请设置type或render',
            style: TextStyle(color: Colours.muted),
          );
        }
        String _label = _item['label'] != null
            ? (_item['label'] is String ? _item['label'] : _item['label'](widget.controller.data))
            : '';
        Widget? _append;
        if (_item['append'] != null) {
          _append = _item['append']();
        }
        List<Widget> _children = [
          FormItem(
            label: _label,
            rules: _item['rules'],
            labelPosition: _item['labelPosition'],
            padding: _item['padding'],
            suffix: _item['suffix'],
            hasArrow: _item['hasArrow'] ?? false,
            child: _itemValue,
            append: _append,
          )
        ];
        // 边框
        if (_item['border'] ?? widget.border) {
          _children.add(Divider(
            height: 1,
            color: Color(0xffe5e5e5),
            indent: 15,
            endIndent: 15,
          ));
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _children,
        );
        // 点击空白input失去焦点
        /* return GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
              FocusManager.instance.primaryFocus.unfocus();
            }
          },
          child: Column(children: _children),
        ); */
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
