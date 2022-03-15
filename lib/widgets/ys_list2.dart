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

// controller
class ListController {
  String url;
  String showToastText;
  Map<String, dynamic> params;
  Map<String, dynamic>? copyData;
  Function? ajaxThen;
  var ajaxBefore;
  bool showToast = false;
  bool showLoading = false;

  ListController({this.url = '', this.ajaxThen, showToastText, showToast, params, ajaxBefore})
      : params = Map<String, dynamic>.from(params ?? {'page_index': 1}),
        ajaxBefore = ajaxBefore ??
            ((d) {
              return true;
            }),
        showToastText = showToastText ?? '为您找到 total 条数据',
        copyData = Map<String, dynamic>.from(params ?? {});

  setOption({url, params, ajaxThen, showToastText, ajaxBefore, showToast, showLoading}) {
    this.url = url ?? this.url;
    this.showToastText = showToastText ?? this.showToastText;
    // 类型兼容
    this.params = Map<String, dynamic>.from(params ?? this.params);
    this.ajaxThen = ajaxThen ?? this.ajaxThen;
    this.ajaxBefore = ajaxBefore ?? this.ajaxBefore;
    this.showToast = showToast ?? this.showToast;
    this.showLoading = showLoading ?? this.showLoading;
  }

  setParams(params) {
    Map<String, dynamic> _params = Map.from(params ?? {});
    List _keys = _params.keys.toList();
    Utils.forEach(_keys, (key, i) {
      if (_params[key] != null && _params[key] != -999) {
        this.params[key] = _params[key];
      } else {
        this.params.remove(key);
      }
    });
    // this.params.addAll(params);
    return getData();
  }

  reset() {
    if (this.copyData != null) {
      this.params = Map.from(this.copyData!);
    }
  }

  List data = [];
  int syncDone = 0;
  //  async
  Future getData() async {
    syncDone = 0;
    final ajax = HttpManager.instance;
    this.params['page_index'] = this.params['page_index'] ?? 1;
    Result result = await ajax.get(this.url, data: this.params, loading: showToast);
    trace(this.params);
    if (this.params['page_index'] == 1) {
      data = result['list'].d ?? [];
      var _total = result['page']['total'].d ?? 0;
      if (showToast && _total > 0) {
        Dialogs.showToast(
          msg: this.showToastText.replaceAll('total', '$_total'),
        );
      }
      // 第一页时需要重置到顶部
      // st = 0;
    } else {
      // data.d
      data.addAll(result['list'].d);
    }
    syncDone = 1;
    this.ajaxThen!(result);
/*     if (this.ajaxThen != null) {
      Future.delayed(Duration.zero, () => this.ajaxThen!(result));
    }
 */
    return result;
  }

  dispose() {
    this.params = {};
    this.copyData = {};
  }
}

class YsList2 extends StatefulWidget {
  YsList2({
    Key? key,
    // this.data,
    params,
    required this.renderItem,
    this.onScroll,
    this.preappend,
    this.filterOptions,
    this.sortOptions,
    this.once = false,
    this.onParamChange,
    this.separatorBuilder,
    this.filterMainAxisAlignment,
    required this.controller,
  }) : super(key: key);

  // final List data;
  final RDataRenderFunc renderItem;
  final onScroll;
  final preappend;
  final filterOptions;
  final sortOptions;

  // 只加载一次
  final bool once;
  final OnParamsChangeEvent? onParamChange;
  final separatorBuilder;
  final MainAxisAlignment? filterMainAxisAlignment;
  final ListController controller;

  @override
  State<StatefulWidget> createState() {
    return YsList2State();
  }
}

class YsList2State extends State<YsList2> {
  ScrollController scrollController = new ScrollController();
  double st = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.setOption(ajaxThen: ((res) {
      if (widget.controller.params['page_index'] == 1) {
        st = 0;
      }
      setState(() {});
    }));
    widget.controller.getData();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
          !widget.once) {
        int _pageIndex = widget.controller.params['page_index'] ?? 1;
        widget.controller.setParams({'page_index': _pageIndex + 1});
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
  void didUpdateWidget(covariant YsList2 oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
    // setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Widget _preappend = Container();
    if (widget.preappend != null && st < 200) {
      if (widget.preappend is Widget) {
        _preappend = widget.preappend;
      } else {
        _preappend = widget.preappend(widget.controller.data);
      }
    }
    trace('ysList2 build');
    if (widget.filterOptions == null) {
      // 简单的列表
      return Column(
        children: [
          _preappend,
          Expanded(
            child: widget.controller.syncDone == 1 && widget.controller.data.length == 0
                ? YsAlert()
                : ListView.separated(
                    // 嵌套不显示
                    shrinkWrap: true,
                    itemCount: widget.controller.data.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        widget.separatorBuilder != null
                            ? widget.separatorBuilder(index)
                            : Container(),
                    itemBuilder: (BuildContext context, int i) {
                      return widget.renderItem(RData(widget.controller.data[i]), i);
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
            options: widget.filterOptions,
            mainAxisAlignment: widget.filterMainAxisAlignment,
            params: widget.controller.params,
            onChange: (params) {
              params['page_index'] = 1;
              widget.controller.setParams(params);
              if (widget.onParamChange != null) {
                Function.apply(widget.onParamChange!, [widget.controller.params]);
              }
            },
            child: RefreshIndicator(
              onRefresh: () {
                return widget.controller.setParams({
                  'page_index': 1,
                });
              },
              child: widget.controller.syncDone == 1 && widget.controller.data.length == 0
                  ? YsAlert()
                  : ListView.separated(
                      // 嵌套不显示
                      shrinkWrap: true,
                      itemCount: widget.controller.data.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          widget.separatorBuilder != null
                              ? widget.separatorBuilder(index)
                              : Container(),
                      itemBuilder: (BuildContext context, int i) {
                        return widget.renderItem(RData(widget.controller.data[i]), i);
                      },
                      controller: scrollController,
                    ),
            ),
            append: widget.sortOptions != null
                ? YsButtonSort(
                    items: widget.sortOptions,
                    onPressed: (typeId) {
                      widget.controller.setParams({
                        'sort': typeId,
                        'page_index': 1,
                      });
                      if (widget.onParamChange != null) {
                        Function.apply(widget.onParamChange!, [widget.controller.params]);
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
    // widget.controller.dispose();
    super.dispose();
  }
}
