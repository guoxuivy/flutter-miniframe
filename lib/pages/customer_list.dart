import 'package:flutter/material.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/ys_future.dart';
import 'package:agent/provider/param.dart';
import 'package:agent/pages/section/customer_list_section.dart';
import 'package:flutter/rendering.dart';

class CustomerListPage extends StatefulWidget {
  CustomerListPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _CustomerListView();
}


/// 视图构建逻辑
class _CustomerListView extends State<CustomerListPage> {
  Map<String, dynamic> listParams = {};

  /// 更新列表
  _submit(params) {
    setState(() {
      listParams = params;
    });
  }

  Widget _dropDownFilter() {
    return DropDownFilter(
      buttons: [
        FilterButtonModel(
          title: '区域',
          type: 'Row',
          contents: ['默认排序', '面积最大', '面积最小', '价格最低', '价格最高'],
        ),
        FilterButtonModel(
          title: '类型',
          type: 'Column',
          contents: [
            '最低税1',
            '最低税2',
            '最低税3',
            '最高税4',
            '测试5',
            '测试',
            '测试',
            '测试',
            '测试',
            '测试'
          ],
        ),
        FilterButtonModel(
          title: '排序',
          callback: () {
            Navigator.pushNamed(context, '/animation/firstDemo');
          },
        )
      ],
      //两种方式传递接口参数
      otherWidget: Container(
        // child: Consumer(
        //   builder: (context,watch,_){
        //     Map<String,dynamic> params = watch(paramProvider).data;
        //     return YsFuture(
        //       //异步加载组建封装
        //       url: '/wapi/home/indexData',
        //       params: params,
        //       bodyFunc: (result) => StoreListSection(data: result),
        //     );
        //   },
        // ),
        child: YsFuture(
          //异步加载组建封装
          url: '/agentmobileapi/Customer/customersList',
          params: listParams,
          isPost: true,
          bodyFunc: (result) => CustomerListSection(data: result),
        ),
      ),
      submit: (prams) => _submit(prams),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('下拉筛选列表'),
      ),
      body: SingleChildScrollView(
        child: _dropDownFilter(),
      ),
    );
  }
}


class DropDownFilter extends StatefulWidget {
  DropDownFilter({Key key, this.otherWidget, this.buttons, this.submit});

  final submit;

  final Widget otherWidget; //页面除了筛选按钮部分Widget：列表内容
  final List<FilterButtonModel> buttons; //按钮数组 数据类型FilterButtonModel

  @override
  _DropDownFilterState createState() => _DropDownFilterState();
}

