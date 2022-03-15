import 'dart:convert';
import 'package:agent/config.dart';
import 'package:agent/net/http_manager.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/utils/local_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:agent/provider/user.dart';

/// 初始化各种依赖，以便使用
class Boot {
  /// 单例
  static Boot? _instance;

  static Boot get instance => _instance!;

  static bool get debug => _instance!._config!.debug;

  static CxeConfig get config => _instance!._config!;

  /// 配置文件
  CxeConfig? _config;

  /// 当前登录用户信息
  User? _user;

  /// 默认屏幕分辨率适配参数 >1000 用3倍图
  int _screenX = 2;

  int get screenX => _screenX;

  void setScreenX(int v) {
    this._screenX = v;
  }

  PackageInfo? _appInfo;
  PackageInfo get appInfo => _appInfo!;

  /// app初始化
  Future<void>? onReady;

  /// 本地存储
  // LocalStorage _store;
  // LocalStorage get store => _store;

  User get user => _user!;

  set user(User user) {
    this._user = user;
  }

  factory Boot(CxeConfig config) {
    if (_instance == null) {
      _instance = Boot._(config);
    }
    return instance;
  }

  Boot._(CxeConfig config)  {
    _config = config;
    onReady = Future(() async {
       _appInfo = await PackageInfo.fromPlatform();
      // 自定义初始化
      Routers.initRoutes(isDemo: config.isDemo);
      // 本地存储init
      _user = await Boot.loadUser();
    });
  }

  static void saveUser(User user) {
    LocalStorage.instance.setStorage("user", json.encode(user));
  }

  static Future<User> loadUser() async {
    var userJson = await LocalStorage.instance.getStorage('user');
    if (userJson == null) {
      return User(id: 0, phone: '', name: '');
    } else {
      return User.fromJson(userJson);
    }
  }
}
