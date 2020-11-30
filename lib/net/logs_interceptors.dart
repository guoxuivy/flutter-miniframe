import 'package:dio/dio.dart';
import 'package:cxe/util/utils.dart';


/// 网络日志处理
class LogsInterceptors extends InterceptorsWrapper {
  DateTime _startTime;
  DateTime _endTime;

  @override
  Future onRequest(RequestOptions options) {
    _startTime = DateTime.now();
    // trace("请求baseUrl：${options.baseUrl}");
    // trace("请求url：${options.path}");
    trace('请求头: ' + options.headers.toString());
    // if (options.queryParameters.isNotEmpty) {
    //   trace('请求参数: ' + options.queryParameters.toString());
    // }
    // if (options.data != null) {
    //   trace('发送数据: ' + options.data.toString());
    // }
    return super.onRequest(options);
  }

  @override
  Future onResponse(Response response) {
    _endTime = DateTime.now();
    final int duration = _endTime.difference(_startTime).inMilliseconds;
    trace('----------End: $duration 毫秒----------');

    if (response != null) {
      var responseStr = response.toString();
      trace(responseStr);
    }
    return super.onResponse(response);
  }

  @override
  Future onError(DioError err) {
    String msg = 'DioError: [${err.request.path}]-' ;
    if (err.type == DioErrorType.CONNECT_TIMEOUT) {
      msg += "连接超时";
    } else if (err.type == DioErrorType.SEND_TIMEOUT) {
      msg += "请求超时";
    } else if (err.type == DioErrorType.RECEIVE_TIMEOUT) {
      msg += "响应超时";
    } else if (err.type == DioErrorType.RESPONSE) {
      msg += "响应异常";
    } else if (err.type == DioErrorType.CANCEL) {
      msg += "请求取消";
    } else {
      msg += "未知错误";
    }

    if (err.response != null) {
      msg += ' 错误码 : ' + err.response?.statusCode.toString();
    }
    trace(msg, logLevel.error);
    return super.onError(err);
  }
}