class _DropDownFilterState extends State<DropDownFilter>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  bool isMask = false; //下拉蒙层是否显示
  int atIndex = 0; //当前正在操作的下拉筛选组

  initState() {
    // TODO: implement initState
    super.initState();

    // 展开筛选菜单动画
    controller = new AnimationController(
        duration: const Duration(milliseconds: 100), vsync: this);
    animation = new Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        //这行如果不写，没有动画效果
        setState(() {});
      });
  }

  /// 选中筛选条件事件处理 条件保存
  void onClick(String str) {
    trace(str);
  }

  void onSubmit() {
    trace('提交');
  }

  void onReset() {
    trace('重置');
  }

  void triggerMask() {
    setState(() {
      isMask = !isMask;
    });
  }

  void triggerIcon(btn) {
    if (btn.direction == 'up') {
      btn.direction = 'down';
    } else {
      btn.direction = 'up';
    }
  }

  void initButtonStatus() {
    widget.buttons.forEach((i) {
      setState(() {
        i.direction = 'down';
      });
    });
  }

  //切换筛选组件
  void changeIndex(i) {
    setState(() {
      atIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      // alignment: AlignmentDirectional.topCenter,
      //stack设置为overflow：visible之后，内部的元素中超出的部分就不能触发点击事件；所以尽量避免这种布局
      children: <Widget>[
        Column(
          children: <Widget>[_button(), widget.otherWidget],
        ),
        _filterBlock(widget.buttons[atIndex]),
      ],
    );
  }

  //筛选按钮
  Widget _button() {
    return Row(
      children: List.generate(widget.buttons.length, (i) {
        final thisButton = widget.buttons[i];
        return SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width / widget.buttons.length,
          child: FlatButton(
            padding: EdgeInsets.only(top: 0, left: 10),
            child: Row(
              children: <Widget>[
                Text(
                  thisButton.title,
                ),
                _rotateIcon(thisButton.direction)
              ],
            ),
            onPressed: () {
              //处理 下拉列表打开时，点击别的按钮
              if (isMask && i != atIndex) {
                initButtonStatus();
                triggerIcon(widget.buttons[i]);
                changeIndex(i);
                return;
              }

              changeIndex(i);
              if (widget.buttons[atIndex].callback == null) {
                if (animation.status == AnimationStatus.completed) {
                  controller.reverse();
                } else {
                  controller.forward();
                }
                triggerMask();
              } else {
                widget.buttons[atIndex].callback();
              }
              triggerIcon(widget.buttons[i]);
            },
          ),
        );
      }),
    );
  }

  //筛选弹出的下拉区域
  Widget _filterBlock(FilterButtonModel lists) {
    if (lists.contents != null && lists.contents.length > 0) {
      // 下拉区域最大高度
      MediaQueryData mq = MediaQuery.of(context);
      double saveHeight = mq.size.height -
          kToolbarHeight -
          50 -
          kBottomNavigationBarHeight; // 50筛选按钮高度
      if (lists.contents.length * 50.0 < saveHeight) {
        saveHeight = lists.contents.length * 50.0;
      }

      return Positioned(
          width: MediaQuery.of(context).size.width,
          top: 50,
          left: 0,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                height: animation.value * saveHeight,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _innerFilterBlock(lists)),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Row(children: [
                          RaisedButton(
                            onPressed: onReset,
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text("重置"),
                          ),
                          Spacer(),
                          RaisedButton(
                            onPressed: onSubmit,
                            color: Colors.blue,
                            textColor: Colors.white,
                            child: Text("提交"),
                          ),
                        ]))
                  ],
                ),
              ),
              _mask()
            ],
          ));
    } else {
      return Container(
        height: 0,
      );
    }
  }

  /// 渲染下拉框内容
  Widget _innerFilterBlock(FilterButtonModel lists) {
    if (lists.type == 'Row') {
      return Container(
          padding: EdgeInsets.only(left: 10, right: 10, top: 15),
          child: Wrap(
            alignment: WrapAlignment.start,
            verticalDirection: VerticalDirection.down,
            runSpacing: 15,
            children: List.generate(lists.contents.length, (i) {
              return GestureDetector(
                  onTap: () => onClick(lists.contents[i]),
                  child: Container(
                      width:
                      (MediaQuery.of(context).size.width - 20) / 3, //每行显示3个
                      child: Container(
                        margin: EdgeInsets.only(left: 5, right: 5),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Color.fromRGBO(216, 216, 216, 0.3),
                        ),
                        child: Text(lists.contents[i]),
                      )));
            }),
          ));
    } else {
      return ListView(
        children: List.generate(lists.contents.length, (i) {
          return GestureDetector(
              onTap: () => onClick(lists.contents[i]),
              child: Container(
                height: 50,
                padding: EdgeInsets.only(top: 15, left: 15, bottom: 15),
                child: Text(
                  lists.contents[i],
                  style: TextStyle(),
                ),
              ));
        }),
      );
    }
  }

  //筛选的黑色蒙层
  Widget _mask() {
    if (isMask) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color.fromRGBO(0, 0, 0, 0.5),
      );
    } else {
      return Container(
        height: 0,
      );
    }
  }

  //右侧旋转箭头组建
  Widget _rotateIcon(direction) {
    if (direction == 'up') {
      return Icon(Icons.keyboard_arrow_up, color: Colors.orange);
    } else {
      return Icon(Icons.keyboard_arrow_down, color: Colors.orange);
    }
  }

  dispose() {
    controller.dispose();
    super.dispose();
  }
}

class FilterButtonModel {
  String title; //按钮title
  List contents; //下拉列表
  String type; //下拉筛选类型 'Column'、'Row'
  Function callback; //按钮点击回调，可以自定义回调，如跳转页面等
  String direction; //下拉箭头方向

  FilterButtonModel(
      {this.title, this.contents, this.type, this.callback, this.direction});
}
