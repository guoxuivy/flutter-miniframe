import 'dart:convert';
import 'dart:io';
import 'package:agent/config.dart';
import 'package:agent/net/http_manager.dart';
import 'package:agent/net/result.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/utils/local_storage.dart';
import 'package:agent/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:package_info/package_info.dart';

/// 初始化各种依赖，以便使用
class Boot {
  /// 单例
  static Boot instance;

  /// 配置文件
  CxeConfig _config;

  /// 本地存储
  LocalStorage _store;

  /// 当前登录用户信息
  User _user;

  /// 版本更新检查
  bool _hasNewVersion = false;
  Result _version;

  /// app初始化
  Future<void> onReady;

  CxeConfig get config => _config;

  LocalStorage get store => _store;

  User get user => _user;

  set user(User user) {
    this._user = user;
  }

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
      _user = User.fromMap(userJson);
      if (_user.token == null) {
        _user.token = "TOKEN@shitokencangxiaoer";
        _user.refreshCache();
      }
      HttpManager.initDio(baseUrl: _config.apiBaseUrl);
    });
  }

  /// app更新
  Future checkVersion() async {
    // 新版本检测
    _version = await HttpManager.instance.get("/api/index/agentVersion");
    if (!_version['latest_code'].isNull) {
      var targetVersion = _version['latest_code'].toString();
      var version = _config.packageInfo.version;
      var currentVersion = version.replaceAll('.', '');
      if (int.parse(targetVersion ?? '0') > int.parse(currentVersion)) {
        _hasNewVersion = true;
      }
    }
    if (_hasNewVersion) {
      bool up = await Dialogs.versionDialog(
          versionLog: '升级跟新日志\n1、升级跟新日志1\n2、升级跟新日志2\n3、升级跟新日志3\n');
      if (up) {
        if (Platform.isAndroid) {
          // 安卓弹窗提示本地下载， 交由flutter_xupdate 处理，不用我们干嘛。
          // await checkUpdate.initXUpdate();
          // checkUpdate.checkUpdateByUpdateEntity(versionData); // flutter_xupdate 自定义JSON 方式，
          trace('安卓更新逻辑' + _version.toString());
          // trace(result);
        } else if (Platform.isIOS) {
          // IOS 跳转 AppStore
          // showIOSDialog(); // 弹出ios提示更新框
          trace('IOS更新逻辑');
        }
      }
      _hasNewVersion = false;
    }
  }
}

/// 登录用户信息
class User {
  String phone;
  String name;
  String token;

  User({this.token, this.name, this.phone});

  /// 将实体类对象解析成json字符串
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'name': name,
      'token': token,
    };
  }

  /// 将json字符串解析成实体类对象
  User.fromMap(Map<String, dynamic> map) {
    if (map != null) {
      this.phone = map['phone'];
      this.name = map['name'];
      this.token = map['token'];
    }
  }

  /// 刷新缓存
  void refreshCache() {
    Boot.instance.store.setStorage("user", this.toJson());
  }

  @override
  String toString() {
    return 'User name: $name, phone: $phone, token: $token';
  }
}
