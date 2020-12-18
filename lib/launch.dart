//启动页面
import 'dart:async';

import 'package:cxe/boot.dart';
import 'package:cxe/page/demo/home.dart';
import 'package:cxe/page/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
  final String launchImage =
      "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=1093264713,2279663012&fm=26&gp=0.jpg";
  int _countdown = 2;
  Timer _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startRecordTime();
    // print('初始化启动页面');
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
          Navigator.of(context).pop();
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return Boot.instance.config.isDemo
                ? DemoHomePage(title: '仓小二demo')
                : HomePage(title: '仓小二');
          }));

          _countdownTimer.cancel();
          _countdownTimer = null;
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
          Image.network(launchImage, fit: BoxFit.fill),
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
