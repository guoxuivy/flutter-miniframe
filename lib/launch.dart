//启动页面
import 'dart:async';
import 'package:agent/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:agent/boot.dart';
import 'package:agent/pages/demo/home.dart';
import 'package:agent/pages/home.dart';

class LaunchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LaunchPageWidget();
  }
}

class LaunchPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LaunchState();
}

class LaunchState extends State<LaunchPageWidget> {
  int _countdown = 2;
  Timer _countdownTimer;
  bool _upgrade = false; //更新检测是否执行完毕

  @override
  void initState() {
    super.initState();
    _startRecordTime();
    // 绘制完成触发，不然 如果依赖context会报错
    WidgetsBinding.instance.addPostFrameCallback((_){
      Boot.instance.checkVersion().then((_){
          _upgrade = true;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    // print('启动页面结束');
    if (_countdownTimer != null && _countdownTimer.isActive) {
      _countdownTimer.cancel();
      _countdownTimer = null;
    }
  }

  void _startRecordTime() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_countdown <= 1) {
          if(_upgrade){
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return Boot.instance.config.isDemo
                  ? DemoHomePage(title: '仓小二demo')
                  : HomePage(title: '仓小二');
            }));

            _countdownTimer.cancel();
            _countdownTimer = null;
          }
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
            "assets/images/launch.jpg",
            fit: BoxFit.fill,
          ),
          Positioned(
            top: 30,
            right: 30,
            child: Container(
              padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12,
              ),
              child: RichText(
                text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: '$_countdown',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue,
                      )),
                  TextSpan(
                      text: '跳过',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red,
                      )),
                ]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
