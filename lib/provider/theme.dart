import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:agent/res/resources.dart';

///定义 global 主题状态
final ChangeNotifierProvider<MyTheme> themeProvider =
    ChangeNotifierProvider((_) => MyTheme());

/// 主题状态管理 （夜间模式）
class MyTheme extends ChangeNotifier {
  /// 默认light模式
  ThemeMode _themeValue = ThemeMode.light;
  // ThemeMode _themeValue = ThemeMode.dark;

  ThemeMode get mode => _themeValue;

  /// 切换主题夜间模式
  void change() {
    if (ThemeMode.dark == _themeValue) {
      _themeValue = ThemeMode.light;
    } else {
      _themeValue = ThemeMode.dark;
    }

    /// 通知刷新
    notifyListeners();
  }

  ThemeData getTheme() {
    bool isDarkMode = ThemeMode.dark == _themeValue;

    return ThemeData(
      errorColor: isDarkMode ? Colours.dark_red : Colours.red,
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      //深色还是浅色
      primaryColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
      accentColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
      // Tab指示器颜色
      indicatorColor: isDarkMode ? Colours.dark_app_main : Colours.app_main,
      // 页面背景色
      scaffoldBackgroundColor:
          isDarkMode ? Colours.dark_bg_color : Colors.white,
      // 主要用于Material背景色
      canvasColor: isDarkMode ? Colours.dark_material_bg : Colors.white,
      // 文字选择色（输入框复制粘贴菜单）
      textSelectionColor: Colours.app_main.withAlpha(70),
      textSelectionHandleColor: Colours.app_main,
      // 稳定发行版：1.23 变更(https://flutter.dev/docs/release/breaking-changes/text-selection-theme)
      textSelectionTheme: TextSelectionThemeData(
        selectionColor: Colours.app_main.withAlpha(70),
        selectionHandleColor: Colours.app_main,
      ),
      textTheme: TextTheme(
        // TextField输入文字颜色
        subtitle1: isDarkMode ? TextStyles.textDark : TextStyles.text,
        // Text文字样式
        bodyText2: isDarkMode ? TextStyles.textDark : TextStyles.text,
        subtitle2: isDarkMode ? TextStyles.textDarkGray12 : TextStyles.textGray12,
        // subtitle2: isDarkMode ? TextStyles.textWhite14 : TextStyles.textGray12,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle:
            isDarkMode ? TextStyles.textHint14 : TextStyles.textDarkGray14,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0.0,
        color: isDarkMode ? Colours.dark_bg_color : Colors.grey[800],
        brightness: isDarkMode ? Brightness.dark : Brightness.dark,
      ),
      dividerTheme: DividerThemeData(
          color: isDarkMode ? Colours.dark_line : Colours.line,
          space: 0.6,
          thickness: 0.6),
      bottomAppBarTheme:BottomAppBarTheme(
          color:Colors.white,
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        //浮动按钮样式 after v1.13.2. 后不建议使用
        backgroundColor: Colors.blue,
      ),
    );
  }
}
