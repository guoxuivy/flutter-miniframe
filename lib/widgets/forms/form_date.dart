import 'package:agent/res/colors.dart';
import 'package:agent/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class FormDate extends StatefulWidget {
  //final List data;
  final bool enabled;
  final value;
  final String? placeholder;
  final onChanged;
  final String format;
  final DateTime? min;
  final DateTime? max;
  final bool border;
  final EdgeInsets? padding;

  FormDate({
    Key? key,
    //this.data,
    this.enabled = true,
    this.value,
    this.placeholder,
    this.onChanged,
    // timestamp
    this.format = 'yyyy-MM-dd',
    this.min,
    this.max,
    this.border = false,
    this.padding,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormDateState();
  }
}

class FormDateState extends State<FormDate> {
  late DateTime _value;
  @override
  void initState() {
    super.initState();
    _onChanged(getDatetime(widget.value), true);
  }

  DateTime getDatetime(dynamic v) {
    DateTime _v;
    if(Utils.isEmpty(v)){
      return DateTime.now();
    }
    if (widget.format == 'timestamp') {
      _v = DateTime.fromMillisecondsSinceEpoch(Utils.parseInt(v) * 1000);
    } else if (!Utils.isEmpty(v)) {
      _v = DateFormat(widget.format).parse(v.toString());
    } else {
      _v = DateTime.now();
    }
    return _v;
  }

  void _onChanged(DateTime val, [isInit = false]) {
    _value = val;
    if (widget.onChanged != null) {
      widget.onChanged(
        widget.format == 'timestamp'
            ? (val.millisecondsSinceEpoch / 1000).round()
            : Utils.dateStr(val, widget.format),
        isInit,
      );
    }
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant FormDate oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    //_value = getDatetime(widget.value);
  }

  get title {
    String _title = Utils.dateStr(_value, 'yyyy-MM-dd');
    return _title;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [];
    _children.add(GestureDetector(
      onTap: () {
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          minTime: widget.min != null ? widget.min : Utils.getDiffDate(DateTime.now(), year: -20),
          maxTime: widget.max != null ? widget.max : Utils.getDiffDate(DateTime.now(), year: 20),
          onChanged: (date) {},
          onConfirm: (date) {
            _onChanged(date);
          },
          currentTime: _value,
          locale: LocaleType.zh,
        );
      },
      child: Text(
        Utils.isEmpty(title) ? widget.placeholder : title,
        style: TextStyle(color: !Utils.isEmpty(title) ? Colours.text_info : Colours.text_muted),
      ),
    ));
    return Container(
      padding: widget.padding,
      decoration: widget.border
          ? BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(3.0),
              border: Border.all(color: Color(0xffdddddd), width: .6),
            )
          : null,
      // width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _children,
      ),
    );
  }
}
