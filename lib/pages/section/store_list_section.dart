import 'package:agent/net/result.dart';
import 'package:agent/res/colors.dart';
import 'package:agent/res/styles.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/utils/utils.dart';
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
  @override
  void initState() {
    // TODO: implement didUpdateWidget
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // 数据源转单行
    List<Widget> list = [];
    for (var v in widget.data.range()) {
      for (var r in v.range()) {
        var item = Store(
            r['overall_view_picurl'].toString(),
            r['title'].toString(),
            r['price'].toString() + r['unit'].toString(),
            r['library'].d?.split('|'),
            r['store_merit_text'].d?.split(','));

        list.add(
          InkWell(
            onTap: () => Routers.go(context, '/home'),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _leftImg(item),
                    Expanded(child: _rightColumn(item))
                  ],
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
    }

    // 构造数据end
    return Container(
      // height: 300,
      child: Column(
        children: [
          Column(
            // viewTab 渲染
            children: list.toList(),
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

    wrapChild = tags.map((tag) {
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
      child: Image.network(
        data.imgUrl,
        errorBuilder: (context, error, stackTrace) {
          trace('图片异常：'+ data.imgUrl);
          return Container();
        },
      ),
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

    var price =
        _pd(Text(data.price, style: TextStyle(color: Colors.red)), t: 5);

    List<Widget> _children = [];
    _children.add(title);
    if (data.pTags != null) {
      _children.add(_pd(_tagsBox(data.pTags), t: 5));
    }
    if (data.sTags != null) {
      _children.add(_pd(_tagsBox(data.sTags), t: 5));
    }
    _children.add(price);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, //水平左对齐 默认居中
      children: _children,
    );
  }
}
