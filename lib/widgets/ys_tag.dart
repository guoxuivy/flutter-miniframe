import 'package:flutter/material.dart';

class YsTag extends StatelessWidget {
  YsTag({
    Key? key,
    this.title = '标签', // 文本内容
    this.type = 'primary', // 类型
    this.size = 'mini', // 尺寸
    this.closable = false, // 是否可关闭
    this.round = false, // 是否椭圆
    this.effect = 'light', // 主题, 三种 light dark plain
  }) : super(key: key);

  final String type;
  final String title;
  final String size;
  final String effect;
  final bool closable;
  final bool round;

  final _colorMap = {
    'primary': {
      'light': {
        'backgroundColor': Color(0xffEBF2FE),
        'color': Color(0xff3E82FE),
      },
      'dark': {
        'backgroundColor': Color(0xff3E82FE),
        'color': Colors.white,
      },
      'plain': {
        'backgroundColor': Colors.white,
        'color': Color(0xff3E82FE),
      },
    },
    'success': {
      'light': {
        'backgroundColor': Color(0xffE8F9F2),
        'color': Color(0xff3BD393),
      },
      'dark': {
        'backgroundColor': Color(0xff3BD393),
        'color': Colors.white,
      },
      'plain': {
        'backgroundColor': Colors.white,
        'color': Color(0xff3BD393),
      },
    },
    'info': {
      'light': {
        'backgroundColor': Color(0xffEDF3FD),
        'color': Color(0xff7A92BF),
      },
      'dark': {
        'backgroundColor': Color(0xff7A92BF),
        'color': Colors.white,
      },
      'plain': {
        'backgroundColor': Colors.white,
        'color': Color(0xff7A92BF),
      },
    },
    'warning': {
      'light': {
        'backgroundColor': Color(0xffFFF1D9),
        'color': Color(0xffFC9834),
      },
      'dark': {
        'backgroundColor': Color(0xffFC9834),
        'color': Colors.white,
      },
      'plain': {
        'backgroundColor': Colors.white,
        'color': Color(0xffFC9834),
      },
    },
    'danger': {
      'light': {
        'backgroundColor': Color(0xffFEF0F0),
        'color': Color(0xffF56C6C),
      },
      'dark': {
        'backgroundColor': Color(0xffF56C6C),
        'color': Colors.white,
      },
      'plain': {
        'backgroundColor': Colors.white,
        'color': Color(0xffF56C6C),
      },
    },
    'muted': {
      'light': {
        'backgroundColor': Color(0xffF2F2F2),
        'color': Color(0xff333333),
      },
      'plain': {
        'backgroundColor': Color(0xffe5e5e5),
        'color': Color(0xff999999),
      },
    }
  };
  final sizeMap = {'small': 14.0, 'mini': 12.0, 'medium': 16.0, 'large': 30.0};
  final paddingMap = {
    'small': EdgeInsets.fromLTRB(5, 2, 5, 2),
    'mini': EdgeInsets.fromLTRB(3, 0, 3, 0),
    'medium': EdgeInsets.fromLTRB(6, 3, 6, 3),
    'large': EdgeInsets.fromLTRB(8, 4, 8, 4),
  };
  final sizeHeight = {'small': 1.3, 'mini': 1.3, 'medium': 1.3, 'large': 1.4};

  @override
  Widget build(BuildContext context) {
    var tagColor = _colorMap[type]![effect];
    return title.isEmpty
        ? Container(height: 0.0, width: 0.0)
        : Container(
            padding: paddingMap[size],
            decoration: BoxDecoration(
              color: tagColor!['backgroundColor'],
              borderRadius: BorderRadius.all(Radius.circular(round ? 10 : 2)),
              border: Border.all(
                // dark时与背景颜色一致
                color: effect == 'dark' ? tagColor['backgroundColor']! : tagColor['color']!,
                width: 0.5,
              ),
            ),
            child: Text(
              '$title',
              style: TextStyle(
                color: tagColor['color'],
                fontSize: sizeMap[size],
                height: sizeHeight[size],
              ),
            ),
          );
  }
}
