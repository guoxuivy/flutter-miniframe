import 'package:flutter/material.dart';

import 'package:agent/routers/routers.dart';

class DemoTwoPage extends StatefulWidget {
  @override
  _DemoTwoPageState createState() => _DemoTwoPageState();
}

class _DemoTwoPageState extends State<DemoTwoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///定义页面的标题
      appBar: AppBar(
        title: Text("test_two", style: Theme.of(context).textTheme.subtitle2),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            child: Text("抛出一个未捕获的异常"),
            onPressed: () => throw StateError('我是个未捕获的异常。'),
          ),
          RaisedButton(
            child: Text("Click me to test_one"),
            onPressed: () => Routers.go(context, "/one"),
          ),
          RaisedButton(
            child: Text("Click me to test_one with args"),
            onPressed: () => Routers.go(context, "/one", {"name": "我是测试参数"}),
          ),
          RaisedButton(
            child: Text("Click me to goBack"),
            onPressed: () => Routers.goBack(context),
          ),
          RaisedButton(
            child: Text("Click me to /"),
            onPressed: () => Routers.go(context, "/"),
          ),
        ],
      )),
    );
  }
}
