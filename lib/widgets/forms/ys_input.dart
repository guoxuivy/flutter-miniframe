import 'package:agent/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'dart:async';

// 防抖动
Function debounce(
  Function func, [
  Duration delay = const Duration(milliseconds: 800),
]) {
  Timer? timer;
  Function target = () {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(delay, () {
      func.call();
    });
  };
  return target;
}

class YsInput extends StatefulWidget {
  const YsInput({
    Key? key,
    this.placeholder = '请输入',
    this.label,
    this.stype = 'default',
    this.type = 'input',
    this.prefixIcon,
    this.size = 'medium',
    this.plain = false,
    this.enabled = true,
    this.height,
    this.maxLines = 1,
    this.value = '',
    this.onChanged,
    this.textAlign = TextAlign.start,
    this.suffix,
  }) : super(key: key);

  final String placeholder;
  final label;
  final String type;
  final String stype;
  final String size;
  final prefixIcon;
  final TextAlign textAlign;
  final bool plain;
  final bool enabled;
  final double? height;
  final maxLines;
  final Function? onChanged;
  final String value;
  final Widget? suffix;

  @override
  State<StatefulWidget> createState() {
    return YsInputState();
  }
}

class YsInputState extends State<YsInput> {
  final _controller = TextEditingController();
  bool _isShowClear = false;
  FocusNode _focusNode = FocusNode();
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      _hasFocus = _focusNode.hasFocus;
      setState(() {});
    });
    // 初始化value
    _controller.text = widget.value;
    // 添加监听
    _controller.addListener(() {
      if (_controller.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
      setState(() {});
    });
  }

  _onChanged(v) {
    if (widget.onChanged != null) {
      widget.onChanged!(v);
      // debounce(() {
      //   widget.onChanged(v);
      // })();
    }
  }

  @override
  Widget build(BuildContext context) {
    // var sizeMap = {'small': 14.0, 'mini': 12.0, 'medium': 16.0, 'large': 30.0};
    var heightMap = {'mini': 28.0, 'small': 32.0, 'medium': 44.0};
    var height = widget.height ?? heightMap[widget.size];

    var fillColor;
    var obscureText = false;
    int maxLines = 1;
    Widget _label;

    if (widget.stype == 'dark') {
      fillColor = Color(0xffF4F4F4);
      // border = InputBorder.none;
    }
    if (widget.type == 'password') {
      obscureText = true;
    } else if (widget.type == 'textarea') {
      maxLines = 4;
      // border = OutlineInputBorder();
      height = 93;
      // border = InputBorder(borderSide: BorderSide(width: 1));
    }

    // label
    final InputDecoration decoration = InputDecoration(
      hintText: widget.placeholder,
      hintStyle: TextStyle(color: Color(0xff999999), fontSize: 14),
      enabled: widget.enabled,
      contentPadding: EdgeInsets.all(0),
      border: OutlineInputBorder(borderSide: BorderSide.none),
      // filled: true,
      // fillColor: Colors.red,
    );
    List<Widget> _inputContent = [SizedBox(width: 10)];
    if (widget.prefixIcon != null) {
      _inputContent.add(YsIcon(src: widget.prefixIcon));
    }
    _inputContent.add(SizedBox(width: 10));
    _inputContent.add(Expanded(
      child: TextField(
        maxLines: maxLines,
        controller: _controller,
        decoration: decoration,
        // password
        obscureText: obscureText,
        focusNode: _focusNode,
        onChanged: (value) {
          _onChanged(value);
        },
        textAlign: widget.textAlign,
      ),
    ));
    if (widget.suffix != null) {
      _inputContent.add(widget.suffix!);
    }
    if (_isShowClear) {
      _inputContent.add(SizedBox(width: 10));
      _inputContent.add(GestureDetector(
        child: YsIcon(
          src: '&#xe61b;',
          color: 'cccccc',
        ),
        onTap: () {
          _controller.clear();
          _onChanged('');
        },
      ));
    }
    _inputContent.add(SizedBox(width: 10));
    Widget _input = Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(3.0),
        border: Border.all(color: _hasFocus ? Colours.primary : Color(0xffcccccc)),
      ),
      width: double.infinity,
      height: height,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _inputContent,
      ),
    );

    if (widget.label != null) {
      Widget _label = Container();
      if (widget.label is String) {
        _label = Text(widget.label);
      } else if (widget.label is Widget) {
        _label = widget.label;
      }
      _input = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label,
          SizedBox(height: 12),
          _input,
        ],
      );
    }
    return _input;
  }

  @override
  void dispose() {
    // 释放
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
