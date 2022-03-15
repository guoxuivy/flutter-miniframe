import 'package:agent/res/colors.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:flutter/material.dart';

class FormItem extends StatelessWidget {
  final Widget child;
  final Widget? append;
  final String label;
  final String? labelPosition;
  final suffix;
  final bool hasArrow;
  // final List<Map<String, dynamic>>? rules;
  final List? rules;
  final MainAxisAlignment? mainAxisAlignment;
  final EdgeInsets? padding;
  FormItem({
    Key? key,
    required this.child,
    this.append,
    this.label = '',
    this.labelPosition = 'left',
    this.suffix,
    this.hasArrow = false,
    this.rules,
    this.mainAxisAlignment,
    this.padding,
  }) : super(key: key);

  bool _getRequired(List? rules) {
    bool _required = false;
    if (rules != null) {
      for (Map<String, dynamic> item in rules) {
        if (item['required'] ?? false) {
          _required = true;
          continue;
        }
      }
    }
    return _required;
  }

  @override
  Widget build(BuildContext context) {
    final _label = RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: TextStyle(fontSize: 15, color: Color(0xff333333)),
          ),
          TextSpan(
            text: _getRequired(rules) ? ' *' : '',
            style: TextStyle(
              color: Colours.text_danger,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
    List _suffix = [];
    if (suffix != null) {
      _suffix = [SizedBox(width: 5)];
      if (suffix is String) {
        _suffix.add(Text(suffix));
      } else {
        _suffix.add(suffix);
      }
    }
    if (hasArrow) {
      _suffix.add(YsIcon(
        src: '&#xe627;',
        size: 14,
        color: Colours.muted,
      ));
    }
    Widget _child;
    if (labelPosition == 'top') {
      // 兼容radio过多的自动换行1
      _child = Wrap(
        alignment: WrapAlignment.center,
        children: [
          child,
          ..._suffix,
        ],
      );
      var _labels = !Utils.isEmpty(label) ? [_label, SizedBox(height: 5)] : [];
      return Container(
        padding: padding ?? EdgeInsets.fromLTRB(15, 10, 15, 5),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._labels,
            _child,
          ],
        ),
      );
    }
    _child = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        child,
        ..._suffix,
      ],
    );
    Widget _mainChild = Row(
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.spaceBetween,
      children: !Utils.isEmpty(label)
          ? [
              _label,
              _child,
            ]
          : [_child],
    );
    return Container(
      padding: padding ?? EdgeInsets.fromLTRB(15, 12, 15, 12),
      child: append != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _mainChild,
                SizedBox(height: 10),
                append!,
              ],
            )
          : _mainChild,
    );
  }
}
