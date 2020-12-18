import 'package:cxe/net/http_manager.dart';
import 'package:cxe/net/result.dart';
import 'package:cxe/util/utils.dart';
import 'package:flutter/material.dart';

/// 对原生FutureBuilder组件封装 简化调用
typedef FutureBody = Widget Function(RData result);

class YsFuture extends StatefulWidget {
  YsFuture({Key key, this.url, this.bodyFunc}) : super(key: key);
  final String url;
  final FutureBody bodyFunc;

  @override
  _YsFutureView createState() => _YsFutureView();
}

/// 视图构建逻辑
class _YsFutureView extends State<YsFuture> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return FutureBuilder(
      future: HttpManager().get(widget.url),
      builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return widget.bodyFunc(snapshot.data.data);
            }
        }
        return null;
      },
    );
  }
}
