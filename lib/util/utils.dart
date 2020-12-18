import 'dart:convert';
import 'package:cxe/util/logs.dart';
import 'package:flutter/material.dart';

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

  static Future versionDialog(BuildContext context,{String versionLog}) {
    //设置按钮
    Widget cancelButton = FlatButton(
      child: Text("下次再说"),
      onPressed: () {
        return Navigator.pop(context, false);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("立即更新"),
      onPressed: () => Navigator.pop(context, true),
    );

    //设置对话框
    AlertDialog alert = AlertDialog(
      title: Text("升级更新"),
      content: Text(versionLog??"有新版本发布，是否更新？"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    //显示对话框
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
