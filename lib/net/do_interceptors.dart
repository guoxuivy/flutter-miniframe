import 'package:dio/dio.dart';

/// 数据转换
class DoInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options,handler) {
    if (options.method == 'GET') {
      if (options.queryParameters.isNotEmpty) {
        for (var key in options.queryParameters.keys) {
          var value = options.queryParameters[key];
          if (value is List) {
            // 数组转换成字符串
            if (options.queryParameters[key].length > 0) {
              options.queryParameters[key] = options.queryParameters[key].join(',');
            } else {
              options.queryParameters[key] = '-999';
              // options.queryParameters.remove(key);
            }
          } else if (value == -999) {
            // 过滤-999
            // options.queryParameters.remove(key);
          }
        }
      }
    }
    return handler.next(options);
  }
}
