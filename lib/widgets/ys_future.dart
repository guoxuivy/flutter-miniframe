import 'package:agent/net/http_manager.dart';
import 'package:agent/net/result.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 对原生FutureBuilder组件封装 简化调用
class YsFuture extends StatefulWidget {
  YsFuture({Key? key, required this.url, this.isPost = false, this.params, required this.bodyFunc}) : super(key: key);
  final String url;
  final bool isPost;
  final Map<String, dynamic>? params;
  final RDataRender bodyFunc;

  @override
  _YsFutureView createState() => _YsFutureView();
}

/// 视图构建逻辑
class _YsFutureView extends State<YsFuture> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.isPost
          ? HttpManager().post(widget.url, data: widget.params)
          : HttpManager().get(widget.url, data: widget.params),
      builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(),
            );
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              return widget.bodyFunc(snapshot.data!.data);
            }
            break;
          default:
            break;
        }
        return Container();
      },
    );
  }
}
