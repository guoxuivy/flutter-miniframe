import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cxe/net/http_manager.dart';
import 'package:cxe/page/demo/back_result.dart';
import 'package:cxe/provider/theme.dart';
import 'package:cxe/routers/routers.dart';
import 'package:cxe/util/utils.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  int _counter = 0;

  void _incrementCounter() {
    ///测试全局状态 themeProvider 夜间模式
    context.read(themeProvider).change();
    CancelToken token = new CancelToken();
    HttpManager.instance
        .get('/backapi/system/stat',
            data: {'key': 'free', 'msg': '鹅鹅鹅'}, cancelToken: token)
        .then((json) {
      trace(json);
    });

    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: Theme.of(context).textTheme.subtitle2,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            RaisedButton(
              child: Text("Click me to test_two"),
              onPressed: () => Routers.go(context, "/two"),
            ),
            RaisedButton(
              child: Text("Click me to home404"),
              onPressed: () => Routers.go(context, "/home404"),
            ),
            RaisedButton(
              child: Text("test back result"),
              //打开一个页面 接受pop返回参数 result
              onPressed: () {
                Navigator.push<Object>(context,
                    new MaterialPageRoute(builder: (BuildContext context) {
                  return DemoBackResultPage();
                })).then((Object result) {
                  //处理代码
                  print(result);
                });
              },
            ),
            RaisedButton(
              child: Icon(Icons.add),
              onPressed: _incrementCounter,
            ),
          ],
        ),
      ),
    );
  }
}
