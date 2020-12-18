import 'dart:convert';
import 'dart:io';
import 'package:cxe/config.dart';
import 'package:cxe/net/http_manager.dart';
import 'package:cxe/net/result.dart';
import 'package:cxe/routers/routers.dart';
import 'package:cxe/util/local_storage.dart';
import 'package:cxe/util/utils.dart';
import 'package:flutter/cupertino.dart';

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

      // 新版本检测
      _version = await HttpManager.instance.get("/wapi/home/version");
      var targetVersion = _version['latest_code'].toString();
      var version = _config.packageInfo.version;
      var currentVersion = version.replaceAll('.', '');
      if (int.parse(targetVersion) > int.parse(currentVersion)) {
        _hasNewVersion = true;
      }
    });
  }

  /// app更新
  void checkVersion(BuildContext context) async {
    if (_hasNewVersion) {
      bool up = await Utils.versionDialog(context,
          versionLog: '升级跟新日志\n1、升级跟新日志1\n2、升级跟新日志2\n3、升级跟新日志3\n');
      if (up) {
        if (Platform.isAndroid) {
          // 安卓弹窗提示本地下载， 交由flutter_xupdate 处理，不用我们干嘛。
          // await checkUpdate.initXUpdate();
          // checkUpdate.checkUpdateByUpdateEntity(versionData); // flutter_xupdate 自定义JSON 方式，
          trace('安卓更新逻辑'+ _version.toString());
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
