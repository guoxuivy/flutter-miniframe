import 'package:flutter/material.dart';

class YsCheckBox extends StatefulWidget {
  final bool? value;
  final ValueChanged? onChanged;
  final bool tristate;
  final BorderSide? side;
  final MaterialStateProperty<Color>? fillColor;
  final bool enabled;

  YsCheckBox({
    Key? key,
    this.value,
    this.onChanged,
    this.tristate = false,
    this.side,
    this.fillColor,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<YsCheckBox> createState() => _YsCheckBoxState();
}

class _YsCheckBoxState extends State<YsCheckBox> {
  bool? _value;
  @override
  void initState() {
    _value = widget.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant YsCheckBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: _value,
        tristate: widget.tristate,
        fillColor: widget.enabled ? widget.fillColor : MaterialStateProperty.all(Colors.black26),
        onChanged: (v) {
          if (widget.enabled) {
            _value = v;
            widget.onChanged!(v);
            setState(() {});
          }
        });
  }
}
