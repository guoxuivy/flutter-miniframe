import 'package:agent/res/colors.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:flutter/material.dart';

class FormCheckbox extends StatefulWidget {
  final List data;
  final bool enabled;
  final value;
  final noneValue;
  final allValue;
  final onChanged;
  final Map<String, dynamic> props;
  FormCheckbox({
    Key? key,
    required this.data,
    this.enabled = true,
    this.value,
    this.noneValue,
    this.allValue,
    this.onChanged,
    this.props = const {
      'id': 'type_id',
      'name': 'type_name',
    },
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormCheckboxState();
  }
}

class FormCheckboxState extends State<FormCheckbox> {
  List _value = [];

  _init() {
    _value = widget.value ?? [];
  }

  @override
  void initState() {
    _init();
    super.initState();
  }

  void _onChanged(val) {
    if (val == widget.noneValue) {
      _value = [val];
    } else {
      _value.remove(widget.noneValue);
      if (_value.contains(val)) {
        _value.remove(val);
      } else {
        _value.add(val);
      }
    }
    widget.onChanged(_value);
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant FormCheckbox oldWidget) {
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
      bool _active = _value.contains(item[widget.props['id']]);
      // 需要自动换行，用RichText处理
      _children.add(
        GestureDetector(
          child: RichText(
            text: TextSpan(children: [
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: _active
                    ? YsIcon(
                        src: '&#xedaf;',
                        color: Colours.primary,
                      )
                    : YsIcon(
                        src: '&#xe63e;',
                      ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: SizedBox(width: 5),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: Text(
                  item[widget.props['name']],
                  style: TextStyle(fontSize: 15, color: Color(0xff333333)),
                ),
              ),
            ]),
          ),
          onTap: () {
            _onChanged(item[widget.props['id']]);
          },
        ),
      );
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
