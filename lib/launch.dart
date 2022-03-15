//启动页面
import 'dart:async';
import 'package:agent/boot.dart';
import 'package:agent/config.dart';
import 'package:agent/storage/property.dart';
import 'package:flutter/material.dart';

import 'package:flutter_xupdate/flutter_xupdate.dart';

class LaunchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LaunchState();
}

class LaunchState extends State<LaunchPage> {
  int _countdown = 2;
  Timer? _countdownTimer;
  String _message = '';

  ///初始化XUpdate app更新
  void initXUpdate() {
    FlutterXUpdate.init(

            ///是否输出日志
            debug: Boot.debug,

            ///是否使用post请求
            isPost: false,

            ///post请求是否是上传json
            isPostJson: false,

            ///请求响应超时时间
            timeout: 25000,

            ///是否开启自动模式
            isWifiOnly: false,

            ///是否开启自动模式
            isAutoMode: false,

            ///需要设置的公共参数
            supportSilentInstall: false,

            ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
            enableRetry: false)
        .then((value) {
      updateMessage('初始化成功: $value');
    });

    FlutterXUpdate.setErrorHandler(onUpdateError: (message) async {
      // print(message);
      //下载失败
      if (message != null && message["code"] == 4000) {
        FlutterXUpdate.showRetryUpdateTipDialog(
            retryContent: "网络异常？换个wifi试一试？", retryUrl: "https://www.cangxiaoer.com");
      }
      setState(() {
        _message = "$message";
      });
    });
  }

  void updateMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  /// 检查更新地址
  /// /api/index/agentVersion
  // $res = [
  //             "Code"=>0,
  //             "Msg"=>'',
  //             "UpdateStatus"=>1, //1可选升级,2强制升级
  //             "VersionCode"=>2,
  //             "VersionName"=>'1.2.1',
  //             "UploadTime"=>'2021-10-20 15:28:51',
  //             "ModifyContent"=>"\r\n1、优化api接口。\r\n2、修复发布bug。\r\n3、升级底层框架。",
  //             "DownloadUrl"=>'https://www.cangxiaoer.com/static/app/release/xzgw1.2.1-2019-12-31-15-09.apk',
  //             // "ApkSize"=>'53048',
  //             // "ApkMd5"=>'E4B79A36EFB9F17DF7E3BB161F9BCFD8',
  //         ];
  //         // $this->success('ok',$res);
  //         echo json_encode($res);die;
  String checkUpdateUrl = Boot.config.apiBaseUrl + '/api/index/agentVersion';

  @override
  void initState() {
    super.initState();
    initXUpdate();
    FlutterXUpdate.checkUpdate(url: checkUpdateUrl);

    Property.initAllData();
    _startRecordTime();
    // 绘制完成触发，不然 如果依赖context会报错
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      MediaQueryData queryData = MediaQuery.of(context);
      if (queryData.size.width * queryData.devicePixelRatio > 1000) {
        // 设定屏幕分辨率系数
        Boot.instance.setScreenX(3);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _countdownTimer?.cancel();
    // print('启动页面结束');
    // if (_countdownTimer != null && _countdownTimer.isActive) {
    //   _countdownTimer.cancel();
    //   _countdownTimer = null;
    // }
  }

  void toHome() {
    //需要主动销毁，防止黑屏
    _countdownTimer?.cancel();
    Navigator.pushReplacementNamed(context, "/home");
  }

  void _startRecordTime() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown <= 1) {
          toHome();
        } else {
          _countdown -= 1;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Image.asset(
            "assets/images/launch.png",
            fit: BoxFit.fitWidth,
          ),
          Positioned(
            top: 30,
            right: 30,
            child: InkWell(
              onTap: () {
                toHome();
              },
              child: Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.black12,
                ),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: '跳过',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        )),
                    TextSpan(
                        text: '$_countdown',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.red,
                        )),
                  ]),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
