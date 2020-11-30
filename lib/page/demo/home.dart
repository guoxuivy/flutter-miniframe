import 'package:cxe/page/demo/one.dart';
import 'package:cxe/page/demo/two.dart';
import 'package:cxe/page/demo/back_result.dart';
import 'package:cxe/util/utils.dart';
import 'package:flutter/material.dart';
import 'package:cxe/routers/routers.dart';
import 'package:dio/dio.dart';
import 'package:cxe/net/http_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cxe/provider/theme.dart';

/// 路由表注册
final Map<String, WidgetBuilder> demoRouterMap = {
  '/two': (_) => DemoTwoPage(),
  '/one': (_, [params]) {
    // todo 参数可加工
    String name = "默认值";
    if (params != null) {
      name = params['name'];
    }
    return DemoOnePage(args: params, name: name);
  },
};

class DemoHomePage extends StatefulWidget {
  DemoHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _DemoHomePageState createState() => _DemoHomePageState();
}

class _DemoHomePageState extends State<DemoHomePage> {
  @override
  void initState() {
    super.initState();
  }

  int _counter = 0;

  dynamic _myres = 'msg';

  void _incrementCounter() {
    ///测试全局状态 themeProvider 夜间模式
    context.read(themeProvider).change();
    CancelToken token = new CancelToken();
    HttpManager.instance
        .get('/backapi/system/env1',
            data: {'key': 'free', 'msg': '鹅鹅鹅'}, cancelToken: token)
        .then((result) {


      setState(() {
        _counter++;
        _myres=result['host'];
      });
      trace(result.data);
      trace("结果");
      trace(result['1']['a'].data==null);
      trace(result['1']['a'].isNull);
    });

    // setState(() {
    //   _counter++;
    // });
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
              '${_myres}You have pushed the button this many times:',
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
