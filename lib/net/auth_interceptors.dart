import 'package:cxe/boot.dart';
import 'package:dio/dio.dart';
import 'package:cxe/util/utils.dart';
import 'package:flutter/rendering.dart';

/// 认证拦截
class AuthInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    String token = Boot.instance.user.token;
    // 如果已经登录 则带上登录key
    options.headers['key'] = token;
    options.headers['user-agent'] = 'szx';
    // 可添加接口参数验签逻辑
    return super.onRequest(options);
  }
}
