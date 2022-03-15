import 'package:agent/utils/field_title.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';

typedef onPriceUnitChange = void Function(List<int>);

//价格单位
class PriceUnitSelect extends StatefulWidget {
  // 是否出租
  final bool isRent;
  final List<int>? value;
  final onPriceUnitChange? onChange;
  final double width;

  PriceUnitSelect({
    Key? key,
    this.isRent = true,
    this.value,
    this.onChange,
    this.width = 100.0
  }) : super(key:key);

  @override
  State<StatefulWidget> createState() => _PriceUnitState();
}

class _PriceUnitState extends State<PriceUnitSelect> {
  late ScrollController _ctl1;
  late ScrollController _ctl2;
  List<Map<String, dynamic>>? _data1;
  List<Map<String, dynamic>>? _data2;
  int _value1=0;
  int _value2=0;
  @override
  void initState() {
    super.initState();
    _ctl1 = FixedExtentScrollController();
    _ctl2 = FixedExtentScrollController();
    if (widget.isRent) {
      _data1 = categories['surface_rent_currency'];
      _data2 = categories['surface_tax_property'];
      int _v1 = widget.value!.length > 0 ?  widget.value![0] : 0;
      _value1 = _data1!.indexWhere((e1) => e1['type_id'] == _v1);
      int _v2 = widget.value!.length > 1 ?  widget.value![1] : 0;
      _value2 = _data2!.indexWhere((e2) => e2['type_id'] == _v2);
      //print('price unit init value: [$_v1, $_v2] => [$_value1, $_value2]');
    } else {
      //_data1 = categories[''];
    }

  }
  @override
  void dispose() {
    super.dispose();
    _ctl1.dispose();
    _ctl2.dispose();
  }
  @override
  void didUpdateWidget(covariant PriceUnitSelect oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
      width:widget.width,
      child:InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(_data1![_value1]['type_name']),
            Text(_data2![_value2]['type_name']),
            SizedBox(width: 5,)
          ],
        ),
        onTap: () {
          Picker(
              selecteds: [_value1, _value2],
              adapter: PickerDataAdapter(
                isArray: true,
                data: widget.isRent ? [
                  PickerItem(value: _value1, children: _data1!.map((e) => PickerItem(value: e['type_id'], text: Text(e['type_name']))).toList()),
                  PickerItem(value: _value2, children: _data2!.map((e) => PickerItem(value: e['type_id'], text: Text(e['type_name']))).toList())
                ] : [],
              ),
              onConfirm: (picker, value) {
                _value1 = value[0];
                _value2 = value[1];
                if (widget.isRent) {
                  widget.onChange!([_data1![_value1]['type_id'], _data2![_value2]['type_id']]);
                } else {
                  widget.onChange!([_data1![_value1]['type_id']]);
                }
              }
          ).showModal(context);
        },
      )
    );
  }
}
