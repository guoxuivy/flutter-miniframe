import 'dart:collection';
import 'package:dio/dio.dart';

import 'package:agent/boot.dart';
import 'package:agent/utils/utils.dart';


/// 认证拦截
class AuthInterceptors extends InterceptorsWrapper {
  static const String _secret = "juw342ewrgsU397U^guo*(@98df764#";

  @override
  Future onRequest(RequestOptions options) {
    String token = Boot.instance.user.token;
    // 如果已经登录 则带上登录key
    options.headers['key'] = token;
    options.headers['user-agent'] = 'szx';

    // 签名放在query中
    options.queryParameters['sign'] = _buildSign(options);
    return super.onRequest(options);
  }


  // 创建签名 path+post数据
  String _buildSign(RequestOptions options){
    String str = options.path; // '/api/index/indexData'
    if (null!=options.data) {
      var st = new SplayTreeMap.from(options.data); //key 升序排列
      for (var key in st.keys) {
        str = str + key + '=' + st[key].toString();
      }
    }
    str = str + _secret;
    // trace('front'+str);
    return Utils.ysMd5(str).toLowerCase();
  }

}
