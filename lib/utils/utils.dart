import 'dart:convert';
import 'dart:math';
import 'package:agent/boot.dart';
import 'package:agent/net/result.dart';
import 'package:agent/utils/logs.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

/// 全局保存的登录token 不走ls 提高性能

/// 枚举日志类型
enum logLevel { info, warning, error, exception }

/// 主动日志收集器
void trace(dynamic value, [level = logLevel.info]) {
  if (value is List) {
    value.forEach((v) {
      Logs.trace(v, level);
    });
  } else {
    Logs.trace(value, level);
  }
}

/// 快捷工具类
class Utils {
  static String date(int? longTime, [String format = 'yyyy-MM-dd']) {
    if (longTime == null || longTime < 86400) {
      return "";
    }
    if (longTime.toString().length == 10) {
      longTime = longTime * 1000;
    }
    var time = new DateTime.fromMillisecondsSinceEpoch(longTime);
    return DateFormat(format).format(time);
  }

  static String dateTime(int longTime) {
    return date(longTime, 'yyyy-MM-dd HH:mm:ss');
  }

  static String dateStr(DateTime datetime, [String format = 'yyyy-MM-dd']) {
    return date(datetime.millisecondsSinceEpoch, format);
  }

  static DateTime getDiffDate(DateTime datetime,
      {int year = 0,
      int month = 0,
      int day = 0,
      int hour = 0,
      int second = 0,
      int millisecond = 0}) {
    DateTime dt = datetime;
    if (year != 0) {
      dt = dt.add(Duration(days: year * 365));
    }
    if (month != 0) {
      dt = dt.add(Duration(days: month * 30));
    }
    if (day != 0) {
      dt = dt.add(Duration(days: day));
    }
    if (hour != 0) {
      dt = dt.add(Duration(hours: hour));
    }
    if (second != 0) {
      dt = dt.add(Duration(seconds: second));
    }
    if (millisecond != 0) {
      dt = dt.add(Duration(milliseconds: millisecond));
    }
    return dt;
  }

  static List<String> dateStrRange(DateTime datetime,
      {int day = 0, int hour = 0, int second = 0, int millisecond = 0}) {
    List<String> ret;
    DateTime dt =
        getDiffDate(datetime, day: day, hour: hour, second: second, millisecond: millisecond);
    if (dt.compareTo(datetime) > 0) {
      ret = [dateStr(datetime), dateStr(dt)];
    } else {
      ret = [
        dateStr(dt),
        dateStr(datetime),
      ];
    }
    return ret;
  }

  static Widget pd(Widget w, {double l = 0, double t = 0, double r = 0, double b = 0}) {
    return Padding(padding: EdgeInsets.fromLTRB(l, t, r, b), child: w);
  }

  // md5
  static String ysMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  static listIsEmpty(List val) {
    return val.length > 0 ? val.every((item) => item == null) : true;
  }

  //入驻
  static arrivalDate(value) {
    String _value = value.toString();
    if (_value == '9999999999') {
      return '长期需求';
    } else if (_value == 'null' || _value == '' || _value == '0') {
      return '随时入驻';
    }
    return date(int.parse(_value), 'yyyy年MM月dd日');
  }

  //图片url
  static imgUrl(String value, [isThumb = false]) {
    String suffix = isThumb ? '&thumb=1' : '';
    if (Utils.isEmpty(value)) {
      return 'assets/images/no_pic.png';
    } else if (value.contains('assets')) {
      return value;
    } else if (value.contains('/')) {
      if (value.startsWith('http')) {
        return '$value$suffix';
      } else {
        return Boot.config.imgBaseUrl + value;
      }
    }
    return Boot.config.imgBaseUrl + '/api/img/show?id=$value$suffix';
  }

  static fileUrl(String value) {
    return Boot.config.imgBaseUrl + '/api/img/show?id=$value';
  }

  //pickerMapToList({'a': 1, 'b': 2}, ['a']) => [1]
  static List pickerMapToList(maps, List keys) {
    List newList = [];
    keys.forEach((k) {
      if (maps[k] != null) {
        newList.add(maps[k]);
      }
    });
    return newList;
  }

// ignore: slash_for_doc_comments
  /**
     * 自动生成年份
     * @param  {Number}  amount=50        生成的数量
     * @param  {Number}  amount=50        生成的数量
     * @param  {Boolean} t=false          递增或递减
     * @param  {Number}  nowYear=当前年份  初始年份
     * @return {Array}                    年份的数组
     */
  static getYears({int amount = 50, bool t = false, int nowYear = 0}) {
    int _nowYear = nowYear == 0 ? DateTime.now().year : nowYear;
    List aYears = [];
    for (var i = 0; i < amount; i++) {
      if (t) {
        aYears.insert(0, {
          'type_id': _nowYear,
          'type_name': '$_nowYear年',
        });
        _nowYear++;
      } else {
        aYears.add({
          'type_id': _nowYear,
          'type_name': '$_nowYear年',
        });
        _nowYear--;
      }
    }
    return aYears;
  }

  static getMonths([int amount = 12]) {
    List aM = [];
    // var now = DateTime.now();
    // int nowYear = now.year;
    // int nowMonth = now.month;
    for (var i = 0; i < amount; i++) {
      bool disabled = true;
      /* if (nowYear == this.value.estimate_build_year) {
            disabled = i <= nowMonth
        } */
      aM.add({
        'disabled': disabled,
        'type_id': i + 1,
        'type_name': '${i + 1}月',
      });
    }
    return aM;
  }

