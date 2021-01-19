import 'package:agent/routers/routers.dart';
import 'package:agent/utils/utils.dart';
import 'package:flutter/material.dart';

/// 系统对话框集中管理
class Dialogs{
    // 版本更新对话框
    static Future versionDialog({String versionLog}) {
        BuildContext context = Routers.context();
        //设置按钮
        Widget cancelButton = FlatButton(
            child: Text("下次再说"),
            onPressed: () {
                return Navigator.pop(context, false);
            },
        );
        Widget continueButton = FlatButton(
            child: Text("立即更新"),
            onPressed: () => Navigator.pop(context, true),
        );

        //设置对话框
        AlertDialog alert = AlertDialog(
            title: Text("升级更新"),
            content: Text(versionLog ?? "有新版本发布，是否更新？"),
            actions: [
                cancelButton,
                continueButton,
            ],
        );

        //显示对话框
        return showDialog(
            context: context,
            builder: (BuildContext context) {
                return alert;
            },
        );
    }

    // 未登录401
    static Future unauthorized(String str) {
        BuildContext context = Routers.context();
        //设置对话框
        AlertDialog alert = AlertDialog(
            content: Text(str),
        );
        //显示对话框
        return showDialog(
            context: context,
            builder: (BuildContext context) {
                return alert;
            },
        ).then((val){
            Routers.go(context, '/login');
        });
    }

    // 通用tips
    static Future tips(String str) {
        BuildContext context = Routers.context();
        //设置对话框
        AlertDialog alert = AlertDialog(
            content: Text(str),
        );

        //显示对话框
        return showDialog(
            context: context,
            builder: (BuildContext context) {
                return alert;
            },
        );
    }


}
