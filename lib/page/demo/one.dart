import 'package:flutter/material.dart';
import 'package:cxe/routers/routers.dart';

class DemoOnePage extends StatelessWidget {
  DemoOnePage({Key key, this.args, this.name}) : super(key: key);
  final Map args;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///定义页面的标题
      appBar: AppBar(
        title: Text("test_one", style: Theme.of(context).textTheme.subtitle2),
      ),
      body: Center(
          child: RaisedButton(
        child: Text("${name}Click me to test_two"),
        onPressed: () => Routers.go(context, "/two"),
      )),
    );
  }
}
