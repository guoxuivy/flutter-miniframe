/// api数据返回封装
class Result {
  Map<String, dynamic> _data;

  Result(this._data);

  Result.nul() : this(null);

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
    if (_data == null) {
      return RData(null);
    }

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

/// 接口返回数据包装类型
class RData {
  final dynamic _data;

  const RData(this._data);

  /// 判断元数据
  bool get isNull => _data == null;

  /// 快速获取原始数据
  dynamic get d => _data;

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
  dynamic operator [](dynamic key) {
    key = key.toString();
    if (_data == null) {
      return RData(null);
    }
    String type = RData.getTypeName(_data);
    if (type == 'Map') {
      return RData(_data[key]);
    } else if (type == 'List' && RData.isNumeric(key)) {
      return RData(_data.elementAt(int.parse(key)));
    } else {
      return RData(null);
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

  static bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
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

  @override
  String toString() {
    return _data.toString();
  }
}
