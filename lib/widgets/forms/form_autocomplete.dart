import 'package:agent/res/colors.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:agent/widgets/ys_icon.dart';

// Autocomplete 自动完成
class FormAutocomplete extends StatefulWidget {
  final String? placeholder;
  final String? value;
  final bool enabled;
  final onChanged;
  final Function? renderItem;
  final buttonPressed;
  final String? url;
  final String searchWord;
  final String? fromField;
  FormAutocomplete({
    Key? key,
    this.placeholder,
    this.value,
    this.enabled = true,
    this.onChanged,
    this.renderItem,
    this.buttonPressed,
    this.url,
    this.searchWord = 'phone',
    this.fromField,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return FormAutocompleteState();
  }
}

class FormAutocompleteState extends State<FormAutocomplete> {
  String _value = '';
  _init() {
    _value = widget.value ?? _value;
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant FormAutocomplete oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    _init();
  }

  @override
  Widget build(BuildContext context) {
    String _url = widget.url ?? '/agentapi/user/searchPhone';
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            Utils.isEmpty(_value)
                ? widget.placeholder!
                : (_value.length > 12 ? _value.substring(0, 12) + '...' : _value),
            style: TextStyle(
              fontSize: 15,
              color: Utils.isEmpty(_value) ? Colours.text_muted : Color(0xff333333),
            ),
          ),
          SizedBox(width: 5),
          YsIcon(
            src: '&#xe600;',
          )
        ],
      ),
      onTap: () {
        Routers.go(context, '/autocomplete', {
          'url': _url,
          'searchword': widget.searchWord,
          'renderItem': widget.renderItem,
        }).then((val) {
          String? _val = val is Map ? val[widget.fromField] : val;
          widget.onChanged(_val, val is Map ? val : {});
        });
      },
    );
  }
}
