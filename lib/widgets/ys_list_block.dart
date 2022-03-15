import 'package:agent/net/http_manager.dart';
import 'package:agent/net/result.dart';
import 'package:flutter/material.dart';

/// 渲染方法类型约束
typedef RDataRenderFunc = Widget Function(RData item, int i);

class YsListBlock extends StatefulWidget {
  const YsListBlock({
    Key? key,
    // this.data,
    @required this.url,
    this.params,
    @required this.renderItem,
    this.ajaxThen,
  }) : super(key: key);

  // final List data;
  final url;
  final Map? params;
  final RDataRenderFunc? renderItem;
  final ajaxThen;

  @override
  State<StatefulWidget> createState() {
    return YsListBlockState();
  }
}

class YsListBlockState extends State<YsListBlock> {
  List _data = [];
  int _syncDone=0;

  //  async
  void _handleGetData() async {
    _syncDone = 0;
    final ajax = HttpManager.instance;
    Result result = await ajax.get(widget.url, data: widget.params);
    if (widget.params!['page_index'] == 1) {
      _data = result['list'].d ?? [];
    } else {
      // _data.d
      _data.addAll(result['list'].d);
    }
    _syncDone = 1;
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant YsListBlock oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    // _handleGetData();
  }

  @override
  void initState() {
    super.initState();
    widget.params!['page_index'] = widget.params!['page_index'] ?? 1;
    _handleGetData();
  }

  @override
  Widget build(BuildContext context) {
    // _data = RData(_data).d;
    if (_syncDone == 1 && _data.length == 0) {
      return Center(child: Text('暂无数据'));
    }
    List<Widget> _children = [];
    for (var i = 0; i < _data.length; i++) {
      var _item = _data[i];
      _children.add(widget.renderItem!(RData(_item), i));
    }
    return Column(
      children: _children,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
