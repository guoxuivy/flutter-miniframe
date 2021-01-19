import 'dart:convert';
import 'package:agent/utils/logs.dart';
import 'package:flutter/material.dart';

import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

/// 全局保存的登录token 不走ls 提高性能

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



  // md5
  static String ysMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }


}
