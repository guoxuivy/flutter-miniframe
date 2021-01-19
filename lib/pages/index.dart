import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/net/http_manager.dart';

/// 可以合并到homepage页面
class IndexPage extends StatefulWidget {
  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State {
  bool loaded = false;
  Map data = {};
  void initData() {
    if (!this.loaded) {
      this.loadData();
    }
  }

  void loadData() {
    HttpManager().get('/wapi/home/index').then((value) {
      if (value.isOk) {
        trace(value['data']);
        setState(() {
          this.loaded = true;
          [
            'stores',
            'demand',
            'banner',
            'webinfo',
            'newscate',
            'getnewslist',
            'wap_domain',
            'wap_news_url'
          ].forEach((key) {
            this.data[key] = value[key];
          });
        });
      } else {
        trace(value.msg);
      }
    });
  }

  IndexPageState() {
    this.initData();
  }
  TextStyle textStyle = TextStyle(fontSize: 18);
  Widget addBlock(Widget head, Widget body, {double height = 500}) {
    return Container(height: height, child: Column(children: [head, Expanded(child: body)]));
  }

  Text addText(String str) {
    return Text(str, overflow: TextOverflow.fade, style: textStyle);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('首页')),
        persistentFooterButtons: [],
        body: Center(
            //child:Expanded(
            child: Column(
          children: !this.loaded ? [Text('Loading...')] : this.renderPage(),
        )
            //  )
            ));
  }

  List<Widget> renderPage() {
    List<Widget> arr = [];
    //新闻列表 getnewslist
    if (this.data['getnewslist'] != null) {
      List<Widget> news = [];
      arr.add(Text('新闻列表'));
      for (var el in this.data['getnewslist']['list'].range()) {
        //trace( 'newslist item: ' + el.toString());
        news.add(ListTile(
            title: addText('[' + el['type_name'].toString() + ']'),
            subtitle: addText(el['title'].toString())));
      }
      arr.add(addBlock(
          Text('Loading...'),
          ListView(
            children: news,
          ),
          height: 200));
    }

    //库房列表 stores
    if (this.data['stores'] != null) {
      List<Widget> stores = [];
      //arr.add(Text('库房列表'));
      for (var el in this.data['stores'].range()) {
        if (el['id'] == null) {
          continue;
        }
        try {
          stores.add(ListTile(
              leading: Image.network(el['img'], width: 40, height: 40),
              title: addText(el['title'])));
        } catch (e) {
          trace(e.message);
        }
      }
      arr.add(addBlock(Text('库房列表'), ListView(children: stores)));
    }

    return arr;
  }
}
