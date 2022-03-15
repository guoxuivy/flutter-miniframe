import 'package:agent/res/colors.dart';
import 'package:flutter/material.dart';

import 'buttons/ys_button_back.dart';

typedef ItemBuildFunc = Widget Function(BuildContext, int);

class SimplePage extends StatelessWidget {
  final String? title;
  final Widget? body;
  final List<Widget>? children;
  final EdgeInsetsGeometry? padding;
  final double? itemHeight;
  final ItemBuildFunc? itemBuilder;
  final Widget? itemDivider;
  final int? itemCount;
  final Widget? footer;
  final separatorBuilder;
  SimplePage({
    Key? key,
    this.title,
    this.padding,
    this.footer,
    this.body,
    this.children,
    this.itemHeight,
    this.itemBuilder,
    this.itemDivider,
    this.itemCount,
    this.separatorBuilder,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: YsButtonBack(),
          centerTitle: true,
          title: Text(
            title!,
            style: TextStyle(
              color: Colours.text_info,
              fontSize: 17.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [],
        ),
        //body: body,
        body: body != null
            ? body
            : (itemBuilder != null
                ? ListView.separated(
                    separatorBuilder: (BuildContext context, int index) =>
                        separatorBuilder != null ? separatorBuilder(index) : Container(),
                    itemBuilder: itemBuilder!,
                    itemCount: itemCount!,
                    padding: padding,
                  )
                : ListView(
                    controller: ScrollController(),
                    padding: padding,
                    itemExtent: itemHeight,
                    children: children!,
                  )),
        bottomNavigationBar: footer);
  }
}
