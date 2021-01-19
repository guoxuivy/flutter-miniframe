import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:agent/widgets/buttons/ys_button.dart';

class YsButtonSms extends YsButton {
  final String captcha;
  final String phone;
  const YsButtonSms({
    Key key,
    this.captcha,
    this.phone,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return YsButtonSmsState();
  }
}

class YsButtonSmsState extends YsButtonState {
  String _title = '获取验证码';

  /// 倒计时的计时器。
  Timer _timer;
  TextStyle get textStyle {
    return TextStyle(color: Color(0xff198AFF));
  }

  String get title {
    // print(widget.captcha);
    return _title;
  }

  String get type {
    return widget.type ?? 'text';
  }

  VoidCallback get onPressed {
    return getCode;
  }

  void _downTimeSms(t) {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (t > 0) {
          _title = '${t.toString()}秒后重发';
        } else {
          _title = '获取验证码';
          _timer?.cancel();
        }
        setState(() {});
        t--;
      },
    );
  }

  void getCode() {
    print(widget);
    /* if (!widget.captcha) {
      Fluttertoast.showToast(
        msg: '验证码不能为空',
        gravity: ToastGravity.CENTER,
      );
      return;
    }
    if (!widget.phone) {
      Fluttertoast.showToast(
        msg: '手机号码不能为空',
        gravity: ToastGravity.CENTER,
      );
      return;
    } */
    // 防止多次点击
    if (_title.contains('秒')) {
      return;
    }
    _downTimeSms(60);
  }

  /* getCode() {
            if (!this.params?.captcha) {
                this.$emit('catch', '验证码不能为空')
                return
            }
            if (!this.params?.phone) {
                this.$emit('catch', '手机号码不能为空')
                return
            }
            if (this.start) {
                return
            }
            let downTimeSms = t => {
                if (t > 0) {
                    this.codeTitle = `${t}秒后重发`
                } else {
                    this.codeTitle = `获取验证码`
                    this.start     = 0
                    return
                }
                setTimeout(function () {
                    t--
                    downTimeSms(t)
                }, 1000)
            }
            let data = {
                phone: this.params.phone,
            }
            if (this.useCaptcha) {
                data.captcha = this.params.captcha
            }
            ajax({
                url: this.url,
                data,
            }).then(res => {
                this.start = 1
                downTimeSms(60)
                if (res.code != 1) {
                    this.$emit('catch', res.msg)
                }
            })
        } */
}
