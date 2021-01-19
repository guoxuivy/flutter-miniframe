import 'dart:math';
import 'package:agent/res/colors.dart';
import 'package:flutter/material.dart';

class AppBarSection extends StatefulWidget implements PreferredSizeWidget {
  AppBarSection({Key key}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  _AppBarView createState() => _AppBarView();
}

/// 视图构建逻辑
class _AppBarView extends State<AppBarSection> {
  String _searchStr;

  AppBar build(BuildContext context) {
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
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: _searchStr ?? '点击搜索仓库、厂房、土地',
                            hintStyle: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF999999),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF333333),
                            height: 1.3,
                          ),
                          textInputAction: TextInputAction.search,
                          // onTap: widget.onTap,
                          // onChanged: _onInputChanged,
                          // onSubmitted: widget.onSearch,
                        ),
                      ),
                      // Expanded(
                      //   child: Container(
                      //     child: Text(
                      //       _searchStr ?? '点击搜索仓库、厂房、土地',
                      //       style: TextStyle(color: Colors.grey, fontSize: 16),
                      //     ),
                      //   ),
                      // ),
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
