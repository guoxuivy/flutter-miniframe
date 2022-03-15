import 'dart:async';
import 'package:agent/boot.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/utils/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:agent/utils/utils.dart';

/// 日志集中处理
class Logs {
  static int _limitLength = 600;
  static String _startLine = "=========CXE-LOG=========";
  static String _endLine = "=========================";

  static void trace(dynamic value, [level = logLevel.info]) {
    if (Boot.config.debug) {
      _log(value.toString());
    } else {
      // 可以写日志文件 or 远程上报服务器
      switch (level) {
        case logLevel.info:
          break;
        case logLevel.warning:
          break;
        case logLevel.error:
          break;
        case logLevel.exception:
          LocalStorage.instance.setStorage("exceptionLog", value.toString());
          break;
      }
    }
  }

  /// 拦截 系统的一些异常信息 不要调用trace
  static void collectPrint(ZoneDelegate parent, Zone zone, String line) {
    if (Boot.config.debug) {
      parent.print(zone, line);
    } else {
      // 文件or网络日子处理
    }
  }

  /// 异常终极捕获处理逻辑FlutterErrorDetails异常
  static void reportErrorAndLog(FlutterErrorDetails details) {
    //上报错误和日志逻辑
    // 未捕获的错误异常日志处理 可自定义异常友好显示界面 防止crash
    // print('exception:'+ details.toString());
    // print(details.stack);
    trace(details, logLevel.exception);
  }

  /// 将系统异常格式化为标准 FlutterErrorDetails 异常
  static void makeDetails(Object e, StackTrace stack) {
    // 构建FlutterErrorDetails错误信息
    FlutterErrorDetails err = FlutterErrorDetails(exception: e, stack: stack);
    reportErrorAndLog(err);
  }

  static void _log(String msg) {
    print("$_startLine");
    if (msg.length < _limitLength) {
      print(msg);
    } else {
      _segmentationLog(msg);
    }
    print("$_endLine");
  }

  static void _segmentationLog(String msg) {
    var outStr = StringBuffer();
    for (var index = 0; index < msg.length; index++) {
      outStr.write(msg[index]);
      if (index % _limitLength == 0 && index != 0) {
        print(outStr);
        outStr.clear();
        var lastIndex = index + 1;
        if (msg.length - lastIndex < _limitLength) {
          var remainderStr = msg.substring(lastIndex, msg.length);
          print(remainderStr);
          break;
        }
      }
    }
  }
}
