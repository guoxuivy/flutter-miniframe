import 'package:agent/res/colors.dart';
import 'package:agent/utils/utils.dart';
import 'package:flutter/material.dart';

class YsSteps extends StatelessWidget {
  YsSteps({
    Key? key,
    this.active=0,
    required this.data,
  }) : super(key: key);

  final int active;
  final List data;

  // int _active;

  _getItem(item, i) {
    bool isActive = item['type_id'] == active;
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isActive ? Colours.primary : Color(0xffcccccc),
          ),
          child: Text(
            '${item['type_id']}',
            style: TextStyle(color: Colors.white),
          ),
        ),
        SizedBox(width: 5),
        Text(
          item['type_name'],
          style: TextStyle(color: isActive ? Colours.primary : Colours.muted),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // _active = active ?? data[0]['type_name'];
    List<Widget> _items = [];
    Utils.forEach(data, (item, i) {
      if (i > 0) {
        _items.add(Container(
          // height: 20,
          padding: EdgeInsets.only(left: 5, right: 5),
          width: 40,
          child: Divider(
            height: 1,
            color: Colours.info,
          ),
        ));
      }
      _items.add(_getItem(item, i));
    });
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _items,
      ),
    );
  }
}
