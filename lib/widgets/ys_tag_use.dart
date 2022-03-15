import 'package:flutter/material.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/widgets/ys_tag.dart';
import 'package:agent/utils/field_title.dart';

class YsTagUse extends StatelessWidget {
  YsTagUse({
    Key? key,
    required this.value,
    this.type = 'primary', // 类型
    this.size = 'mini', // 尺寸
    this.closable = false, // 是否可关闭
    this.round = false, // 是否椭圆
    this.effect = 'light', // 主题, 三种 light dark plain
  }) : super(key: key);

  final String type;
  final String size;
  final String effect;
  final bool closable;
  final bool round;
  final int value;

  @override
  Widget build(BuildContext context) {
    if (value < 1) {
      return Container();
    }
    String title = fieldTitle(value: value, prop: 'tag_use');
    return Ink(
      child: InkWell(
        onTap: () {
          String str =
              ['已签订委托合同', '内部有政策可给费用但不可签委托合同', '口头承诺可给费用', '不合作'][value];
          Dialogs.tips(str);
        },
        child: YsTag(
          title: title,
          type: type,
          size: size,
          closable: closable,
          round: round,
          effect: effect,
        ),
      ),
    );
  }
}
