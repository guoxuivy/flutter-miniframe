import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class CxeConfig {
  bool debug;
  bool isDemo;
  bool enableLog;
  bool enableApiLog;
  String apiBaseUrl;
  PackageInfo packageInfo; // 应用版本构建等信息
  GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

  CxeConfig({
    this.debug = true,
    this.isDemo = false,
    this.enableLog = true,
    this.enableApiLog = true,
    this.apiBaseUrl = 'http://www.zcdt.local',
  });
}
