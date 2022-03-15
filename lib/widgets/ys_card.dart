import 'package:agent/widgets/ys_title.dart';
import 'package:flutter/material.dart';

class YsCard extends StatelessWidget {
  const YsCard({
    Key? key,
    this.title,
    this.body,
    this.bodyPadding,
    this.titlePadding,
    this.padding,
    this.size = 'medium',
    this.actions,
  }) : super(key: key);

  final title;
  final Widget? body;
  final EdgeInsets? bodyPadding;
  final EdgeInsets? titlePadding;
  final EdgeInsets? padding;
  final String size;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    Widget _body = Text('内容');
    List<Widget> _children = [];
    if (title != null) {
      _children.add(
        title is Widget
            ? title
            : YsTitle(
                title: title,
                padding: titlePadding ?? EdgeInsets.only(left: 20, top: 10, right: 20, bottom: 5),
                actions: actions,
              ),
      );
    }
    if (body != null) {
      _body = body!;
      _children.add(Container(
        // margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
        padding: bodyPadding ?? EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 10),
        child: _body,
      ));
    }
    return Container(
      color: Color(0xfffffffff),
      padding: padding ?? EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _children,
      ),
    );
  }
}
