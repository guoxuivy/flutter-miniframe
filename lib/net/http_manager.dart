import 'dart:convert';
import 'package:cxe/net/result.dart';
import 'package:dio/dio.dart';
import 'package:cxe/net/logs_interceptors.dart';
import 'package:cxe/net/auth_interceptors.dart';
import 'package:cxe/util/utils.dart';

// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
// import 'package:cookie_jar/cookie_jar.dart';

/// demo
//     CancelToken token = new CancelToken();
//     HttpManager.instance.post(
//         '/backapi/system/stat2', data: {'id': '123', 'msg': 'csfasd'},cancelToken:token).then((res) {
//       print(res);
//     });
//     HttpManager.instance.cancelRequests(token);
/// demo

/// 默认dio配置
int _connectTimeout = 5000;
int _receiveTimeout = 3000;
int _sendTimeout = 10000;
String _baseUrl = 'http://www.zcdt.local';


/// 网络请简单求封装
class HttpManager {
  //单例模式，只创建一次实例
  static HttpManager get instance => HttpManager();

  factory HttpManager() => _singleton;
  static final HttpManager _singleton = HttpManager._();
  static Dio _dio;


  /// 初始化Dio配置
  static void initDio({
    int connectTimeout,
    int receiveTimeout,
    int sendTimeout,
    String baseUrl,
  }) {
    _connectTimeout = connectTimeout ?? _connectTimeout;
    _receiveTimeout = receiveTimeout ?? _receiveTimeout;
    _sendTimeout = sendTimeout ?? _sendTimeout;
    _baseUrl = baseUrl ?? _baseUrl;
  }


  ///私有构造函数
  HttpManager._() {
    final BaseOptions _options = new BaseOptions(
        baseUrl: _baseUrl,
        //连接时间为5秒
        connectTimeout: _connectTimeout,
        //响应时间为3秒
        receiveTimeout: _receiveTimeout,
        //发送时间为3秒
        sendTimeout: _sendTimeout,
        //设置请求头
        headers: {"resource": "app"},
        //默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
        contentType: Headers.formUrlEncodedContentType,
        //共有三种方式json,bytes(响应字节),stream（响应流）,plain
        responseType: ResponseType.json);
    _dio = new Dio(_options);
    //设置Cookie  采用token机制
    // _dio.interceptors.add(CookieManager(CookieJar()));

    _dio.interceptors.add(AuthInterceptors());
    if (isDebug) {
      //网络日志处理
      _dio.interceptors.add(LogsInterceptors());
    }
  }

  /// 返回值格式化
  Result parseResponse(Response data) {
    Map<String, dynamic> res =
        json.decode(data.toString()) as Map<String, dynamic>;
    if(res==null){
      // 防止顶层异常
      res = Map<String, dynamic>();
    }
    if(res!=null && res.isNotEmpty && res['code']==401){
      trace('401信息跳转到login');
    }
    return Result(res);
  }

  /// post请求
  Future<Result> post(url, {data, options, cancelToken}) async {
    Response response;
    try {
      response = await _dio.post(url,
          queryParameters: null,
          options: options,
          cancelToken: cancelToken,
          data: data);
    } on DioError catch (e) {
      if(e.type != DioErrorType.CANCEL){
        trace('统一气泡弹出提示网络或服务器异常');
      }
    }
    return parseResponse(response);
  }

  /// get请求
  Future<Result> get(url, {data, options, cancelToken}) async {
    Response response;
    try {
      // 与post 参数名称一致 方便调用
      response = await _dio.get(url,
          queryParameters: data, options: options, cancelToken: cancelToken);
    } on DioError catch (e) {
      if (e.type != DioErrorType.CANCEL) {
        trace('统一气泡弹出提示网络或服务器异常');
      }
    }
    return parseResponse(response);
  }




  ///下载文件
  ///todo 可扩回调函数处理下载进度条
  downLoadFile(urlPath, savePath) async {
    Response response;
    response = await _dio.download(urlPath, savePath,
        onReceiveProgress: (int received, int total) {
      // trace('$received $total');
      if (total != -1) {
        trace((received / total * 100).toStringAsFixed(0) + "%");
      }
    });
    return response;
  }

  /// 取消请求
  cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
