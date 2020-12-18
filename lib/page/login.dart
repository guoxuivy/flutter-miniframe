import 'package:cxe/model/user.dart';
import 'package:cxe/res/resources.dart';
import 'package:flutter/material.dart';
import 'package:cxe/routers/routers.dart';
import 'package:flutter_riverpod/all.dart';
import '../net/http_manager.dart';
import 'package:cxe/util/utils.dart';

class LoginPage extends StatelessWidget {
  final User data = User();
  void submit (BuildContext context) {
    HttpManager().post(
        '/memberapi/login/login',
        data: {'username': this.data.username, 'password': this.data.password}
    ).then((value) {
      if (value.isOk) {
        trace(value.data['data']);
        var id = int.parse(value["id"].toString());
        var username = value["name"].data;
        context.read(userProvider).setUser(User(id:id, username:username));
        Routers.go(context, '/user/home');
      } else {
        trace(value.msg);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title:Text('出错了'),
                content: Text(value.msg.toString())
            );
          }
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      ///定义页面的标题
      appBar: AppBar(
        title: Text("用户登录", style: Theme.of(context).textTheme.subtitle2),
      ),
      body:Container(
        padding: const EdgeInsets.only(left: 8, right:8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                  '用户登录',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold
                  )
              ),
              TextField(
                  key: Key('username'),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      hintText: '填写手机号码',
                      hintStyle: TextStyle(color: Colours.text_gray)
                  ),
                  onChanged: (v) => this.data.username = v
              ),
              TextField(
                  key: Key('password'),
                  enableSuggestions: false,
                  decoration: InputDecoration(
                      hintText: '填写密码',
                      hintStyle: TextStyle(color: Colours.text_gray)
                  ),
                  keyboardType: TextInputType.visiblePassword,
                  onChanged : (v) => this.data.password = v
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  children: [
                    RaisedButton(
                        child: Text("登录"),
                        onPressed: () => submit(context)
                    ),
                    RaisedButton(
                      child: Text("取消"),
                      //打开一个页面 接受pop返回参数 result
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              )

            ],
          ),
        ),
      )
    );
  }
}