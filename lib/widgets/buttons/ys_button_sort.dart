import 'package:agent/res/colors.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:flutter/material.dart';

class YsButtonSort extends StatefulWidget {
  final onPressed;
  final List<Map> items;
  final Widget? button;
  final bool text;

  YsButtonSort({
    Key? key,
    required this.onPressed,
    required this.items,
    this.button,
    this.text = false,
  }) : super(key: key);

  @override
  YsButtonSortState createState() {
    return YsButtonSortState();
  }
}

class YsButtonSortState extends State<YsButtonSort> {
  Map activeItem = {};
  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [];
    widget.items.forEach((item) {
      _children.add(InkWell(
        child: Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          child: Text(
            item['type_name'],
            style: TextStyle(
                color: activeItem['type_id'] == item['type_id'] ? Colours.primary : Colours.info),
          ),
        ),
        onTap: () {
          activeItem = item;
          if (widget.onPressed != null) {
            widget.onPressed(item['type_id']);
          }
          setState(() {});
          Navigator.pop(context);
        },
      ));
      _children.add(Divider(height: 1));
    });

    _show() {
      Dialogs.bottomPop(
        body: Column(
          children: _children,
        ),
      );
    }

    if (widget.text) {
      return YsButton(
        width: 44,
        height: 44,
        round: true,
        type: 'muted',
        text: true,
        icon: '&#xe603;',
        onPressed: _show,
      );
    }
    return Positioned(
      right: 10,
      bottom: 10,
      child: YsButton(
        width: 44,
        height: 44,
        round: true,
        type: 'muted',
        plain: true,
        icon: '&#xe603;',
        onPressed: _show,
      ),
    );
  }
}
