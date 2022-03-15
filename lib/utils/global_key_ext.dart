import 'package:flutter/material.dart';

extension GlobalKeyExt on GlobalKey {
  /// 获取当前组件的 RenderBox
  RenderBox? renderBox() {
    RenderObject? renderObj = this.currentContext?.findRenderObject();
    if (renderObj == null || renderObj is! RenderBox) {
      return null;
    }
    RenderBox renderBox = renderObj;
    return renderBox;
  }

  /// 获取当前组件的 Offset
  Offset globalOffset() {
    if (this.renderBox() == null) {
      return Offset.zero;
    }
    var point = this.renderBox()!.localToGlobal(Offset.zero); //组件坐标
    return point;
  }

  /// 获取当前组件的 Size
  Size globalSize() {
    if (this.renderBox() == null) {
      return Size.zero;
    }
    return this.renderBox()!.size;
  }
}
