import 'package:flutter/material.dart';

/// api数据返回封装
class Result {
  Map<String, dynamic> _data;

  Result(this._data);

  Result.nul() : this({});

  dynamic get d => _data;

  dynamic get data => RData(_data['data']);

  bool get isOk {
    if (_data['code'] == 1) {
      return true;
    }
    return false;
  }

  String get msg {
    if (_data.isNotEmpty) {
      return _data['msg'];
    }
    return '';
  }

  /// 重新[]方便连贯操作
  dynamic operator [](String key) {
    String type = RData.getTypeName(_data['data']);
    if (type == 'Map') {
      return RData(_data['data'][key]);
    } else if (type == 'List' && RData.isNumeric(key)) {
      return RData(_data['data'].elementAt(int.parse(key)));
    } else {
      return RData(null);
    }
  }

  @override
  String toString() {
    return _data.toString();
  }
}

// map方法函数参数类型
typedef RDataRender = Widget Function(RData result);

/// 接口返回数据包装类型
class RData {
  final dynamic _data;

  const RData(this._data);

  /// 判断元数据
  bool get isNull {
    return _data == null;
  }

  /// empty判断 注意数字类型未做处理
  bool get isEmpty {
    if (this.isNull) {
      return true;
    }
    String type = RData.getTypeName(_data);
    if (type == 'Map') {
      return _data.isEmpty;
    } else if (type == 'List') {
      return _data.isEmpty;
    } else if (type == 'String') {
      return this.s.isEmpty;
    } else {
      return false;
    }
  }

  /// 快速获取原始数据
  dynamic get d => _data;

  /// 快速获数据取字符串
  String get s => this.toString();

  /// 获取元数据类型
  String get dataType => RData.getTypeName(_data);

  /// 获取元数据长度
  int get size {
    String type = this.dataType;
    if (type == 'Map') {
      return _data.length;
    } else if (type == 'List') {
      return _data.length;
    } else {
      return 0;
    }
  }

  /// 重写操作 获取元数据
  RData operator [](dynamic key) {
    key = key.toString();
    if (_data == null) {
      return RData(null);
    }
    String type = RData.getTypeName(_data);
    if (type == 'Map') {
      return RData(_data[key]);
    } else if (type == 'List' && RData.isNumeric(key)) {
      int index = int.parse(key);
      if (index > (_data.length - 1)) {
        return RData(null);
      }
      return RData(_data.elementAt(int.parse(key)));
    } else {
      return RData(null);
    }
  }
  void operator []=(dynamic key, dynamic b) {
    if (_data == null) {
      return ;
    }
    String type = RData.getTypeName(_data);
    if (type == 'Map') {
      _data[key] = b;
    } else if (type == 'List' && RData.isNumeric(key)) {
      int index = int.parse(key);
      if (index > (_data.length - 1)) {
        _data.insert(index, b);
      } else {
        _data[index] = b;
      }
    }
  }

  static String getTypeName(dynamic value) {
    String type;
    if (value is Map) {
      type = 'Map';
    } else if (value is List) {
      type = 'List';
    }
    // 否则 获取value的类型的字符串形式
    else {
      type = value.runtimeType.toString();
    }
    return type;
  }

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  /// map方法方便使用
  List<Widget> map(RDataRender func) {
    List<Widget> res = [];
    for (var v in this.range()) {
      res.add(func(v));
    }
    return res;
  }

  /// 使用RData包裹 保持类型一致
  Iterable<dynamic> range() sync* {
    if (this.dataType == 'Map') {
      for (var key in _data.keys) {
        yield RData(_data[key]);
      }
    } else if (this.dataType == 'List') {
      int k = 0;
      while (k < this.size) {
        yield RData(_data[k]);
        k++;
      }
    }
  }

  Iterable<dynamic> keys() sync* {
    if (this.dataType == 'Map') {
      for (var key in _data.keys) {
        yield key;
      }
    } else if (this.dataType == 'List') {
      int k = 0;
      while (k < this.size) {
        yield k;
        k++;
      }
    }
  }

  /// 接口原因字符串类型 null 返回强制转换为''空值
  @override
  String toString() {
    String _res = _data.toString();
    if ('null' == _res) {
      _res = '';
    }
    return _res;
  }
}
