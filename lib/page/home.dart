import 'dart:math';

import 'package:cxe/net/result.dart';
import 'package:cxe/page/section/store_list_section.dart';
import 'package:cxe/page/section/ys_future.dart';
import 'package:cxe/res/colors.dart';
import 'package:cxe/res/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cxe/provider/theme.dart';
import 'package:cxe/routers/routers.dart';
import 'package:cxe/util/utils.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _HomeView();
}

/// 视图状态控制逻辑  可直接限定类型为HomePage
mixin _HomeStateMixin on State<HomePage> {
  int _selectedIndex = 1;
  String _searchStr;

  // 页面需要的接口数据
  Result _data = Result.nul();

  final List _navList = [
    {'label': '仓库', 'icon': Icons.account_balance, 'to': '/store'},
    {'label': '厂房', 'icon': Icons.location_city, 'to': '/store'},
    {'label': '土地', 'icon': Icons.landscape, 'to': '/store'},
    {'label': '需求', 'icon': Icons.hot_tub, 'to': '/store'},
    {'label': '选址', 'icon': Icons.rv_hookup, 'to': '/store'},
    {'label': '招商', 'icon': Icons.store_mall_directory, 'to': '/store'},
    {'label': '资讯', 'icon': Icons.tv, 'to': '/login'},
    {'label': '占位子', 'textColor': Colors.white},
  ];



  initState() {
    super.initState();
    // 使用异步数据会有多次build的问题 通过YsFuture使用异步数据
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

}

/// 视图构建逻辑
class _HomeView extends State<HomePage> with _HomeStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarSection(),
      body: SingleChildScrollView(
        // 高度滚动起来
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Image.asset(
                'assets/images/banner.png',
              ),
            ),
            navSection(),
            reportSection(),
            // StoreListSection(data: _data['stores']),
            YsFuture(
              //异步加载组建封装
              url: '/wapi/home/indexData',
              bodyFunc: (result) => StoreListSection(data: result),
            ),
            RaisedButton(
              child: Text("登录"),
              onPressed: () => Routers.go(context, "/login"),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "地图"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "发布"),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: "消息"),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: "我的"),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget reportSection() {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colours.bg_gray,
            width: 1,
            style: BorderStyle.solid,
          ),
          bottom: BorderSide(
            color: Colours.bg_gray,
            width: 10,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 110,
              child: Column(children: [
                Text("4.3亿",
                    style: TextStyle(color: Colors.red, fontSize: 16.0)),
                Text("库房总面积(㎡)"),
              ]),
            ),
            Container(
              width: 110,
              child: Column(children: [
                Text("300+",
                    style: TextStyle(color: Colors.red, fontSize: 16.0)),
                Text("覆盖城市"),
              ]),
            ),
            Container(
              width: 110,
              child: Column(children: [
                Text("1.2万+",
                    style: TextStyle(color: Colors.red, fontSize: 16.0)),
                Text("入驻企业"),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  // 导航块
  Widget navSection() {
    // 一行nav
    List<Widget> _buildRowNav(List list) {
      List<Widget> rowNav = []; //先建一个数组用于存放循环生成的widget
      for (var item in list) {
        rowNav.add(
          GestureDetector(
              onTap: () => Routers.go(context, item['to']),
              child: Column(
                children: [
                  Icon(item['icon'], size: 40),
                  Text(item['label'],
                      style: TextStyle(color: item['textColor'])),
                ],
              )),
        );
      }
      return rowNav;
    }

    return Container(
        padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 20),
        child: Column(
          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildRowNav(_navList.sublist(0, 4))),
            Container(
              padding: EdgeInsets.only(top: 20),
              child: Row(
                  //平均分配
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: _buildRowNav(_navList.sublist(4, 8))),
            ),
          ],
        ));
  }

  // 头部搜索块
  AppBar appBarSection() {
    return AppBar(
        automaticallyImplyLeading: false, // 不要默认返回按钮
        backgroundColor: Colours.dark_button_text,
        title: Row(
          children: [
            Container(
              width: 40,
              child: Text(
                '广州',
                style: TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
            Container(
              // width: 20,
              child: Icon(Icons.expand_more, color: Colors.black38, size: 20),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                ),
                height: 30,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _searchStr = Random().nextInt(10).toString();
                    });
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                          width: 25,
                          child:
                              Icon(Icons.search, color: Colors.grey, size: 15)),
                      Expanded(
                        child: Container(
                          child: Text(
                            _searchStr ?? '点击搜索仓库、厂房、土地',
                            style: TextStyle(color: Colors.grey, fontSize: 16),
                          ),
                        ),
                      ),
                      Container(
                          width: 30,
                          // color: Colors.red,
                          alignment: Alignment.center,
                          // height: 58,
                          child: IconButton(
                              icon: Icon(Icons.clear),
                              color: Colors.grey,
                              iconSize: 15,
                              // padding: EdgeInsets.only(top: 3),
                              onPressed: () {
                                setState(() {
                                  _searchStr = null;
                                });
                              })),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
