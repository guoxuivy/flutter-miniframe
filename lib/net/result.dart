import 'dart:convert';

class Result {
  Map<String, dynamic> _data;

  Result(this._data);

  bool _isOk = false;
  String _msg = "";

  bool get isOk {
    if (_data.isNotEmpty && _data['code'] == 1) {
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

  dynamic operator [](String key) {
    if (_data.isEmpty) {
      return _Data("");
    }
    return _Data(_data['data'][key]);
  }

  @override
  String toString() {
    return _data.toString();
  }
}

class _Data {
  final dynamic _data;

  const _Data(this._data);

  dynamic operator [](String key) {
      String type = _getTypeName(_data);
      print(_data);

    if (_data == null) {
      return _Data("");
    }
    if(type=='Map'){
        return _Data(_data[key]);
    }else{
        return _Data("");
    }
  }


   String _getTypeName(dynamic value) {
      String type;
      if (value is Map) {
          type = 'Map';
      }
      if(value is List){
          type = 'List';
      }
      // 否则 获取value的类型的字符串形式
      else {
          type = value.runtimeType.toString();
      }
      return type;
  }

  dynamic get data{
      return _data;
  }

  @override
  String toString() {
    return _data.toString();
  }
}
