import 'package:agent/boot.dart';
import 'package:agent/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agent/storage/area.dart';
import 'package:agent/provider/user.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef AddressCallback = void Function(List<String>);

class EmptyArea extends Area {
  @override
  bool get isEmpty => true;

  @override
  bool get isNotEmpty => false;

  EmptyArea(int level) : super('0', '--', '0', level);
}

class AddressNotifier extends ChangeNotifier {
  int level;
  List<Area>? datas;

  AddressNotifier(int this.level);

  void setData(List<Area> datas, [bool filter = false]) {
    if (filter && [1, 2].contains(level)) {
      User user = Boot.instance.user;
      List<String> _codes = [];
      if (level == 1) {
        _codes = user.provinces.map((e) => e.toString()).toList();
      } else if (level == 2) {
        _codes = user.cities.map((e) => e.toString()).toList();
      }
      this.datas = filterAreaMap(datas, _codes);
    } else {
      this.datas = datas;
    }
    notifyListeners();
  }

  List<Area> filterAreaMap(List<Area> indata, List<String> codes) {
    List<Area> ret = [];
    if (indata != null && indata.isNotEmpty) {
      //map((e) => codes.contains(e.code))
      ret = indata.where((el) => codes.contains(el.code) || el.isEmpty).toList();
    }
    return ret;
  }
}

final ChangeNotifierProvider<AddressNotifier> ProvinceProvider =
    ChangeNotifierProvider((_) => AddressNotifier(1));
final ChangeNotifierProvider<AddressNotifier> CityProvider =
    ChangeNotifierProvider((_) => AddressNotifier(2));
final ChangeNotifierProvider<AddressNotifier> RegionProvider =
    ChangeNotifierProvider((_) => AddressNotifier(3));
final ChangeNotifierProvider<AddressNotifier> StreetProvider =
    ChangeNotifierProvider((_) => AddressNotifier(4));

final ChangeNotifierProvider<ValueNotifier> ProvinceCode =
    ChangeNotifierProvider((_) => ValueNotifier(''));
final ChangeNotifierProvider<ValueNotifier> CityCode =
    ChangeNotifierProvider((_) => ValueNotifier(''));
final ChangeNotifierProvider<ValueNotifier> RegionCode =
    ChangeNotifierProvider((_) => ValueNotifier(''));
final ChangeNotifierProvider<ValueNotifier> StreetCode =
    ChangeNotifierProvider((_) => ValueNotifier(''));

typedef OnPickerChange2 = void Function(int, Area);

class IndivalColumnPicker extends StatefulWidget {
  final int level;
  Area current;
  List<Area> itemDatas;
  OnPickerChange2 onChange;
  bool userFilter = false;

  int get itemLength => itemDatas.isNotEmpty ? itemDatas.length : 0;

  int currentIndex;

  IndivalColumnPicker(
      {Key? key,
      required this.level,
      required this.itemDatas,
      required this.current,
      required this.onChange,
      required this.userFilter,
      this.currentIndex = 0})
      : super(key: key);

  @override
  onItemChange(BuildContext context, int index) async {
    trace('on selecte item change');
    Future.delayed(Duration(milliseconds: 300), () {
      current = itemDatas[index];
      _updateProvider(context);
      onChange(index, current);
    });
  }

  List<Area> wrapDataList(List<Area> d, int lev) {
    List<Area> ret = [EmptyArea(lev), ...d];
    return ret;
  }

  void _updateProvider(BuildContext context) async {
    //trace("_updateProvider : level=$level cur= ${current.code}");
    if (level == 1) {
      Map<String, Area> _children = await current.loadChildren();
      List<Area> _cities = current.isEmpty || _children == null || _children.isEmpty
          ? []
          : _children.entries.map((e) => e.value).toList();
      trace(_cities);
      context.read(CityProvider).setData(wrapDataList(_cities, level + 1), userFilter);
      context.read(RegionProvider).setData(wrapDataList([], level + 2), userFilter);
      context.read(StreetProvider).setData(wrapDataList([], level + 2), userFilter);
    } else if (level == 2) {
      Map<String, Area> _children = await current.loadChildren();
      List<Area> _regions = current.isEmpty || _children == null || _children.isEmpty
          ? []
          : _children.entries.map((e) => e.value).toList();
      context.read(RegionProvider).setData(wrapDataList(_regions, level + 1));
      context.read(StreetProvider).setData(wrapDataList([], level + 2));
    }
  }

  @override
  _IndivalColumnPickerState createState() => _IndivalColumnPickerState();
}

class _IndivalColumnPickerState extends State<IndivalColumnPicker> {
  late FixedExtentScrollController ctl;

  @override
  void initState() {
    ctl = FixedExtentScrollController();
    super.initState();
  }

  @override
  void dispose() {
    ctl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () {
      try {
        int _index = widget.currentIndex > 0 ? widget.currentIndex : 0;
        if (ctl.selectedItem != _index) {
          trace("Level:${widget.level} jumpTo ${_index}");
          ctl.jumpToItem(_index);
        }
      } catch (e) {
        trace(e);
      }
    });

