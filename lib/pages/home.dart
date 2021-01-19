import 'package:flutter/material.dart';
import 'package:agent/pages/section/search_bar_section.dart';
import 'package:agent/pages/section/store_list_tab_section.dart';
import 'package:agent/widgets/ys_future.dart';
import 'package:agent/widgets/ys_stack_icon.dart';
import 'package:agent/res/colors.dart';
import 'package:agent/res/resources.dart';
import 'package:agent/routers/routers.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  State<StatefulWidget> createState() => _HomeView();
}

/// 视图状态控制逻辑  可直接限定类型为HomePage
mixin _HomeStateMixin on State<HomePage> {
  int _selectedIndex = 1;

  final List _nav = [
    {'label': '线索', 'do': false, 'icon': Icons.account_balance, 'to': '/store', 'num': 0},
    {'label': '订单', 'do': true, 'icon': Icons.location_city, 'to': '/store', 'num': 1},
    {'label': '合同', 'do': true, 'icon': Icons.landscape, 'to': '/store', 'num': 1},
    {'label': '经营管理', 'do': true, 'icon': Icons.hot_tub, 'to': '/store', 'num': 1},
  ];
  final List _backlogs = [
    {'label': '房源', 'icon': Icons.account_balance, 'to': '/store_list', 'num': 10},
    {'label': '土地', 'icon': Icons.location_city, 'to': '/store', 'num': 5},
    {'label': '客源', 'icon': Icons.landscape, 'to': '/customer_list', 'num': 8},
    {'label': '订单', 'icon': Icons.hot_tub, 'to': '/store', 'num': 0},
  ];

  initState() {
    super.initState();
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
      appBar: SearchBarSection(),
      body: ListView(
        children: [
          Divider(
            height: 10.0,
            thickness: 10.0,
            color: Colours.bg_gray,
          ),
          navSection(),
          reportSection(),
          YsFuture(
            //异步加载组建封装
            url: '/api/index/indexData',
            bodyFunc: (result) => StoreListTabSection(data: result),
          ),
          RaisedButton(
            child: Text("登录"),
            onPressed: () => Routers.go(context, "/login"),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // 底部导航
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.corporate_fare_rounded), label: "房源"),
          BottomNavigationBarItem(icon: Icon(Icons.copy_sharp), label: "客源"),
          BottomNavigationBarItem(icon: YsStackIcon(Icon(Icons.sms_outlined), 10), label: "消息"),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined), label: "我的"),
        ],
        currentIndex: _selectedIndex,
        fixedColor: Colors.blue,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.grey[100],
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
                Text("4.3亿", style: TextStyle(color: Colors.red, fontSize: 16.0)),
                Text("库房总面积(㎡)"),
              ]),
            ),
            Container(
              width: 110,
              child: Column(children: [
                Text("300+", style: TextStyle(color: Colors.red, fontSize: 16.0)),
                Text("覆盖城市"),
              ]),
            ),
            Container(
              width: 110,
              child: Column(children: [
                Text("1.2万+", style: TextStyle(color: Colors.red, fontSize: 16.0)),
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
                  YsStackIcon(Icon(item['icon'], size: 40), 0, showNum: false),
                  // Icon(item['icon'], size: 40),
                  Text(item['label']),
                ],
              )),
        );
      }
      return rowNav;
    }

    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _nav.map((item) {
                return GestureDetector(
                    onTap: () => Routers.go(context, item['to']),
                    child: Column(
                      children: [
                        YsStackIcon(Icon(item['icon'], size: 40), item['num'], showNum: false),
                        Text(item['label']),
                      ],
                    ));
              }).toList(),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            color: Colors.grey[100],
            alignment: Alignment.centerLeft,
            child: Text("今日代办"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _backlogs.map((item) {
                return GestureDetector(
                    onTap: () => Routers.go(context, item['to']),
                    child: Column(
                      children: [
                        YsStackIcon(
                          Icon(item['icon'], size: 40),
                          item['num'],
                          radiusSize: 9,
                        ),
                        // Icon(item['icon'], size: 40),
                        Text(item['label']),
                      ],
                    ));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
