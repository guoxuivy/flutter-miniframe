import 'package:agent/utils/utils.dart';
import 'package:flutter/material.dart';

class YsTableList extends StatelessWidget {
  YsTableList({
    Key? key,
    columns,
    data,
    this.height,
  })  : columns = columns ?? [],
        data = data ?? [];

  final List columns;
  final List data;
  final double? height;

  @override
  Widget build(BuildContext context) {
    List _items = [];
    if (!Utils.isEmpty(data)) {
      for (var d in data) {
        List<Widget> _tableRowChildren1 = [];
        Utils.forEach(columns, (item, i) {
          bool _show = item['show'] ?? true;
          if (_show) {
            Widget _cell;
            if (item['type'] == 'render') {
              _cell = item['render'](d);
            } else {
              _cell = Text(
                (d[item['prop']] ?? '').toString(),
                style: TextStyle(fontSize: 12),
              );
            }
            _tableRowChildren1.add(Container(
              alignment: Alignment.center,
              height: 36,
              padding: EdgeInsets.all(5),
              // color: Colors.grey[300],
              child: _cell,
            ));
          }
        });
        _items.add(TableRow(
          children: _tableRowChildren1,
        ));
      }
    }

    Map<int, TableColumnWidth> _columnWidths = {};
    List<Widget> _tableRowChildren = [];
    Utils.forEach(columns, (item, i) {
      bool _show = item['show'] ?? true;
      if (_show) {
        _columnWidths[i] =
            item['width'] != null ? FixedColumnWidth(item['width']) : FlexColumnWidth(1);
        _tableRowChildren.add(Container(
          alignment: Alignment.center,
          height: 36,
          padding: EdgeInsets.all(5),
          color: Color(0xffF2F2F2),
          child: Text(
            item['label'],
            style: item['labelStyle'] ?? TextStyle(fontSize: 12),
          ),
        ));
      }
    });
    if (height != null) {
      return Column(
        children: [
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            // border: new TableBorder.all(width: 1.0, color: Colors.purpleAccent),
            columnWidths: _columnWidths,
            children: [
              TableRow(
                children: _tableRowChildren,
              ),
            ],
          ),
          Container(
            height: height,
            child: SingleChildScrollView(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                // border: new TableBorder.all(width: 1.0, color: Colors.purpleAccent),
                columnWidths: _columnWidths,
                children: [
                  ..._items,
                ],
              ),
            ),
          )
        ],
      );
    }

    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: new TableBorder.all(width: 1.0, color: Color(0xffdddddd)),
          columnWidths: _columnWidths,
          children: [
            TableRow(
              children: _tableRowChildren,
            ),
            ..._items,
          ],
        ));
  }
}