    trace('Build Picker ${widget.key.toString()} , ${widget.current}');
    return Expanded(
        child: Center(
            child: CupertinoPicker.builder(
                //key: Key(key.toString() + '_picker'),
                scrollController: ctl,
                useMagnifier: true,
                backgroundColor: Colors.white,
                itemExtent: 32,
                //item height
                childCount: widget.itemDatas != null ? widget.itemDatas.length : 0,
                onSelectedItemChanged: (int index) {
                  widget.onItemChange(context, index);
                },
                itemBuilder: (BuildContext context, int i) {
                  Area a = widget.itemDatas.elementAt(i);
                  return Text(a.name);
                },
                diameterRatio: 3.0)));
  }
}

class AddressPicker extends StatefulWidget {
  final AddressCallback onChange;
  final List<String> value;
  final String label;
  final bool useUserFilter;
  final height;
  final int maxLevel = 3;

  AddressPicker(
      {Key? key,
      required this.value,
      required this.label,
      required this.onChange,
      this.height = 0,
      this.useUserFilter = false})
      : super(key: key);

  @override
  _AddressPickerState2 createState() => _AddressPickerState2();
}

class _AddressPickerState2 extends State<AddressPicker> {
  List<Map<String, Area>> areaData = [];

  @override
  void initState() {
    trace('_AddressPickerState2 initState');
    super.initState();
    //areaData = [initProvinceList(), null, null];
    Future.delayed(Duration.zero, () => initAreaData());
  }

  Future<void> initAreaData() async {
    Map<String, Area> plist = initProvinceList();
    List<Map<String, dynamic>> pa = [];
    //context.read(ProvinceProvider).setData(areaData[0].values);
    pa.insert(0, {'list': plist.values.toList(), 'def': null});
    List<String> _values = ['', '', '', ''];
    if (widget.value != null && widget.value.isNotEmpty) {
      for (int _i = 0; _i < widget.value.length; _i++) {
        _values[_i] = widget.value[_i];
      }
    }
    if (widget.value != null && widget.value.isNotEmpty && widget.value.length > 0) {
      String pcode = _values.elementAt(0).toString();
      if (pcode != null && pcode != '' && pcode != '00') {
        context.read(ProvinceCode).value = pcode;
        //trace('initAreaData: ${pcode}');
        int p_pos = plist.keys.toList().indexOf(pcode);
        Area p = plist.values.elementAt(p_pos);
        if (p != null && !p.isEmpty) {
          Map<String, Area> _cities = await p.loadChildren();
          pa.insert(1, {
            'list': _cities.values.toList(),
          });
          String ccode = _values.elementAt(1).toString();
          if (ccode != null && ccode != '' && ccode != '00') {
            context.read(CityCode).value = ccode;
            Area p1 = _cities[ccode]!;
            if (p1 != null && !p1.isEmpty) {
              Map<String, Area> _regions = await p1.loadChildren();
              pa.insert(2, {
                'list': _regions.values.toList(),
              });
            }
            String rcode = _values.elementAt(2).toString();
            if (rcode != null && rcode != '' && rcode != '00') {
              context.read(RegionCode).value = ccode;
            }
          }
        }
      }

      trace('before setSTate');
      //trace(areaData);
      //setState(() {});
    }
    for (int i = 0; i < pa.length; i++) {
      if (i == 0) {
        Function.apply(
            context.read(ProvinceProvider).setData, [pa[i]['list'], widget.useUserFilter]);
      } else if (i == 1) {
        Function.apply(context.read(CityProvider).setData, [pa[i]['list'], widget.useUserFilter]);
      } else if (i == 2) {
        Function.apply(context.read(RegionProvider).setData, [pa[i]['list'], widget.useUserFilter]);
      }
    }
  }

  Map<String, Area> initProvinceList() {
    Area ea = EmptyArea(1);
    ea.name = '';
    ea.parentCode = '86';
    ea.code = '';
    Map<String, Area> ret = {
      //'': Area('', '全部', '86', 1)
      ea.code!: ea
    };

    ret.addAll(getAreaTree('86'));
    return ret;
  }

