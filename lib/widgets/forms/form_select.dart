import 'package:agent/res/colors.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:agent/widgets/ys_icon.dart';

// select
class FormSelect extends StatefulWidget {
  final String placeholder;
  final bool enabled;
  final List? data;
  final Object? value;
  final double? width;
  final onChanged;

  // 在弹窗最后追加内容
  final modalAppend;
  final renderButton;

  // 点击时是否关闭弹窗
  final bool onSelectedClose;
  final bool selectFirst;

  FormSelect({
    Key? key,
    this.placeholder = '请选择',
    this.enabled = true,
    this.data,
    this.value,
    this.width,
    this.onChanged,
    this.modalAppend,
    this.renderButton,
    this.onSelectedClose = true,
    this.selectFirst = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormSelectState();
  }
}

class FormSelectState extends State<FormSelect> {
  Object? _value;
  Map _activeItem = {};

  _init() {
    // 初始化value
    _value = widget.value ?? _value;
    if (widget.data != null) {
      _activeItem = widget.data?.singleWhere(
          (item) => item['type_id'].toString() == _value.toString(),
          orElse: () => Map<String, Object>.from({}));
    }
    if (_value != null) {
      // widget.onChanged(_value, _activeItem);
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant FormSelect oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    _init();
  }

  _onChanged(_value, _activeItem) {
    if (widget.onSelectedClose) {
      Navigator.pop(context);
      setState(() {});
    }
    if (widget.onChanged != null) {
      widget.onChanged(_value, _activeItem);
    }
  }

  showModal(context) {
    _getChildren(setDialogState) {
      List<Widget> _children = [];
      for (var item in widget.data!) {
        bool isSelected = _value == item['type_id'];
        _children.add(
          InkWell(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    item['type_name'] ?? '',
                    style: TextStyle(
                      fontSize: 15,
                      color: isSelected ? Colours.text_primary : Colours.text_info,
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
              _value = item['type_id'];
              _activeItem = item;
              _onChanged(_value, _activeItem);
              setDialogState(() {});
            },
          ),
        );
        _children.add(Divider(height: 1));
      }
      if (widget.modalAppend != null) {
        _children.add(widget.modalAppend(setDialogState));
      }
      return _children;
    }

    Dialogs.bottomPop(
      title: Container(
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
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
            !widget.onSelectedClose
                ? InkWell(
                    onTap: () {
                      _onChanged(_value, _activeItem);
                    },
                    child: Text('确认'),
                  )
                : Container(),
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

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) {
      return Text('请设置data');
    }
    // controller.text = widget.value;
    if (widget.renderButton != null) {
      return widget.renderButton(() {
        showModal(context);
      }, _activeItem);
    }
    return InkWell(
      child: Container(
        // color: Colors.red,
        width: widget.width ?? 180,
        child: Text(
          (_value != null && _activeItem['type_name'] != null)
              ? _activeItem['type_name']
              : widget.placeholder,
          style: TextStyle(color: _value != null ? Colours.text_info : Colours.text_muted),
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
