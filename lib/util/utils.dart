import 'dart:convert';
import 'package:cxe/util/local_storage.dart';
import 'package:cxe/util/logs.dart';

bool get isDebug {
  bool inDebugMode = false;
  assert(inDebugMode = true); //如果debug模式下会触发赋值
  return inDebugMode;
}

/// 全局保存的登录token 不走ls 提高性能
String _token;

/// 枚举日志类型
enum logLevel { info, warning, error, exception }

/// 主动日志收集器
void trace(dynamic value, [level = logLevel.info]) {
  Logs.trace(value, level);
}

/// 快捷工具类
class Utils {
  ///格式化
  static _format(dynamic value) {
    String type;
    if (value is Map || value is List) {
      type = 'String';
      value = JsonEncoder().convert(value);
    }
    // 否则 获取value的类型的字符串形式
    else {
      type = value.runtimeType.toString();
    }
    switch (type) {
      case 'String':
        break;
      case 'int':
        break;
      case 'double':
        break;
      case 'bool':
        break;
    }
    return value;
  }

  ///获取当前登录token
  static String getToken() {
    return _token;
  }

  /// 设置登录token 并保存缓存
  static void setToken(String token) async {
    _token = token;
    LocalStorage ls = LocalStorage.instance;
    ls.setStorage("token", token);
    trace('设置token：' + token);
  }

  /// 工具初始化
  static void init() async {
    // 初始化本地token
    LocalStorage ls = LocalStorage.instance;
    // await ls.removeStorage('token');
    String token = await ls.getStorage('token');
    trace(token);
    token = token ?? "TOKEN@woshitokencangxiaoer";
    setToken(token);
  }
}
