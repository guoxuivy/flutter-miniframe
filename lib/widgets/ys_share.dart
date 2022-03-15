import 'dart:typed_data';

import 'package:agent/utils/dialogs.dart';
import 'package:agent/utils/share.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class YsShare extends StatefulWidget {
  YsShare({
    Key? key,
    required this.url,
    required this.title,
    this.params,
    required this.renderContent,
  }) : super(key: key);

  final String url;
  final String title;
  final Map<String, dynamic>? params;
  final renderContent;

  @override
  YsShareState createState() => YsShareState();
}

/// 视图构建逻辑
class YsShareState extends State<YsShare> {
  Uint8List wxacode=Uint8List.fromList([]);

  @override
  void initState() {
    super.initState();
    _getWXacode();

    Clipboard.setData(ClipboardData(text: widget.title));
    Dialogs.showToast(
      msg: '标题已复制长按键粘贴',
      type: 'success',
    );
  }

  _getWXacode() async {
    wxacode = await ShareUtils.getWXacode(url: widget.url);
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant YsShare oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
  }

  button({icon, title, onTap}) {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xff01C77F),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            width: 40,
            height: 40,
            child: YsIcon(
              size: 24,
              color: Colors.white,
              src: icon,
            ),
          ),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          )
        ],
      ),
      onTap: onTap,
    );
  }

  // 分享截图key
  GlobalKey repaintWidgetKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.5),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 30),
                color: Colors.white,
                child: RepaintBoundary(
                  key: repaintWidgetKey,
                  child: wxacode == null
                      ? Container(
                          height: 400,
                          alignment: Alignment.center,
                          child: Text('正在生成...'),
                        )
                      : widget.renderContent(wxacode),
                ),
              ),
            ],
          ),
          Positioned(
            right: 20,
            top: 30,
            child: YsButton(
              color: Colors.black.withOpacity(.3),
              round: true,
              type: 'text',
              icon: '&#xe612;',
              iconSize: 8,
              width: 24,
              height: 24,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 90,
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            button(
              icon: '&#xe65d;',
              title: '分享给好友',
              onTap: () {
                ShareUtils.shareSession(
                  repaintWidgetKey: repaintWidgetKey,
                  url: widget.url,
                  title: widget.title,
                );
              },
            ),
            button(
              icon: '&#xe637;',
              title: '分享朋友圈',
              onTap: () {
                ShareUtils.shareTimeline(
                  repaintWidgetKey: repaintWidgetKey,
                  url: widget.url,
                  title: widget.title,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
