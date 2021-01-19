import 'package:agent/net/result.dart';
import 'package:agent/res/colors.dart';
import 'package:agent/res/styles.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/utils/utils.dart';
import 'package:flutter/material.dart';

class Customer {
  String name;
  String star;
  String seeNum; //带看次数
  String inspectNum; //带看套数
  String lastFollowTime;//上次维护时间
  String status;//客户状态
  String originType;//客户来源
  List<String> info; // 详细信息
  Customer(this.name, this.star, this.seeNum, this.inspectNum, this.lastFollowTime, this.status, this.originType, this.info);
}

class CustomerListSection extends StatefulWidget {
  CustomerListSection({Key key, this.data}) : super(key: key);
  final RData data;

  @override
  CustomerListSectionView createState() => CustomerListSectionView();
}

/// 视图构建逻辑
class CustomerListSectionView extends State<CustomerListSection> {
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
        List<String> info = [];
        for (var s in r['demands_info'].range()){
            info.add(s['high_light_title'].toString() + ":" + s['simple_title'].toString());
        }
        var item = Customer(
            r['name'].toString(),
            r['focus_level'].toString(),
            r['see_num'].toString(),
            r['see_num'].toString(),
            r['last_follow_time'].toString(),
            r['status'].toString(),
            r['origin_type'].toString(),
            info

          );
            // r['title'].toString(),
            // r['price'].toString() + r['unit'].toString(),
            // r['library'].d.split('|'),
            // r['store_merit_text'].isNull ? [] : r['store_merit_text'].d.split(','));

        list.add(
          InkWell(
            onTap: () => Routers.go(context, '/home'),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Expanded(child: _dataColumn(item))],
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
    return Padding(padding: EdgeInsets.fromLTRB(l ?? 0, t ?? 0, r ?? 0, b ?? 0), child: w);
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



  static Widget _dataColumn(Customer data) {
    var title = Text(
      data.name,
      style: TextStyles.textSize16,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );

    List<Widget> childrenList = [
      Row(children: [title]),
      Row(
          children: data.info.where((e) => e.isNotEmpty).map((tag) {
            return Container(
              child: Text(tag, style: TextStyle(color: Colors.lightBlueAccent)),
              padding: EdgeInsets.all(2),
            );
          }).toList())];

    var statusLabel = data.status == "1" ? "有效客户" : "";
    if(statusLabel.isNotEmpty){
      childrenList.add(Row(children: [Text(statusLabel)],));
    }

    var originTypeLabel = data.status == "3" ? "合作客户" : "";
    if(originTypeLabel.isNotEmpty){
      childrenList.add(Row(children: [Text(originTypeLabel)],));
    }

    childrenList.add(
        Row(
          children: [
            Text("30天内带看:" + data.inspectNum + "套 / " + data.seeNum + "次")
          ],
        )
    );

      var followTime = int.parse("1610965074");
      var followTimeFormat = new DateTime.fromMillisecondsSinceEpoch(followTime * 1000);
      childrenList.add(
          Row(
            children: [
              Text("上次维护时间:" + followTimeFormat.toString())
            ],
          )
      );



    // var tag = _tagsBox(data.pTags);
    // var stag = _tagsBox(data.pTags);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start, //水平左对齐 默认居中
      children: childrenList,
    );
  }
}
