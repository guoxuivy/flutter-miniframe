import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:flutter/material.dart';
import 'dart:async';

// 没做完
class YsButtonSms extends StatefulWidget {
  final String captcha;
  final String phone;
  const YsButtonSms({
    Key? key,
    this.captcha='',
    this.phone='',
  }) : super(key: key);

  @override
  YsButtonSmsState createState() {
    return YsButtonSmsState();
  }
}

class YsButtonSmsState extends State<YsButtonSms> {
  String _title = '获取验证码';

  /// 倒计时的计时器。
  late Timer _timer;

  @override
  void initState() {
    super.initState();
  }
  /* @override
  VoidCallback get onPressed {
    return getCode;
  } */

  void _downTimeSms(t) {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        if (t > 0) {
          _title = '${t.toString()}秒后重发';
        } else {
          _title = '获取验证码';
          _timer.cancel();
        }
        setState(() {});
        t--;
      },
    );
  }

  void getCode() {
    /* if (!widget.captcha) {
      Dialogs.showToast(
        msg: '验证码不能为空',
      );
      return;
    }
    if (!widget.phone) {
      Dialogs.showToast(
        msg: '手机号码不能为空',
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
  @override
  Widget build(BuildContext context) {
    return YsButton(
      color: Colors.transparent,
      text: true,
      title: _title,
      size: 'small',
      type: 'primary',
      onPressed: getCode,
    );
  }

  @override
  void dispose() {
    // 释放
    _timer.cancel();
    super.dispose();
  }
}
