import 'package:agent/provider/upgrade.dart';
import 'package:agent/res/colors.dart';
import 'package:agent/res/resources.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

/// 系统对话框集中管理
class Dialogs {
  // 版本更新对话框
  static Future versionDialog({String versionLog = "有新版本发布，是否更新？", doUpdateFunc}) {
    BuildContext context = Routers.context();
    //设置按钮
    Widget cancelButton = TextButton(
      child: Text("下次再说"),
      onPressed: () {
        return Navigator.pop(context, false);
      },
    );
    Widget continueButton = TextButton(
      child: Text("立即更新"),
      onPressed: () {
        doUpdateFunc(context).then((result) {
          // trace('更新更新更新');
        });
        // Navigator.pop(context, true); //不要返回
      },
    );

    //设置对话框
    AlertDialog alert = AlertDialog(
      title: Text("升级更新"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(versionLog),
          Consumer(
            builder: (context, watch, _) {
              String up = watch(upgradeProvider).value;
              return Text(
                '$up',
              );
            },
          ),
        ],
      ),
      actions: [
        Consumer(
          builder: (context, watch, _) {
            String up = watch(upgradeProvider).value;
            return up == "" ? cancelButton : Container();
          },
        ),
        Consumer(
          builder: (context, watch, _) {
            String up = watch(upgradeProvider).value;
            return up == "" ? continueButton : Container();
          },
        ),

        // cancelButton,
        // continueButton,
      ],
    );

    //显示对话框
    return showDialog(
      barrierDismissible: false,
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
    ).then((val) {
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

  // confirm
  static Future confirm({
    String title = '提示！',
    content,
    confirmButtonText = '确定',
    cancelButtonText = '取消',
  }) {
    BuildContext context = Routers.context();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.only(top: 10, bottom: 15, left: 15, right: 15),
          title: Text(title),
          titleTextStyle: TextStyle(fontSize: 18, color: Colours.info),
          content: Row(
            children: [
              YsIcon(
                src: '&#xe636;',
                size: 20,
                color: Colours.warning,
              ),
              SizedBox(width: 5),
              Text(content),
            ],
          ),
          contentPadding: EdgeInsets.only(left: 24, top: 0, bottom: 15, right: 24),
          actions: [
            YsButton(
              width: 50,
              // text: true,
              title: cancelButtonText,
              size: 'mini',
              height: 26,
              plain: true,
              onPressed: () {
                Navigator.pop(context, 'Cancel');
              },
            ),
            YsButton(
              width: 50,
              // text: true,
              title: confirmButtonText,
              size: 'mini',
              height: 26,
              onPressed: () {
                Navigator.pop(context, 'OK');
              },
            ),
          ],
        );
      },
    );
  }

  static _getTitle({title, setDialogsState, onClose}) {
    List<Widget> _title = [];
    if (title != null) {
      if (title is String) {
        _title.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 占位，让title居中
            SizedBox(width: 50),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff3333333),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            CloseButton(
              color: Colours.muted,
              onPressed: onClose,
            )
          ],
        ));
      } else if (title is Widget) {
        _title.add(title);
      } else if (setDialogsState != null) {
        _title.add(title(setDialogsState));
      } else {
        _title.add(title());
      }
      _title.add(Divider(height: 1));
    }
    return _title;
  }

  // 通用dialog
  static Future dialog({Widget? body, title, onClose}) {
    BuildContext context = Routers.context();
    List<Widget> _title = [];
    _title = _getTitle(
      title: title,
      onClose: onClose,
    );
    //设置对话框
    AlertDialog alert = AlertDialog(
      contentPadding: EdgeInsets.all(0),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ..._title,
            Container(
              padding: EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
              child: body,
            ),
          ],
        ),
      ),
    );

    //显示对话框
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// 底部自适应弹出层，下滑关闭，高度自适应
  static Future bottomPop({
    // widget, fun
    var title,
    // widget, fun
    var body,
    double? bodyHeight,
    EdgeInsets? bodyPadding,
    // 是否全屏
    bool fullscreen = false,
    // 可关闭
    bool isDismissible = true,
    // 是否需求更新弹窗内的状态
    bool updateState = false,
    var onClose,
    // widget, fun
    var footer,
  }) {
    BuildContext context = Routers.context();
    var _builder = (BuildContext context, [setDialogsState]) {
      var _controller = ScrollController();
      // 内容下拉时自动关闭弹窗
      // _controller.addListener(() {
      //   if (_controller.offset == 0) {
      //     Navigator.pop(context);
      //   }
      // });
      // WidgetsBinding.instance.addPostFrameCallback((mag) {
      //   // 全屏时需要初始化滚动
      //   if (_controller.position.maxScrollExtent > 0) {
      //     _controller.jumpTo(0.1);
      //   }
      // });
      // title可能不存在
      List<Widget> _title = [];
      _title = _getTitle(
        title: title,
        setDialogsState: setDialogsState,
        onClose: onClose,
      );
      return SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          //标题浮动
          children: [
            ..._title,
            Container(
              height: bodyHeight ??
                  (fullscreen ? (MediaQuery.of(context).size.height - 50 - 26) : null),
              padding: bodyPadding ?? EdgeInsets.all(0),
              constraints: BoxConstraints(
                minHeight: 90, //设置最小高度（必要）
                maxHeight: MediaQuery.of(context).size.height * (fullscreen ? 1 : 0.8), //设置最大高度（必要）
              ), //圆角
              child: ListView(
                controller: _controller,
                shrinkWrap: true, //防止状态溢出 自适应大小
                children: <Widget>[
                  body is Widget ? body : body(setDialogsState),
                ],
              ),
            ),
            footer != null ? (footer is Widget ? footer : footer()) : Container(),
          ],
        ),
      );
    };
    return showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      isScrollControlled: true, //可滚动 解除showModalBottomSheet最大显示屏幕一半的限制
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(5.0)),
      ),
      builder: updateState ? (context) => StatefulBuilder(builder: _builder) : _builder,
    );
  }

  static easyLoadingDismiss() {
    EasyLoading.dismiss();
  }

  static showLoading({String msg = '', String type = 'info'}) {
    Map backgroundColorMap = {
      'primary': Colours.primary,
      'danger': Colours.danger,
      'success': Colours.success,
      'info': Colours.info,
      'warning': Colours.warning,
      'muted': Color(0xffeeeeee),
    };
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..radius = 10.0
      ..contentPadding = EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10)
      ..indicatorColor = Colors.white
      ..textColor = Colors.white
      ..fontSize = 14
      ..maskType = EasyLoadingMaskType.clear
      ..displayDuration = Duration(milliseconds: 1000000)
      ..backgroundColor = backgroundColorMap[type].withOpacity(.8);
    EasyLoading.show(status: 'loading...');
  }

  // 自定义toast
  static showToast({String msg = '', String type = 'info'}) {
    Map backgroundColorMap = {
      'primary': Colours.primary,
      'danger': Colours.danger,
      'success': Colours.success,
      'info': Colours.info,
      'warning': Colours.warning,
      'muted': Color(0xffeeeeee),
    };
    EasyLoading.instance
      ..radius = 30.0
      ..loadingStyle = EasyLoadingStyle.custom
      ..contentPadding = EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10)
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.white
      ..fontSize = 14
      ..maskType = EasyLoadingMaskType.clear
      ..displayDuration = Duration(milliseconds: 1000)
      ..backgroundColor = backgroundColorMap[type].withOpacity(.8);
    EasyLoading.showToast(
      msg,
      toastPosition: EasyLoadingToastPosition.center,
    );
  }
}
