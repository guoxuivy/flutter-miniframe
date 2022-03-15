import 'dart:convert';
import 'dart:io';
import 'package:agent/boot.dart';
import 'package:agent/net/do_interceptors.dart';
import 'package:agent/net/result.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/utils/file.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:agent/net/logs_interceptors.dart';
import 'package:agent/net/auth_interceptors.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/config.dart';

/// demo
//     CancelToken token = new CancelToken();
//     HttpManager.instance.post(
//         '/backapi/system/stat2', data: {'id': '123', 'msg': 'csfasd'},cancelToken:token).then((res) {
//       print(res);
//     });
//     HttpManager.instance.cancelRequests(token);
/// demo

/// 网络请简单求封装
class HttpManager {
  /// 默认dio配置
  int _connectTimeout = 10000; //超时时间设定
  int _receiveTimeout = 10000;
  int _sendTimeout = 10000;
  CxeConfig _config = CxeConfig();

  //单例模式，只创建一次实例
  static HttpManager get instance => HttpManager();

  factory HttpManager() => _singleton;
  static final HttpManager _singleton = HttpManager._();
  static Dio? _dio;
  static Dio get dio => _dio!;

  ///私有构造函数
  HttpManager._() {
    final BaseOptions _options = new BaseOptions(
        // baseUrl: _baseUrl,
        baseUrl: _config.apiBaseUrl,
        //连接时间为5秒
        connectTimeout: _connectTimeout,
        //响应时间为3秒
        receiveTimeout: _receiveTimeout,
        //发送时间为3秒
        sendTimeout: _sendTimeout,
        //设置请求头
        headers: {"resource": "app"},
        //默认值是"application/json; charset=utf-8",Headers.formUrlEncodedContentType会自动编码请求体.
        // contentType: Headers.formUrlEncodedContentType,
        contentType: Headers.jsonContentType,
        //共有三种方式json,bytes(响应字节),stream（响应流）,plain
        responseType: ResponseType.json);
    _dio = new Dio(_options);
    //设置Cookie  采用token机制
    // _dio.interceptors.add(CookieManager(CookieJar()));
    if (_config.proxy != '') {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
        client.findProxy = (uri) {
          //proxy all request to localhost:8888
          return 'PROXY ' + _config.proxy;
        };
      };
    }

    dio.interceptors.add(AuthInterceptors());
    dio.interceptors.add(DoInterceptors());
    if (Boot.debug) {
      //网络日志处理
      dio.interceptors.add(LogsInterceptors());
    }
  }

  /// 返回值格式化
  Result parseResponse(Response? data, {method = 'get', showToast = true}) {
    if (data == null) {
      return Result.nul();
    }
    Map<String, dynamic>? res = json.decode(data.toString());
    if (res == null) {
      return Result.nul();
    }
    if (!Utils.isEmpty(res)) {
      if (res['code'] == 401) {
        // trace('401信息跳转到login');
        // Dialogs.unauthorized('用户未登录');
        Dialogs.showToast(
          msg: res['msg'] ?? '未登录',
          type: 'warning',
        );
        Routers.go(Routers.context(), '/login');
      } else if (res['code'] == 403) {
        // Dialogs.tips('接口签名错误');
        Dialogs.showToast(
          msg: '接口签名错误',
          type: 'warning',
        );
      } else if (method == 'post') {
        if (res['code'] == 1) {
          if (showToast) {
            Dialogs.showToast(
              msg: Utils.isEmpty(res['msg']) ? '成功！' : res['msg'],
              type: 'success',
            );
          }
        } else {
          Dialogs.showToast(
            msg: res['msg'] ?? '未知错误！',
            type: 'warning',
          );
        }
      }
    }
    return Result(res);
  }

  /// post请求
  Future<Result> post(url, {data, options, cancelToken}) async {
    Response? response;
    try {
      response = await dio.post(
        url,
        queryParameters: null,
        options: options,
        cancelToken: cancelToken,
        data: data,
      );
    } on DioError catch (e) {
      if (e.type != DioErrorType.cancel) {
        Dialogs.tips('网络或服务器异常: ' + e.message);
      }
    }
    return parseResponse(response, method: 'post');
  }

  /// get请求
  Future<Result> get(url, {data, options, bool loading = false, cancelToken}) async {
    Response? response;
    try {
      if (loading) {
        Dialogs.showLoading();
      }
      // 与post 参数名称一致 方便调用
      response = await dio.get(
        url,
        queryParameters: data,
        options: options,
        cancelToken: cancelToken,
      );

      if (loading) {
        Dialogs.easyLoadingDismiss();
      }
    } on DioError catch (e) {
      if (e.type != DioErrorType.cancel) {
        // Dialogs.tips('统一气泡弹出提示网络或服务器异常: ' + e.message);
        Dialogs.showToast(
          msg: e.message,
          type: 'warning',
        );
      }
    }
    return parseResponse(response);
  }

  ///下载文件
  ///todo 可扩回调函数处理下载进度条
  downLoadFile(urlPath, savePath) async {
    Response response;
    response = await dio.download(urlPath, savePath, onReceiveProgress: (int received, int total) {
      if (total != -1) {
        trace((received / total * 100).toStringAsFixed(0) + "%");
      }
    });
    return response;
  }

  /// 上传文件
  Future<Result> upLoad(url, File image, {bool loading = true, cancelToken}) async {
    Response? response;
    try {
      String path = image.path;
      String name = FileUtils.name(path);
      // MediaType
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          path,
          filename: name,
          contentType: FileUtils.mediaType(path),
        )
      });
      if (loading) {
        Dialogs.showLoading();
      }
      Dio dio = new Dio();
      response = await dio.post<String>(url, data: formData, cancelToken: cancelToken);
      if (loading) {
        Dialogs.easyLoadingDismiss();
      }
      dio.close();
    } on DioError catch (e) {
      if (e.type != DioErrorType.cancel) {
        Dialogs.showToast(
          msg: e.message,
        );
      }
    }
    return parseResponse(response, method: 'post', showToast: false);
  }

  /// 取消请求
  cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }
}
