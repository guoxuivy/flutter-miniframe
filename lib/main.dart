import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cxe/net/http_manager.dart';
import 'package:cxe/util/utils.dart';
import 'package:cxe/util/logs.dart';
import 'package:cxe/provider/theme.dart';
import 'package:cxe/routers/routers.dart';
import 'package:cxe/page/demo/home.dart';
import 'package:cxe/page/home.dart';

void main() {
  // demo演示
  final bool _isDemo = true;
  //提前初始化flutter 以便运行自定义的初始化
  WidgetsFlutterBinding.ensureInitialized();
  // 自定义初始化
  Utils.init();
  HttpManager.initDio();
  Routers.initRoutes(isDemo: _isDemo);

  FlutterError.onError = (FlutterErrorDetails details) {
    Logs.reportErrorAndLog(details);
  };

  // 沙箱异常捕获 自定义异常日志处理
  runZoned(
    () => runApp(ProviderScope(
        child: MyApp(
      isDemo: _isDemo,
    ))),
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

  if (Platform.isAndroid) {
    //安卓机上设置顶部状态栏背景为透明
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //设置为透明
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class MyApp extends StatelessWidget {
  final bool isDemo;

  MyApp({this.isDemo});

  /// 通过启动参数 指定home，默认null
  // final Widget home;
  // MyApp({this.home});
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
          themeMode: mode,
          theme: context.read(themeProvider).getTheme(),
          onGenerateRoute: Routers.generate,
          home:
              isDemo ? DemoHomePage(title: '仓小二demo') : HomePage(title: '仓小二'),
        );
      },
    );
  }
}
