import 'package:agent/res/colors.dart';
import 'package:flutter/material.dart';

mixin InvoiceMixin {
  Widget getStatusText(int st, {double? fontSize}) {
    String s = ['--', '待审核', '--', '已审核', '审核失败', '已开票'][st];
    Color stColor = [
      Colours.info,
      Colours.text_primary,
      Colours.info,
      Colours.text_success,
      Colours.text_danger,
      Colours.text_success
    ][st];
    return Text(
      s,
      style: TextStyle(fontSize: fontSize ?? 16, color: stColor),
    );
  }
}
