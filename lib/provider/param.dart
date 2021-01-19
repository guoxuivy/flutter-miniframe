import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


/// http 参数管理
final ChangeNotifierProvider<MyParam> paramProvider =
    ChangeNotifierProvider((_) => MyParam());

/// 主题状态管理 （夜间模式）
class MyParam extends ChangeNotifier {
  /// 默认light模式
  Map<String,dynamic> _param = {};
  Map<String,dynamic> get data => _param;

  void clean(){
    _param = {};
  }

  /// 切换主题夜间模式
  void change(Map<String,dynamic> param) {
    _param = param;
    /// 通知刷新
    notifyListeners();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    clean();
  }

}
