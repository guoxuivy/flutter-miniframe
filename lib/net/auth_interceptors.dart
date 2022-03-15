import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:agent/boot.dart';
import 'package:agent/utils/utils.dart';

/// 认证拦截
class AuthInterceptors extends InterceptorsWrapper {
  static const String _secret = "juw342ewrgsU397U^guo*(@98df764#";

  @override
  void onRequest(RequestOptions options, handler) {
    String token = Boot.instance.user.token;
    // 如果已经登录 则带上登录key
    options.headers['key'] = token;
    options.headers['user-agent'] = 'szx CxeAgent';
    // 签名放在query中
    options.queryParameters['sign'] = _buildSign(options);
    return handler.next(options); //continue
  }

  // 创建签名 path+post数据
  String _buildSign(RequestOptions options) {
    String str = options.path;
    if (null != options.data) {
      str = str + json.encode(options.data);
    }
    str = str.replaceAll('"', "").replaceAll('\\', "") + _secret; //移除双引号 \号  消除语言歧义
    return Utils.ysMd5(str).toLowerCase();
  }
}
