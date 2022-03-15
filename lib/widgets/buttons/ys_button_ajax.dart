import 'package:agent/net/http_manager.dart';
import 'package:agent/net/result.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:flutter/material.dart';

class YsButtonAjax extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool plain;
  final bool isConfirm;
  final double height;
  final String? type;
  final String? size;
  final String title;
  final String url;
  final renderButton;
  final submitted;
  final Map<String, dynamic>? params;

  const YsButtonAjax({
    Key? key,
    this.onPressed,
    this.plain = false,
    this.isConfirm = true,
    this.height = 0,
    this.type,
    this.size,
    this.title = '',
    this.url = '',
    this.renderButton,
    this.submitted,
    this.params,
  }) : super(key: key);

  _submit() async {
    String val = 'OK';
    if (isConfirm) {
      val = await Dialogs.confirm(
        content: '确定执行此操作吗？',
      );
    }
    if (val == 'OK') {
      final ajax = HttpManager.instance;
      Result result = await ajax.get(url, data: params, loading: false);
      if (result.isOk && submitted != null) {
        submitted(result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (renderButton != null) {
      return renderButton(_submit);
    }
    return YsButton(
      padding: EdgeInsets.only(left: 15, right: 15),
      type: type ?? 'primary',
      size: size ?? 'small',
      title: title,
      plain: plain,
      height: height,
      onPressed: _submit,
    );
  }
}
