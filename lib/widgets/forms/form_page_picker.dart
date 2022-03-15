import 'package:agent/res/colors.dart';
import 'package:agent/routers/routers.dart';
import 'package:flutter/material.dart';

// select
class FormPagePicker extends StatefulWidget {
  final String placeholder;
  final String url;
  final bool enabled;
  final value;
  // final Map<String, dynamic>? params;
  final double? width;
  final onChanged;
  final onRoute;

  FormPagePicker({
    Key? key,
    this.placeholder = '请选择',
    required this.url,
    this.enabled = true,
    this.value,
    // this.params,
    this.width,
    this.onChanged,
    this.onRoute,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormPagePickerState();
  }
}

class FormPagePickerState extends State<FormPagePicker> {
  var _value;
  Map<String, dynamic> _params = {};
  _init() {
    // 初始化value
    _value = widget.value ?? _value;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant FormPagePicker oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    _init();
  }

  _onChanged(res) {
    if (widget.onChanged != null) {
      widget.onChanged(res);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        // color: Colors.red,
        width: widget.width ?? 180,
        child: Text(
          widget.placeholder,
          // _value != null ? _value! : widget.placeholder,
          style: TextStyle(color: _value != null ? Colours.text_info : Colours.text_muted),
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.right,
        ),
      ),
      onTap: () {
        bool isRoute = true;
        if (widget.onRoute != null) {
          isRoute = widget.onRoute!(_params) ?? isRoute;
        }
        if (isRoute) {
          Routers.go(context, widget.url, {
            'value': _value,
            ..._params,
          }).then((res) {
            _onChanged(res ?? {});
          });
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