  static getFloors([int amount = 26]) {
    List aM = [];
    for (var i = 0; i < amount; i++) {
      aM.add({
        'type_id': i - 5,
        'type_name': '${i - 5}层',
      });
    }
    return aM;
  }

  // 验证String, List, Map, int
  static bool isEmpty(val) {
    if (val == null) {
      return true;
    } else if (val is int || val is double) {
      return false;
    }
    return val.isEmpty;
  }

  static int parseInt(Object? val) {
    val ??= 0;
    return int.tryParse(val.toString()) ?? 0;
  }

  static forEach(items, cb) {
    if (items is List && items.length > 0) {
      for (var i = 0; i < items.length; i++) {
        var item = items[i];
        var rs = cb(item, i) ?? true;
        if (rs == false) {
          break;
        }
      }
    }
  }

  static mapPoint(p) {
    if (p != null) {
      List _p = [];
      if (p is String) {
        _p = p.split(',');
      } else if (p is Map) {
        _p.add(p['lng']);
        _p.add(p['lat']);
      } else {
        _p = p;
      }
      return {
        'lng': double.tryParse(_p[0].toString()),
        'lat': double.tryParse(_p[1].toString()),
      };
    }
    return {};
  }

  static bool equals(dynamic a, dynamic b) {
    return a != null && a.toString() == b.toString();
  }

  static bool notEquals(dynamic a, dynamic b) => !equals(a, b);

  static int intval(dynamic v) {
    return parseInt(v);
  }

  static double floatval(dynamic v) {
    if (v == null) {
      return 0.0;
    }
    if (v is double) {
      return v;
    }
    try {
      if (String is String) {
        return double.tryParse(v.isEmpty ? '0' : v)!;
      } else if (v is int) {
        return double.tryParse(v.toString())!;
      } else if (v is RData) {
        return double.tryParse(v.toString())!;
      } else {
        return v as double;
      }
    } catch (e) {
      return 0.0;
    }
  }

  static String moneyVal(double v, [int pres = 2]) {
    var h = pow(10, pres);
    return (((v * h).round()) / h).toString();
  }

  static String cutStr(String s, int len, [String eclip = '']) {
    return s.length <= len ? s : s.substring(0, len) + eclip;
  }

  static String getAreaUnitFromPrice(int? v) {
    if (v == null) {
      v = 0;
    }
    List<String> areaArr = ['m²', '亩'];
    int areaVal = (v & 0x0F00) >> 8;
    String area = areaArr.length > areaVal ? areaArr[areaVal] : areaArr[0];
    return area;
  }

  static String showPriceTax(int? v) {
    if (v == null) {
      v = 0;
    }
    int taxFeeVal = (v & 0x00F0) >> 4;
    String str = '';
    if (taxFeeVal > 0) {
      if ((taxFeeVal & 1) > 0) {
        str += '含税';
      }
      if ((taxFeeVal & 2) > 0) {
        str += '含物业';
      }
    } else {
      str += '不含税';
    }
    return str;
  }

  static String showPriceUnit(int? v, [bool showTax = true]) {
    if (v == null) {
      v = 0;
    }
    List<String> tenKiloArr = ['元', '万元'];
    //List<String> areaArr = ['m²', '亩'];
    List<String> durationArr = ['', '月', '天', '年'];
    int currencyVal = (v & 0xF000) >> 12;
    //int areaVal = (v & 0x0F00) >> 8;
    int durationVal = (v & 0x000F);
    String currency = tenKiloArr[currencyVal];
    //String area = areaArr.length > areaVal ? areaArr[areaVal] : areaArr[0];
    String area = getAreaUnitFromPrice(v);
    String str = currency + '/' + area;
    if (durationVal > 0) {
      str += '/' + durationArr[durationVal];
    }
    if (showTax) {
      str += '（';
      str += showPriceTax(v);
      str += '）';
    }
    return str;
  }

  static Map<String, dynamic> convertRdataToMap(RData r) {
    Map<String, dynamic> ret = {};
    List<String> keys = r.keys().map((e) => e.toString()).toList();
    keys.forEach((k) {
      ret[k] = r[k];
    });
    return ret;
  }

  static bool checkClientPermission(data, userInfo) {
    bool flag = false;
    if (data != null &&
        data['preserve_info'] != null &&
        data['preserve_info']['preserve_user_info']['id'] == userInfo?.id) {
      // 登录人为当前客户维护人的权限
      if ([
        // 2/3 无效客户/已流失客户
        2, 3,
      ].contains(data['status'])) {
        flag = false;
      } else {
        flag = true;
      }
    }
    return flag;
  }
}

class StorageUtil {
  // 设置布尔的值
  static setBoolItem(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  // 设置double的值
  static setDoubleItem(String key, double value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }

  // 设置int的值
  static setIntItem(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  // 设置Sting的值
  static setStringItem(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // 设置StringList
  static setStringListItem(String key, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(key, value);
  }

  // 获取返回为bool的内容
  static getBoolItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    bool value = prefs.getBool(key)!;
    return value;
  }

  // 获取返回为double的内容
  static getDoubleItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    double value = prefs.getDouble(key)!;
    return value;
  }

  // 获取返回为int的内容
  static getIntItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    int value = prefs.getInt(key)!;
    return value;
  }

  // 获取返回为String的内容
  static getStringItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    String value = prefs.getString(key)!;
    return value;
  }

  // 获取返回为StringList的内容
  static getStringListItem(String key) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> value = prefs.getStringList(key)!;
    return value;
  }

  // 移除单个
  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  // 清空所有的
  static clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
