import 'package:flutter/material.dart';
import 'package:agent/routers/routers.dart';

class DemoBackResultPage extends StatefulWidget {
    @override
    _DemoBackResultPageState createState() => _DemoBackResultPageState();
}
class _DemoBackResultPageState extends State<DemoBackResultPage>{
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            ///定义页面的标题
            appBar: AppBar(
                title: Text("test goBackWithParams",style: Theme.of(context).textTheme.subtitle2),
            ),
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        RaisedButton(
                            child: Text("Click me to goBackWithParams"),
                            onPressed: () => Routers.goBackWithParams(context, {"title":"BackWithParam测试"}),
                        ),
                    ],
                )
            ),
        );
    }
}
