/// api数据返回封装
class Result {
  Map<String, dynamic> _data;

  Result(this._data);

  bool _isOk = false;
  String _msg = "";

  bool get isOk {
    if (_data['code'] == 1) {
      _isOk = true;
    }
    return _isOk;
  }

  String get msg {
    if (_data.isNotEmpty) {
      _msg = _data['_msg'];
    }
    return _msg;
  }

  /// 重新[]方便连贯操作
  dynamic operator [](String key) {
    if (_data == null) {
      return _Data(null);
    }

    String type = _Data.getTypeName(_data['data']);
    if (type == 'Map') {
      return _Data(_data['data'][key]);
    } else if (type == 'List' && _Data.isNumeric(key)) {
      return _Data(_data['data'].elementAt(int.parse(key)));
    } else {
      return _Data(null);
    }
  }

  dynamic get data => _data;

  @override
  String toString() {
    return _data.toString();
  }
}

class _Data {
  final dynamic _data;

  const _Data(this._data);

  dynamic operator [](String key) {
    if (_data == null) {
      return _Data(null);
    }
    String type = _Data.getTypeName(_data);
    if (type == 'Map') {
      return _Data(_data[key]);
    } else if (type == 'List' && _Data.isNumeric(key)) {
      return _Data(_data.elementAt(int.parse(key)));
    } else {
      return _Data(null);
    }
  }

  /// 判断元数据
  bool get isNull => _data == null;

  /// 获取元数据
  dynamic get data => _data;

  @override
  String toString() {
    return _data.toString();
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
}
