import 'dart:convert';
import 'package:cxe/config.dart';
import 'package:cxe/net/http_manager.dart';
import 'package:cxe/routers/routers.dart';
import 'package:cxe/util/local_storage.dart';

import 'package:package_info/package_info.dart';

/// 初始化各种依赖，以便使用
class Boot {
  static Boot instance;

  CxeConfig _config;

  LocalStorage _store;

  User _user;

  Future<void> onReady;

  CxeConfig get config => _config;

  LocalStorage get store => _store;

  User get user => _user;

  factory Boot([CxeConfig config]) {
    if (instance == null) {
      instance = Boot._(config);
    }
    return instance;
  }

  Boot._(CxeConfig config) {
    _config = config;
    onReady = Future(() async {
      _config.packageInfo = await PackageInfo.fromPlatform();
      // 自定义初始化
      Routers.initRoutes(isDemo: _config.debug);
      // 本地存储init
      _store = LocalStorage.instance;
      var userJson = await _store.getStorage('user');
      _user = User.fromJsonMap(userJson);
      if (_user.token == null) {
        _user.token = "TOKEN@ddwoshitokencangxiaoer";
        _user.refreshCache();
      }
      HttpManager.initDio(baseUrl: _config.apiBaseUrl);
    });
  }
}

/// 登录用户信息
class User {
  String phone;
  String name;
  String token;

  User({this.token, this.name, this.phone});

  ///  将实体类对象解析成json字符串
  Map toJson() {
    Map map = new Map();
    map["phone"] = this.phone;
    map["name"] = this.name;
    map["token"] = this.token;
    return map;
  }

  String generateJson() {
    String jsonStr = jsonEncode(this);
    return jsonStr;
  }

  /// 将json字符串解析成实体类对象
  User.fromJsonMap(Map map) {
    if (map != null) {
      this.phone = map['phone'];
      this.name = map['name'];
      this.token = map['token'];
    }
  }

  void refreshCache() {
    Boot.instance.store.setStorage("user", this.generateJson());
  }
}
