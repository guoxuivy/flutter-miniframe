/*
 * Copyright (c) [2020] [Sean Guo]
 * [flutter-minifram] is licensed under the Mulan PSL v1.
 * You can use this software according to the terms and conditions of the Mulan PSL v1.
 * You may obtain a copy of Mulan PSL v1 at: http://license.coscl.org.cn/MulanPSL
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY KIND, EITHER EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE.
 * See the Mulan PSL v2 for more details.
*/

import 'package:flutter/material.dart';

import 'package:cxe/page/demo/home.dart';
import 'package:cxe/routers/not_found_page.dart';
import 'package:cxe/util/utils.dart';

/// 定义拦截器类型
typedef RoutersInterceptor = RouteSettings Function(RouteSettings settings);

/// 全局路由管理类
class Routers {
  /// 路由拦截器  先进先出原则
  static List<RoutersInterceptor> _interceptorList = [];

  /// 路由表注册
  static Map<String, WidgetBuilder> _routerMap = {};

  /// 初始化配置
  static void initRoutes({bool isDemo = true}) {
    if (isDemo) {
      _routerMap = demoRouterMap;
    } else {
      // todo 正式路由表
    }

    /// 注册拦截器 先进先出执行
    _interceptorList.add((RouteSettings settings) {
      trace(settings.name, logLevel.info);
      // TODO: 登录检测
      if (settings.name == '/login') {
        return RouteSettings(name: '/login');
      }
      return settings;
    });
    _interceptorList.add((RouteSettings settings) {
      // TODO: 验证权限
      return settings;
    });
  }

  /// 路由跳转执行入口 会重构页面
  static Future<dynamic> go(BuildContext ctx, String name, [Object args]) {
    if (args != null) {
      trace(args, logLevel.info);
      return Navigator.pushNamed(ctx, name, arguments: args);
    } else {
      return Navigator.pushNamed(ctx, name);
    }
  }

  /// 路由派发
  static MaterialPageRoute<dynamic> generate(RouteSettings settings) {
    /// 执行拦截器
    _interceptorList.forEach((_interceptor) {
      settings = _interceptor(settings);
    });

    /// 页面跳转
    final String name = settings.name;
    final Map<String, dynamic> arguments = settings.arguments;
    final Function pageBuilder = _routerMap[name];
    if (pageBuilder != null) {
      if (arguments != null) {
        // 如果传了参数
        return MaterialPageRoute(builder: (ctx) => pageBuilder(ctx, arguments));
      } else {
        return MaterialPageRoute(builder: (ctx) => pageBuilder(ctx));
      }
    }
    return MaterialPageRoute(builder: (ctx) => NotFoundPage());
  }

  /// 返回 不走拦截器
  static void goBack(BuildContext context) {
    _unFocus();
    Navigator.pop(context);
  }

  /// 带参数返回 不走拦截器
  static void goBackWithParams(BuildContext context, Object args) {
    _unFocus();
    Navigator.pop<Object>(context, args);
  }

  /// 跳到WebView页
  // static void goWebViewPage(BuildContext context, String title, String url) {
  //   //fluro 不支持传中文,需转换
  //   // push(context, '${Routes.webViewPage}?title=${Uri.encodeComponent(title)}&url=${Uri.encodeComponent(url)}');
  // }

  static void _unFocus() {
    // 使用下面的方式，会触发不必要的build。
    // FocusScope.of(context).unfocus();
    // https://github.com/flutter/flutter/issues/47128#issuecomment-627551073
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
