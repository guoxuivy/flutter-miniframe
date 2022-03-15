import 'dart:convert';
import 'dart:typed_data';
import 'package:agent/utils/utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:fluwx_no_pay/fluwx_no_pay.dart';
import 'dart:ui' as ui;

class ShareUtils {
  // 生成微信小程序二维码图片
  static Future<Uint8List> getWXacode({url}) async {
    //获取token
    var res = await Dio().get(
        'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wx841ff93a82106447&secret=add34e1d56c11e78f0ede7675297f250');
    Map res1 = json.decode(res.toString()) as Map<String, dynamic>;
    String _token = res1['access_token'];
    try {
      Response response;
      response = await Dio().post("https://api.weixin.qq.com/wxa/getwxacode?access_token=" + _token,
          queryParameters: null,
          data: {
            "path": url,
            "width": 100,
            "auto_color": false,
            "line_color": {"r": 0, "g": 0, "b": 0}
          },
          options: Options(responseType: ResponseType.bytes));
      Uint8List byteList = Uint8List.fromList(response.data);
      return byteList;
    } catch (e) {
      print('error');
      return Uint8List(0);
    }
  }

  /// 截屏图片生成图片流ByteData
  static Future<Uint8List> capturePng(globalKey) async {
    RenderRepaintBoundary boundary = globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List picBytes = byteData!.buffer.asUint8List();
    return picBytes;
  }

  /// 配置初始化
  static Future initConfig() async {
    await registerWxApi(
        appId: "wx0b881930049ca118",
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://your.univerallink.com/link/"); //ios要填这个
    var result = await isWeChatInstalled;
    trace(result);
    return;
  }

// 分享给好友
  static shareSession({
    url,
    title = '',
    repaintWidgetKey,
  }) async {
    await initConfig();
    Uint8List capImg = await capturePng(repaintWidgetKey);
    var model = new WeChatShareMiniProgramModel(
      webPageUrl: 'https://www.cangxiaoer.com',
      userName: 'gh_6db00bbd8df6',
      title: title,
      path: url,
      description: '仓小二',
      thumbnail: WeChatImage.binary(capImg),
      // thumbnail: WeChatImage.network('https://www.cangxiaoer.com/static/home4/images/logo.png'),
    );
    shareToWeChat(model);
  }

  // 分享朋友圈
  static shareTimeline({
    url,
    title = '',
    repaintWidgetKey,
  }) async {
    await initConfig();
    Uint8List capImg = await capturePng(repaintWidgetKey);
    // 二维码+截屏合成分享图片
    /*  Uint8List acode = await getWXacode(url: url);
    img.Image tmp = img.drawImage(img.decodePng(capImg), img.decodeJpg(acode),
        dstX: 230, dstY: 480, dstH: 120, dstW: 120);
    // 待分享的图片资源
    WeChatImage source = WeChatImage.binary(img.encodePng(tmp)); */
    WeChatImage source = WeChatImage.binary(capImg);
    shareToWeChat(WeChatShareImageModel(
      source,
      thumbnail: source,
      scene: WeChatScene.TIMELINE,
    ));
  }
}
