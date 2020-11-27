import 'package:dio/dio.dart';
import 'package:cxe/util/utils.dart';

/// 认证拦截
class AuthInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) {
    // 如果已经登录 则带上登录key
    options.headers['key'] = Utils.getToken();
    // 可添加接口参数验签逻辑
    return super.onRequest(options);
  }
}
