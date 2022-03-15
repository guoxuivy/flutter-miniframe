import 'package:agent/res/colors.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:flutter/material.dart';

class FormRadio extends StatefulWidget {
  final List data;
  final bool enabled;
  final value;
  final onChanged;
  final append;
  FormRadio({
    Key? key,
    required this.data,
    this.enabled = true,
    this.value,
    this.onChanged,
    this.append,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormRadioState();
  }
}

class FormRadioState extends State<FormRadio> {
  var _value;

  _init() {
    _value = widget.value;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _onChanged(val) {
    // 当前选中不再执行
    if (_value != val) {
      _value = val;
      widget.onChanged(val);
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant FormRadio oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data == null) {
      return Text('请设置data');
    }
    List<Widget> _children = [];
    for (var item in widget.data) {
      // 需要自动换行，用RichText处理
      _children.add(
        GestureDetector(
          child: RichText(
            text: TextSpan(children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: _value == item['type_id']
                    ? YsIcon(
                        src: '&#xe614;',
                        color: widget.enabled ? Colours.primary : Colors.black26,
                      )
                    : YsIcon(
                        src: '&#xe606;',
                      ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SizedBox(width: 5),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Text(
                  item['type_name'],
                  style: TextStyle(
                      fontSize: 15, color: widget.enabled ? Color(0xff333333) : Colours.muted),
                ),
              ),
            ]),
          ),
          onTap: () {
            if (widget.enabled) {
              _onChanged(item['type_id']);
            }
          },
        ),
      );
    }
    if (widget.append != null) {
      _children.add(widget.append);
    }

    return Container(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Wrap(
        spacing: 15,
        runSpacing: 5,
        alignment: WrapAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.start,
        children: _children,
      ),
    );
  }
}
