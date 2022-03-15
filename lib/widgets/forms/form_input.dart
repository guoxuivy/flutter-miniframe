import 'package:agent/res/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormInput extends StatefulWidget {
  final String placeholder;
  final bool enabled;
  final bool border;
  final value;
  final maxLines;
  final onChanged;
  final onBlur;
  final double? width;
  final double? height;
  final String? size;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  FormInput({
    Key? key,
    this.placeholder = '请输入',
    this.enabled = true,
    this.border = false,
    this.value,
    this.maxLines = 1,
    this.onChanged,
    this.onBlur,
    this.width,
    this.height,
    this.size = 'small',
    this.textAlign,
    this.keyboardType,
    this.inputFormatters,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormInputState();
  }
}

class FormInputState extends State<FormInput> {
  String _value = '';
  // FocusNode _focusNode;

  _init() {
    // 初始化value
    _value = (widget.value ?? '').toString();
  }

  @override
  void initState() {
    super.initState();
    _init();
    /* _focusNode = new FocusNode();
    if (widget.onBlur != null) {
      _focusNode.addListener(() {
        if (!_focusNode.hasFocus) {
          widget.onBlur();
        }
      });
    } */
  }

  @override
  void didUpdateWidget(covariant FormInput oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    _init();
  }

  _onChanged(value) {
    if (widget.onChanged != null) {
      _value = value;
      widget.onChanged(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _border = widget.border || widget.maxLines > 1;

    // 边框
    final _borderSide = _border ? BorderSide(color: Color(0xffe5e5e5), width: .5) : BorderSide.none;
    final InputDecoration decoration = InputDecoration(
      hintText: widget.placeholder,
      hintStyle: TextStyle(color: Colours.text_muted),
      enabled: widget.enabled,
      contentPadding: _border
          ? (widget.size == 'mini' ? EdgeInsets.only(left: 5, right: 5) : EdgeInsets.all(10))
          : EdgeInsets.symmetric(vertical: 0),
      focusedBorder: OutlineInputBorder(
        borderSide: _borderSide,
      ),
      // 都要
      border: OutlineInputBorder(
        borderSide: _borderSide,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: _borderSide,
      ),
    );
    final _controller = TextEditingController.fromValue(
      TextEditingValue(
        text: _value, //判断keyword是否为空
        // 保持光标在最后
        selection: TextSelection.fromPosition(
          TextPosition(affinity: TextAffinity.downstream, offset: _value.length),
        ),
      ),
    );
    if (!_border) {
      // input
      return Container(
        width: widget.width ?? 180,
        height: 20,
        // color: Colours.text_primary,
        child: TextField(
          inputFormatters: widget.inputFormatters,
          style: TextStyle(color: widget.enabled ? Color(0xff222222) : Colours.muted),
          controller: _controller,
          maxLines: 1,
          decoration: decoration,
          onChanged: _onChanged,
          textAlign: widget.textAlign ?? TextAlign.right,
          keyboardType: widget.keyboardType ?? TextInputType.text,
        ),
      );
    }
    double width = MediaQuery.of(context).size.width - 30.0;
    // textarea
    return Container(
      width: widget.width ?? width,
      height: widget.height,
      child: TextField(
        inputFormatters: widget.inputFormatters,
        // focusNode: _focusNode,
        style: TextStyle(fontSize: (widget.size == 'mini' ? 12 : 14)),
        maxLines: widget.maxLines,
        controller: _controller,
        decoration: decoration,
        onChanged: _onChanged,
      ),
    );
  }

  @override
  void dispose() {
    // 释放
    // _focusNode.dispose();
    super.dispose();
  }
}
