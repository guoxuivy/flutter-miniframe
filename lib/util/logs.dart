import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:cxe/util/utils.dart';

/// 日志集中处理
class Logs {
  static void trace(dynamic value, [level = logLevel.info]) {
    if (isDebug) {
      print(value);
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
          break;
      }
    }
  }

  /// 拦截 系统的一些异常信息 不要调用trace
  static void collectPrint(ZoneDelegate parent, Zone zone, String line) {
    if (isDebug) {
      parent.print(zone, line);
    } else {
      // 文件or网络日子处理
    }
  }

  /// 异常终极捕获处理逻辑FlutterErrorDetails异常
  static void reportErrorAndLog(FlutterErrorDetails details) {
    //上报错误和日志逻辑
    // 未捕获的错误异常日志处理 可自定义异常友好显示界面 防止crash
    // print('exception:');
    // print(details.exception.message);
    // print(details.stack);
    trace(details, logLevel.exception);
  }

  /// 将系统异常格式化为标准 FlutterErrorDetails 异常
  static void makeDetails(Object e, StackTrace stack) {
    // 构建FlutterErrorDetails错误信息
    FlutterErrorDetails err = FlutterErrorDetails(exception: e, stack: stack);
    reportErrorAndLog(err);
  }
}
