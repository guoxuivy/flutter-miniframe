import 'package:agent/net/http_manager.dart';
import 'package:agent/net/result.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/buttons/ys_button_sort.dart';
import 'package:agent/widgets/ys_alert.dart';
import 'package:agent/widgets/ys_filter_bar.dart';
import 'package:flutter/material.dart';

/// 渲染方法类型约束
typedef RDataRenderFunc = Widget Function(RData item, int i);
typedef OnFinishFunc = void Function(Result);
typedef OnParamsChangeEvent = void Function(Map<String, dynamic>);

class YsList extends StatefulWidget {
  YsList({
    Key? key,
    // this.data,
    required this.url,
    params,
    required this.renderItem,
    this.ajaxThen,
    this.onScroll,
    this.preappend,
    this.filterOptions,
    this.sortOptions,
    this.once = false,
    this.showToast = false,
    this.showToastText = '为您找到 total 条数据',
    this.onParamChange,
    this.separatorBuilder,
    this.showLoading = false,
  }) : params = params ?? {'page_index': 1};

  // final List data;
  final url;
  final Map<String, dynamic> params;
  final RDataRenderFunc renderItem;
  final ajaxThen;
  final onScroll;
  final preappend;
  final filterOptions;
  final sortOptions;

  // 只加载一次
  final bool once;
  final bool showToast;
  final String showToastText;
  final OnParamsChangeEvent? onParamChange;
  final separatorBuilder;
  final showLoading;

  @override
  State<StatefulWidget> createState() {
    return YsListState();
  }
}

class YsListState extends State<YsList> {
  ScrollController scrollController = new ScrollController();
  List _data = [];
  int _syncDone = 0;
  double st = 0;

  //  async
  Future getData() async {
    _syncDone = 0;
    final ajax = HttpManager.instance;
    Result result = await ajax.get(widget.url, data: widget.params, loading: widget.showLoading);
    if (widget.params['page_index'] == 1) {
      _data = result['list'].d ?? [];

      var _total = result['page']['total'].d ?? 0;
      if (widget.showToast && _total > 0) {
        Dialogs.showToast(
          msg: widget.showToastText.replaceAll('total', '$_total'),
        );
      }
      // 第一页时需要重置到顶部
      st = 0;
    } else {
      // _data.d
      _data.addAll(result['list'].d);
    }
    _syncDone = 1;
    if (widget.ajaxThen != null) {
      Future.delayed(Duration.zero, () => widget.ajaxThen(result));
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(covariant YsList oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    trace('ysList didUpdateWidget');
    if (oldWidget.params != widget.params) {
      widget.params['page_index'] = 1;
      getData();
    }
  }

  @override
  void initState() {
    super.initState();
    widget.params['page_index'] = widget.params['page_index'] ?? 1;
    getData();
    scrollController.addListener(() {
      trace('ysList scrollControllerListener');
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
          !widget.once) {
        widget.params['page_index'] = widget.params['page_index'] ?? 1;
        widget.params['page_index']++;
        getData();
      }
      if (widget.onScroll != null) {
        widget.onScroll(scrollController.position.pixels);
      }
      // st 优化preappend动态显示
      if (widget.preappend != null && (scrollController.position.pixels < 200 && st > 200) ||
          (scrollController.position.pixels > 200 && st < 200)) {
        setState(() {});
      }
      st = scrollController.position.pixels;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _preappend = Container();
    if (widget.preappend != null && st < 200) {
      if (widget.preappend is Widget) {
        _preappend = widget.preappend;
      } else {
        _preappend = widget.preappend(_data);
      }
    }
    trace('ysList build');
    if (widget.filterOptions == null) {
      // 简单的列表
      return Column(
        children: [
          _preappend,
          Expanded(
            child: _syncDone == 1 && _data.length == 0
                ? YsAlert()
                : ListView.separated(
                    // 嵌套不显示
                    shrinkWrap: true,
                    itemCount: _data.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        widget.separatorBuilder != null
                            ? widget.separatorBuilder(index)
                            : Container(),
                    itemBuilder: (BuildContext context, int i) {
                      return widget.renderItem(RData(_data[i]), i);
                    },
                    controller: scrollController,
                  ),
          ),
        ],
      );
    }
    return Column(
      children: [
        widget.preappend != null && st < 200 ? widget.preappend : Container(),
        Expanded(
          child: YsFilterBar(
            options: widget.filterOptions is List
                ? widget.filterOptions
                : widget.filterOptions(widget.params),
            params: widget.params,
            onChange: (params) {
              params['page_index'] = 1;
              widget.params.addAll(params);
              getData();
              if (widget.onParamChange != null) {
                Function.apply(widget.onParamChange!, [widget.params]);
              }
            },
            child: RefreshIndicator(
              onRefresh: () {
                widget.params.addAll({
                  'page_index': 1,
                });
                return getData();
              },
              child: _syncDone == 1 && _data.length == 0
                  ? YsAlert()
                  : ListView.separated(
                      // 嵌套不显示
                      shrinkWrap: true,
                      itemCount: _data.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          widget.separatorBuilder != null
                              ? widget.separatorBuilder(index)
                              : Container(),
                      itemBuilder: (BuildContext context, int i) {
                        return widget.renderItem(RData(_data[i]), i);
                      },
                      controller: scrollController,
                    ),
            ),
            append: widget.sortOptions != null
                ? YsButtonSort(
                    items: widget.sortOptions,
                    onPressed: (typeId) {
                      widget.params.addAll({
                        'sort': typeId,
                        'page_index': 1,
                      });
                      getData();
                      if (widget.onParamChange != null) {
                        Function.apply(widget.onParamChange!, [widget.params]);
                      }
                    },
                  )
                : Container(),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
