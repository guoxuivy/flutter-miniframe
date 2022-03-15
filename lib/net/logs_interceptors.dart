import 'package:agent/boot.dart';
import 'package:dio/dio.dart';
import 'package:agent/utils/utils.dart';

/// 网络日志处理
class LogsInterceptors extends InterceptorsWrapper {
  DateTime? _startTime;
  DateTime? _endTime;

  @override
  void onRequest(RequestOptions options,handler) {
    _startTime = DateTime.now();

    String logStr =
        '请求头: ' + options.headers.toString() + '\n' + '请求接口: ${options.baseUrl}${options.path}';

    if (options.queryParameters.isNotEmpty) {
      logStr = logStr + ' \n请求参数: ' + options.queryParameters.toString();
    }
    if (options.data != null) {
      logStr = logStr + '\n发送数据: ' + options.data.toString();
    }
    _log(logStr);
    return handler.next(options);
  }

  @override
  void onResponse(Response response,handler) {
    _endTime = DateTime.now();
    final int duration = _endTime!.difference(_startTime!).inMilliseconds;
    _log('End: $duration 毫秒');
    handler.next(response);
  }

  void _log(dynamic log) {
    if (Boot.config.enableLog) {
      trace(log, logLevel.info);
    }
  }

  @override
  void onError(DioError err,handler) {
    String msg = 'DioError: [${err.requestOptions.path}]-';
    err.requestOptions.queryParameters.forEach((key, value) {
      msg += '$key=$value&';
    });
    if (err.type == DioErrorType.connectTimeout) {
      msg += "连接超时";
    } else if (err.type == DioErrorType.sendTimeout) {
      msg += "请求超时";
    } else if (err.type == DioErrorType.receiveTimeout) {
      msg += "响应超时";
    } else if (err.type == DioErrorType.response) {
      msg += "响应异常";
    } else if (err.type == DioErrorType.cancel) {
      msg += "请求取消";
    } else {
      msg += "未知错误 : " + err.toString();
    }

    if (err.response != null) {
      msg += ' 错误码 : ' + err.response!.statusCode.toString();
    }
    trace(msg, logLevel.error);
    return handler.next(err);
  }
}
