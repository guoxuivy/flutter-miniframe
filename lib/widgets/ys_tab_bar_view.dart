import 'package:agent/res/colors.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:agent/widgets/ys_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 页面填充对象
class YsTabBarBean {
  final Widget page;
  final Widget? leading;
  final List<Widget>? actions;
  final String? title;

  YsTabBarBean({
    this.title,
    required this.page,
    this.leading,
    this.actions,
  });
}

/// 可联动内部tab页
class YsTabBarView extends StatefulWidget {
  final List<YsTabBarBean> pages;
  final StateProvider<int> indexProvider;
  final Widget? leading;
  final Widget? actions;

  YsTabBarView({
    Key? key,
    required this.pages,
    required this.indexProvider,
    this.leading,
    this.actions,
  }) : super(key: key);

  @override
  _YsTabBarViewState createState() => _YsTabBarViewState();
}

class _YsTabBarViewState extends State<YsTabBarView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: widget.pages.length, vsync: this);
    _tabController.addListener(() {
      context.read(widget.indexProvider).state = _tabController.index;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    trace('YsTabBarView didChangeDependencies');
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    trace('YsTabBarView build');
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: Consumer(builder: (context, watch, _) {
              int currentIndex = watch(widget.indexProvider).state;
              if (_tabController.index != currentIndex) {
                Future.delayed(Duration(milliseconds: 100)).then((e) {
                  _tabController.animateTo(currentIndex);
                });
              }

              return AppBar(
                backgroundColor: Colours.header_bg,
                brightness: Brightness.dark,
                leading: widget.pages[currentIndex].leading,
                actions: widget.pages[currentIndex].actions ??
                    [
                      YsButton(
                        icon: '&#xe601;',
                        iconColor: Colors.white,
                        width: 50,
                        text: true,
                        iconSize: 20,
                        onPressed: () {
                          Dialogs.dialog(
                            title: '选择发布类型',
                            body: Column(
                              children: [
                                {
                                  "title": "发布园区",
                                  "icon": 'assets/images/fb_icon_yq@2x.png',
                                  "url": '/park_add'
                                },
                                /* {
                                  "title": "发布小面积库",
                                  "icon": 'assets/images/fb_icon_zskf@2x.png',
                                  "url": '/small_add_contact'
                                }, */
                                {
                                  "title": "发布土地",
                                  "icon": 'assets/images/fb_icon_yqntd@2x.png',
                                  "url": '/land_add_contact'
                                },
                              ]
                                  .map(
                                    (item) => Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom:
                                                  BorderSide(color: Colors.grey[200]!, width: .5))),
                                      padding: EdgeInsets.only(top: 10, bottom: 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                          Routers.go(context, item['url']!);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            YsImg(
                                              src: item['icon']!,
                                              width: 30,
                                              height: 30,
                                            ),
                                            SizedBox(width: 10),
                                            Text(item['title']!),
                                            Spacer(),
                                            YsIcon(
                                              src: '&#xe627;',
                                              size: 12,
                                              color: Colours.muted,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        },
                      ),
                    ],
                //标题是否居中显示，默认值根据不同的操作系统，显示方式不一样,true居中 false居左
                centerTitle: true,
                //Toolbar 中主要内容，通常显示为当前界面的标题文字
                title: TabBar(
                  // tabs 的长度超出屏幕宽度后，TabBar，是否可滚动
                  // 设置为false tab 将平分宽度，为true tab 将会自适应宽度
                  isScrollable: true,
                  controller: _tabController,
                  // 每个label的padding值
                  labelPadding: EdgeInsets.all(10.0),

                  ///指示器大小计算方式，TabBarIndicatorSize.label跟文字等宽,TabBarIndicatorSize.tab跟每个tab等宽
                  indicatorSize: TabBarIndicatorSize.label,
                  //设置所有的tab
                  tabs: widget.pages.map((t) => Tab(text: t.title)).toList(),
                ),
              );
            })),
        body: TabBarView(
          // physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: widget.pages.map((page) => page.page).toList(),
        ));
  }
}
