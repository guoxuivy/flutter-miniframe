import 'package:agent/net/http_manager.dart';
import 'package:agent/net/result.dart';
import 'package:agent/widgets/ys_alert.dart';
import 'package:flutter/material.dart';

class YsAjax extends StatefulWidget {
  YsAjax({
    Key? key,
    this.url='',
    this.params,
    this.renderContent,
    this.ajaxThen,
  }) : super(key: key);

  final String url;
  final Map<String, dynamic>? params;
  final renderContent;
  final ajaxThen;

  @override
  YsAjaxState createState() => YsAjaxState();
}

/// 视图构建逻辑
class YsAjaxState extends State<YsAjax> {
  RData _data=RData(null);
  //  async
  void _handleGetData() async {
    final ajax = HttpManager.instance;
    Result result = await ajax.get(widget.url, data: widget.params, loading: true);
    _data = result.data;
    setState(() {});
    if (widget.ajaxThen != null) {
      widget.ajaxThen(_data);
    }
  }

  @override
  void initState() {
    super.initState();
    _handleGetData();
  }

  @override
  void didUpdateWidget(covariant YsAjax oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    _handleGetData();
  }

  @override
  Widget build(BuildContext context) {
    if (_data.isNull) {
      // 默认展示
      return YsAlert();
    }
    return widget.renderContent(_data);
  }
}
