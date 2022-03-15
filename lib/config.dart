// 开发配置
const defBaseDebug = String.fromEnvironment('BASE_URL', defaultValue: 'http://www.zcdt.local');
// const defBaseDebug = String.fromEnvironment('BASE_URL', defaultValue: 'http://dev.app.com');
const defImgDebug = String.fromEnvironment('IMG_URL', defaultValue: 'http://img.cxe.local');

// 生产配置
const defBase = String.fromEnvironment('BASE_URL', defaultValue: 'https://www.cangxiaoer.com');
const defImg = String.fromEnvironment('IMG_URL', defaultValue: 'https://img.cangxiaoer.com');
const http_proxy = String.fromEnvironment('PROXY', defaultValue: '');

class CxeConfig {
  bool isDemo;
  bool enableLog;
  bool enableApiLog;

  String apiBaseUrl = '';
  String imgBaseUrl = '';
  String vrUrl;
  String proxy;
  String mapAk;

  CxeConfig({
    this.isDemo = false,
    this.enableLog = true,
    this.enableApiLog = true,
    // this.apiBaseUrl = defBase,
    // this.imgBaseUrl = defImg,
    this.vrUrl = 'http://223.76.244.44:8081/pano/',
    this.proxy = http_proxy,
    this.mapAk = '1hrKaakG5iBUhv99pka4XCdvhphi4014',
  }) {
    this.apiBaseUrl = debug ? defBaseDebug : defBase;
    this.imgBaseUrl = debug ? defImgDebug : defImg;
  }

  bool get debug {
    bool inDebugMode = false;
    assert(inDebugMode = true); //如果debug模式下会触发赋值
    return inDebugMode;
  }
}
