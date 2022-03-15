import 'package:agent/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class YsDrag extends StatefulWidget {
  YsDrag({
    Key? key,
    required this.data,
    this.crossAxisCount = 4,
    this.renderItem,
    this.append,
    this.onChanged,
    this.padding,
  }) : super(key: key);

  final List<Map<String, dynamic>> data;
  final int crossAxisCount;
  final renderItem;
  final append;
  final onChanged;
  final padding;

  @override
  YsDragState createState() => YsDragState();
}

class YsDragState extends State<YsDrag> {
  Map<String, dynamic>? _movingValue; // 记录正在移动的数据
  List<Map<String, dynamic>> _data = [];

  double _size = 100;
  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  void didUpdateWidget(covariant YsDrag oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    _size = (MediaQuery.of(context).size.width - 30) / widget.crossAxisCount;
    return Container(
      padding: widget.padding ?? EdgeInsets.all(0),
      width: MediaQuery.of(context).size.width,
      child: GridView(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.crossAxisCount,
          mainAxisSpacing: 5.0,
          crossAxisSpacing: 5.0,
          childAspectRatio: 1,
        ),
        children: buildItems(),
        physics: NeverScrollableScrollPhysics(), //禁止滚动
      ),
    );
  }

  // 生成GridView的items
  List<Widget> buildItems() {
    List<Widget> items = [];
    Utils.forEach(_data, (value, index) {
      items.add(draggableItem(value, index));
    });
    if (widget.append != null) {
      items.add(widget.append(_size));
    }
    return items;
  }

  // 生成可拖动的item
  Widget draggableItem(value, index) {
    return Draggable(
      data: value,
      child: DragTarget(
        builder: (context, candidateData, rejectedData) {
          return baseItem(value, Colors.grey, index);
        },
        onWillAccept: (moveData) {
          // print('=== onWillAccept: $moveData ==> $value');

          var accept = moveData != null;
          if (accept) {
            exchangeItem(moveData, value, false);
          }
          return accept;
        },
        onAccept: (moveData) {
          // print('=== onAccept: $moveData ==> $value');
          exchangeItem(moveData, value, true);
        },
        onLeave: (moveData) {
          // print('=== onLeave: $moveData ==> $value');
        },
      ),
      feedback: baseItem(value, Colors.grey.withOpacity(0.5), index),
      childWhenDragging: null,
      onDragStarted: () {
        // print('=== onDragStarted');
        setState(() {
          _movingValue = value; //记录开始拖拽的数据
        });
      },
      onDraggableCanceled: (Velocity velocity, Offset offset) {
        // print('=== onDraggableCanceled');
        setState(() {
          _movingValue = null; //清空标记进行重绘
        });
      },
      onDragCompleted: () {
        // print('=== onDragCompleted');
        if (widget.onChanged != null) {
          widget.onChanged(_data);
        }
      },
    );
  }

  // 基础展示的item 此处设置width,height对GridView 无效，主要是偷懒给feedback用
  Widget baseItem(value, bgColor, index) {
    if (value == _movingValue) {
      return Container();
    }
    return Container(
      width: _size,
      height: _size,
      color: bgColor,
      alignment: Alignment.center,
      child: widget.renderItem(size: _size, item: value, index: index),
    );
  }

  // 重新排序
  void exchangeItem(moveData, toData, onAccept) {
    setState(() {
      var toIndex = _data.indexOf(toData);

      _data.remove(moveData);
      _data.insert(toIndex, moveData);

      if (onAccept) {
        _movingValue = null;
      }
    });
  }
}
