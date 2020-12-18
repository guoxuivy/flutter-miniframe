import 'package:cxe/net/result.dart';
import 'package:cxe/res/colors.dart';
import 'package:cxe/res/styles.dart';
import 'package:cxe/routers/routers.dart';
import 'package:cxe/util/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Store {
  String imgUrl;
  String title;
  String price;
  List<String> pTags; // 物理属性tag
  List<String> sTags; // 售卖tag
  Store(this.imgUrl, this.title, this.price, this.pTags, this.sTags);
}

class StoreListSection extends StatefulWidget {
  StoreListSection({Key key, this.data}) : super(key: key);
  final RData data;

  @override
  StoreListSectionView createState() => StoreListSectionView();
}

/// 视图构建逻辑
class StoreListSectionView extends State<StoreListSection> {
  // 当前选中的tab
  int _tabIndex = 0;

  // tab切换事件
  void _onTab(int index) {
    setState(() {
      _tabIndex = index;
    });
  }

  // 控制tabView是否显示
  bool _tabShow(int i) {
    return i == _tabIndex;
  }



  @override
  void initState() {
    // TODO: implement didUpdateWidget
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    
    var viewTab = [];
    for (var v in widget.data.range()) { // store,factory,land
      List<Widget> tabView = []; //3个tab
      for (var r in v.range()) {
        var item = Store(
            r['overall_view_picurl'].toString(),
            r['title'].toString(),
            r['price'].toString() + r['unit'].toString(),
            r['library'].d.split('|'),
            r['store_merit_text'].isNull?[]: r['store_merit_text'].d.split(','));

        tabView.add(
          InkWell(
            onTap: () => Routers.go(context, '/home'),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_leftImg(item), Expanded(child: _rightColumn(item))],
                ),
                Divider(
                  height: 20,
                  thickness: 2,
                )
              ],
            ),
          ),
        );
      }
      viewTab.add(tabView);
    }



    // 构造数据end
    return Container(
      // height: 300,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 3),
            margin: EdgeInsets.only(left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '热门推荐',
                  style: TextStyles.textBold18,
                ),
                Row(
                  children: ['仓库', '厂房', '土地'].asMap().entries.map((e) {
                    int i = e.key;
                    String v = e.value;
                    return Container(
                      padding: EdgeInsets.fromLTRB(8,5,8,3),
                      decoration: _tabShow(i)?BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2,color: Colors.lightBlue)
                        ),
                      ):null,
                      child: InkWell(
                        child: Text(v),
                        onTap: () => _onTab(i),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
          ),
          Column( // viewTab 渲染
            children: ['仓库', '厂房', '土地'].asMap().entries.map((e) {
              int i = e.key;
              String v = e.value;
              return Visibility(
                visible: _tabShow(i),
                child: Column(
                  children: viewTab[i],
                ),
              );
            }).toList(),
          ),
          InkWell(
            onTap: () => Routers.go(context, '/home'),
            child: _pd(Text('更多>'), t: 0, b: 10),
          ),
          Divider(
            height: 10.0,
            thickness: 10.0,
            color: Colours.bg_gray,
          ),
        ],
      ),
    );
  }

  static Widget _pd(Widget w, {double l, double t, double r, double b}) {
    return Padding(
        padding: EdgeInsets.fromLTRB(l ?? 0, t ?? 0, r ?? 0, b ?? 0), child: w);
  }

  /// 自适应tags 行
  static Widget _tagsBox(List<String> tags) {
    List<Widget> wrapChild = List();
    var _box = BoxDecoration(
        color: Color.fromARGB(255, 230, 230, 230),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.all(Radius.circular(3.0)));

    wrapChild = tags.where((e) => e.isNotEmpty).map((tag) {
      return Container(
        child: Text(tag, style: TextStyle(color: Colors.lightBlueAccent)),
        decoration: _box,
        padding: EdgeInsets.all(2),
      );
    }).toList();
    return Wrap(
      spacing: 3.0, // 横向间距
      runSpacing: 3.0, //纵向间距
      children: wrapChild,
    );
  }

  static Widget _leftImg(Store data) {
    var img = Container(
      width: 130.0,
      height: 90.0,
      padding: EdgeInsets.all(5),
      // child: Image.asset(data.imgUrl),
      child: Image.network(data.imgUrl),
    );
    return img;
  }

  static Widget _rightColumn(Store data) {
    var title = Text(
      data.title,
      style: TextStyles.textSize16,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );


    var tag = _tagsBox(data.pTags);
    var stag = _tagsBox(data.sTags);
    var price = Text(data.price, style: TextStyle(color: Colors.red));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, //水平左对齐 默认居中
      children: [title, _pd(tag, t: 5), _pd(stag, t: 5), _pd(price, t: 5)],
    );
  }
}