  Future<void> _onChange(Area a) async {
    List<String> selected = [
      context.read(ProvinceCode).value,
      context.read(CityCode).value,
      context.read(RegionCode).value,
      //context.read(StreetCode).value,
    ];
    int index = a.level;
    String val = a.code!;
    bool empty_val = val == '0' || val == '';
    // 只有当前值变更时
    String _sel = selected.length >= a.level ? selected[a.level - 1] : '';
    if (val != _sel) {
      if (a.level == 1) {
        //context.read(ProvinceCode).value = a.code;
        if (val != '0') {
          selected = [val];
        } else {
          selected = [];
        }
      } else if (a.level == 2) {
        //context.read(CityCode).value = a.code;
        if (selected.length > 2) {
          selected.removeAt(2);
        }
        if (!empty_val) {
          selected = [a.parentCode!, val];
        } else {
          if (selected.length > 1) {
            selected.removeAt(1);
          }
        }
      } else if (a.level == 3) {
        //context.read(RegionCode).value = a.code;
        if (!empty_val) {
          selected = [a.getParent()!.parentCode!, a.parentCode!, a.code!];
        } else {
          if (selected.length > 2) {
            selected.removeAt(2);
          }
        }
      }
      //setState((){});
      widget.onChange(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    trace("build _AddressPickerState2");
    return renderPicker(values: widget.value);
  }

  Widget renderPicker({required List values}) {
    List<String> _values = ['', '', ''];
    for (int i = 0; i < values.length; i++) {
      _values[i] = values[i];
    }
    return Container(
      padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
      //height: widget.height,
      color: Colors.white,
      child: Row(children: [
        renderProvincePickerBlock(_values[0]),
        renderCityPickerBlock(_values[1]),
        renderRegionPickerBlock(_values[2]),
      ]),
    );
  }

  String getCodePref(int levelIndex, List<Area>? datas, String cur) {
    String _suf = datas == null || datas.isEmpty ? '-' : '+';
    if (datas == null || datas.isEmpty) {
      return '00';
    }
    return datas.last.parentCode!;
  }

  String getWidgetValue(int levelIndex) {
    if (widget.value != null && widget.value.isNotEmpty && widget.value.length > levelIndex - 1) {
      return widget.value.elementAt(levelIndex);
    }
    return '';
  }

  Widget renderProvincePickerBlock(String curVal) {
    const int levelNo = 1;
    Area curVAl = EmptyArea(levelNo);

    return Consumer(builder: (context, watch, _) {
      List<Area> datas = watch(ProvinceProvider).datas!;
      String uniqkey = getCodePref(levelNo - 1, datas, curVal);
      //trace("watch province datas ${uniqkey}");
      trace(datas != null ? datas.map((e) => e.name) : 'Null');
      //String _code = watch(ProvinceCode).value.toString();
      String _code = curVal.toString();
      trace('init province code = $_code');
      int scrollIndex = 0;
      if (_code != '' && datas != null && datas.isNotEmpty) {
        curVAl = datas.firstWhere((el) => el.code == _code, orElse: () => EmptyArea(levelNo));
        scrollIndex = datas.indexWhere((el) => el.code == _code, 0);
        /*if (scrollIndex > -1) {
          scrollIndex ++;
        }*/
      }
      trace('Scroll Index = $scrollIndex');
      return IndivalColumnPicker(
        key: Key("AreaPicker_${levelNo}_${uniqkey}" + (scrollIndex > 0 ? '_${scrollIndex}' : '')),
        level: levelNo,
        current: curVAl,
        itemDatas: datas,
        onChange: (int position, Area a) {
          context.read(ProvinceCode).value = a.isNotEmpty ? a.code.toString() : '';
          trace('on change <${levelNo}> : ${a.name}');
          _onChange(a);
          //onPicker(levelIndex, position, data);
        },
        userFilter: widget.useUserFilter,
        currentIndex: scrollIndex,
      );
    });
  }

  Widget renderCityPickerBlock(String curVal) {
    const int levelNo = 2;

    //List<Area> datas = context.read(CityProvider).datas;
    int scrollIndex = 0;
    Area curVAl = EmptyArea(levelNo);
    return Consumer(builder: (context, watch, _) {
      List<Area> datas = watch(CityProvider).datas!;
      String uniqkey = getCodePref(levelNo - 1, datas, curVal);
      //trace("watch city datas $uniqkey");
      trace(datas != null ? datas.map((e) => e.name) : 'Null');
      if (datas != null) {
        scrollIndex = datas.indexWhere((el) => el.code == curVal, 0);
      }

      return IndivalColumnPicker(
        key: Key("AreaPicker_${levelNo}_${uniqkey}"),
        level: levelNo,
        itemDatas: datas,
        current: curVAl,
        onChange: (int position, Area a) {
          trace('on change <${levelNo}> : ${a.name}');
          _onChange(a);
        },
        userFilter: widget.useUserFilter,
        currentIndex: scrollIndex,
      );
    });
  }

  Widget renderRegionPickerBlock(String curVal) {
    const int levelNo = 3;
    Area curVAl = EmptyArea(levelNo);
    int scrollIndex = 0;
    return Consumer(builder: (context, watch, _) {
      List<Area> datas = watch(RegionProvider).datas!;
      String uniqkey = getCodePref(levelNo - 1, datas, curVal);
      //trace("watch region datas $uniqkey");
      trace(datas != null ? datas.map((e) => e.name) : 'Null');
      if (datas != null) {
        scrollIndex = datas.indexWhere((el) => el.code == curVal, 0);
      }
      return IndivalColumnPicker(
        key: Key("AreaPicker_${levelNo}_${uniqkey}"),
        level: levelNo,
        itemDatas: datas,
        current: curVAl,
        onChange: (int position, Area a) {
          trace('on change <${levelNo}> : ${a.name}');
          _onChange(a);
        },
        userFilter: widget.useUserFilter,
        currentIndex: scrollIndex,
      );
    });
  }
}
