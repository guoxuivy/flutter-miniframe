import 'dart:async';
import 'dart:io';
import 'package:agent/boot.dart';
import 'package:agent/config.dart';
import 'package:agent/launch.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:agent/utils/logs.dart';
import 'package:agent/provider/theme.dart';
import 'package:agent/routers/routers.dart';

void main() async {
  // 显示元素边框辅助线
  // debugPaintSizeEnabled = true;
  //提前初始化flutter 以便运行自定义的初始化
  WidgetsFlutterBinding.ensureInitialized();
  //
  final boot = Boot(CxeConfig());
  await boot.onReady;
  // 沙箱异常捕获 自定义异常日志处理
  runZoned(
    () => runApp(
      ProviderScope(
        child: MyApp(),
      ),
    ),
    //添加Provider 状态管理支持
    zoneSpecification: ZoneSpecification(
      //自定义拦截
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        Logs.collectPrint(parent, zone, line); //全局 print 方法自定义收集
      },
    ),
    onError: (dynamic e, StackTrace stack) {
      Logs.makeDetails(e, stack);
    },
  );
  FlutterError.onError = (FlutterErrorDetails details) {
    Logs.reportErrorAndLog(details);
  };
  if (Platform.isAndroid) {
    //安卓机上设置顶部状态栏背景为透明
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //设置为透明
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        /// 使用Consumer(ConsumerWidget的封装)，控制刷新的范围
        /// 监听themeProvider状态变化。
        ThemeMode mode = watch(themeProvider).mode;
        return MaterialApp(
          title: '仓小二',
          // showPerformanceOverlay: true, //性能调试工具显示
          themeMode: mode,
          theme: context.read(themeProvider).getTheme(),
          onGenerateRoute: Routers.generate,
          navigatorKey: Routers.navigatorKey,
          home: LaunchPage(),
        );
      },
    );
  }
}
