import 'package:agent/boot.dart';
import 'package:agent/provider/user.dart';
import 'package:agent/res/colors.dart';
import 'package:agent/storage/area.dart';
import 'package:flutter/material.dart';

class AreaFilterState extends State<SimpleAreaFilter> {
  List<Map<String, Area>?> areaData = [];
  @override
  void initState() {
    super.initState();
    areaData = [initProvinceList(), null, null];
  }

  Map<String, Area> initProvinceList() {
    Map<String, Area> ret = {'': Area('', '全部', '86', 1)};
    ret.addAll(getAreaTree('86'));
    return ret;
  }

  Map<String, Area> filterAreaMap(Map<String, Area>? indata, List<String> codes) {
    Map<String, Area> ret = {};
    if (indata != null && indata.isNotEmpty) {
      indata.forEach((key, value) {
        if (key == '' || codes.contains(key)) {
          ret.addAll({key: value});
        }
      });
    }
    return ret;
  }

  Future<void> _onChange(Area a) async {
    List<String> _v = [];
    int index = a.level;
    if (a.code != '') {
      if (a.level == 1) {
        _v = [a.code!];
        //index = 0;
      } else if (a.level == 2) {
        _v = [a.parentCode!, a.code!];
      } else if (a.level == 3) {
        _v = [a.getParent()!.parentCode!, a.parentCode!, a.code!];
      }
      if (index < areaData.length) {
        areaData[index] = await a.loadChildren();
        if (index == 1) {
          areaData[2] = null;
        }
      }
    } else {
      areaData[1] = null;
      areaData[2] = null;
    }
    setState(() {});
    widget.onChange!(_v);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.useUserFilter) {
      User user = Boot.instance.user;
      areaData[0] =
          filterAreaMap(initProvinceList(), user.provinces.map((e) => e.toString()).toList());
      areaData[1] = filterAreaMap(areaData[1], user.cities.map((e) => e.toString()).toList());
    }
    return renderPannel(datas: areaData, values: widget.value);
  }

  Widget renderPannel({required List datas, required List values}) {
    int idx = 0;
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 10, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: datas.map((e1) {
          idx += 1;
          String curVal = values.length > idx - 1 && values[idx - 1] != null ? values[idx - 1] : '';
          return Column(
            key: Key('AreaFilter-Col-' + idx.toString() + '-' + curVal),
            children: renderColumn(e1 ?? {}, curVal),
          );
        }).toList(),
      ),
    );
  }

  List<Widget> renderColumn(Map<String, Area> el, String checkedVal) {
    List<Widget> ret = [];
    el.entries.forEach((MapEntry me) {
      String label = me.value.name.toString();
      ret.add(
        TextButton(
          onPressed: () {
            _onChange(me.value);
          },
          child: Text(
            label,
            style: TextStyle(color: checkedVal == me.value.code ? Colours.primary : Colours.text),
          ),
        ),
      );
    });
    return ret;
  }
}

class SimpleAreaFilter extends StatefulWidget {
  final List<String> value;
  final String? label;
  final Function? onChange;
  final bool useUserFilter;
  // final _value;
  SimpleAreaFilter(
      {Key? key, required this.value, this.label, this.onChange, this.useUserFilter = false})
      : super(key: key);
  createState() => AreaFilterState();
}
