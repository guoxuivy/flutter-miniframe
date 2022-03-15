import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agent/boot.dart';
import 'package:agent/config.dart';
import 'package:agent/launch.dart';
import 'package:agent/provider/user.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/PickerLocalizationsDelegate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:agent/utils/logs.dart';
import 'package:agent/provider/theme.dart';
import 'package:agent/routers/routers.dart';
import 'package:mobpush_plugin/mobpush_custom_message.dart';
import 'package:mobpush_plugin/mobpush_notify_message.dart';
import 'package:agent/provider/message.dart';

import 'package:mobpush_plugin/mobpush_plugin.dart';
import 'package:agent/utils/utils.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart'
    show BMFMapSDK, BMF_COORD_TYPE;

import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  // 显示元素边框辅助线
  // debugPaintSizeEnabled = true;
  //提前初始化flutter 以便运行自定义的初始化
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    //安卓机上设置顶部状态栏背景为透明
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, //设置为透明
      // statusBarIconBrightness: Brightness.light,
      // statusBarBrightness: Brightness.light,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    // Android 目前不支持接口设置Apikey,
    // 请在主工程的Manifest文件里设置，详细配置方法请参考官网(https://lbsyun.baidu.com/)demo
    BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
  } else if (Platform.isIOS) {
    BMFMapSDK.setApiKeyAndCoordType('LZrF77DEOp83S5saiBSoQtXCm5LFBGcG', BMF_COORD_TYPE.BD09LL);
  }
  //　更新权限
  MobpushPlugin.updatePrivacyPermissionStatus(true);
  if (Platform.isIOS) {
    MobpushPlugin.setCustomNotification();
    MobpushPlugin.setAPNsForProduction(false); //测试环境
  }

  final boot = Boot(CxeConfig());
  await boot.onReady;
  // 沙箱异常捕获 自定义异常日志处理
  FlutterError.onError = (FlutterErrorDetails details) {
    Logs.reportErrorAndLog(details);
  };
  runZonedGuarded(
    () {
      ///flutter程序的入口
      runApp(ProviderScope(
        child: MyApp(),
      ));
    },
    (Object obj, StackTrace stack) {
      ///自行自己的上报操作
      ///obj类似于msg的东西
      ///stack是报错的堆栈信息
      Logs.makeDetails(obj, stack);
    },

    ///可以获取所有的print日志信息
    zoneSpecification: ZoneSpecification(
      //自定义拦截
      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
        Logs.collectPrint(parent, zone, line); //全局 print 方法自定义收集
      },
    ),
  );
}

class MyApp1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: BasicMap(),
    );
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

        MobpushPlugin.getRegistrationId().then((Map<String, dynamic> ridMap) {
          String regId = ridMap['res'].toString();
          trace('getRegistrationId: ' + regId);
          // save regID
          context.read(userProvider).setRegistryId(regId);
        });
        //　接收消息
        MobpushPlugin.addPushReceiver((dynamic event) {
          trace("receive Message");
          Map<String, dynamic> eventMap = json.decode(event);
          Map<String, dynamic> result = eventMap['result'];
          int action = eventMap['action'];
          switch (action) {
            case 0:
              MobPushCustomMessage message = MobPushCustomMessage.fromJson(result);
              trace('Customer Message: ' + message.content);
              context.read(messageProvider).store(Message(action, message));
              break;
            case 1:
            case 2:
              MobPushNotifyMessage message = MobPushNotifyMessage.fromJson(result);
              trace('Nofify Message: ' + message.content);
              context.read(messageProvider).store(Message(action, message));
              break;
          }
        }, (dynamic event) => {trace("receive Message Error!")});

        return MaterialApp(
          title: '仓小二',
          // showPerformanceOverlay: true, //性能调试工具显示
          debugShowCheckedModeBanner: false,
          // 国际化配置
          localizationsDelegates: [
            PickerLocalizationsDelegate.delegate,
            GlobalMaterialLocalizations.delegate, // 指定本地化的字符串和一些其他的值
            GlobalCupertinoLocalizations.delegate, // 对应的Cupertino风格
            GlobalWidgetsLocalizations.delegate // 指定默认的文本排列方向, 由左到右或由右到左
          ],
          supportedLocales: [Locale("en"), Locale("zh")],
          themeMode: mode,
          theme: context.read(themeProvider).getTheme(),
          onGenerateRoute: Routers.generate,
          navigatorKey: Routers.navigatorKey,
          home: LaunchPage(),
          builder: EasyLoading.init(),
        );
      },
    );
  }
}
