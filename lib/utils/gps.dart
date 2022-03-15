import 'dart:math';

class Gps {
  double wgLat=0;
  double wgLon=0;

  Gps(double wgLat, double wgLon) {
    setWgLat(wgLat);
    setWgLon(wgLon);
  }
  double getWgLat() {
    return wgLat;
  }

  void setWgLat(double wgLat) {
    this.wgLat = wgLat;
  }

  double getWgLon() {
    return wgLon;
  }

  void setWgLon(double wgLon) {
    this.wgLon = wgLon;
  }

  @override
  String toString() {
    return wgLat.toString() + "," + wgLon.toString();
  }
}

// ignore: slash_for_doc_comments
/**
 * 各地图API坐标系统比较与转换;
 * WGS84坐标系：即地球坐标系，国际上通用的坐标系。设备一般包含GPS芯片或者北斗芯片获取的经纬度为WGS84地理坐标系,
 * 谷歌地图采用的是WGS84地理坐标系（中国范围除外）;
 * GCJ02坐标系：即火星坐标系，是由中国国家测绘局制订的地理信息系统的坐标系统。由WGS84坐标系经加密后的坐标系。
 * 谷歌中国地图和搜搜中国地图采用的是GCJ02地理坐标系; BD09坐标系：即百度坐标系，GCJ02坐标系经加密后的坐标系;
 * 搜狗坐标系、图吧坐标系等，估计也是在GCJ02基础上加密而成的。 chenhua
 */
class PositionUtil {
  static final String BAIDU_LBS_TYPE = "bd09ll";

  static double pi = 3.1415926535897932384626;
  static double a = 6378245.0;
  static double ee = 0.00669342162296594323;

  // ignore: slash_for_doc_comments
  /**
   * 84 to 火星坐标系 (GCJ-02) World Geodetic System ==> Mars Geodetic System
   *
   * @param lat
   * @param lon
   * @return
   */
  static Gps? gps84_To_Gcj02(double lat, double lon) {
    if (outOfChina(lat, lon)) {
      return null;
    }
    double dLat = transformLat(lon - 105.0, lat - 35.0);
    double dLon = transformLon(lon - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    double mgLat = lat + dLat;
    double mgLon = lon + dLon;
    return new Gps(mgLat, mgLon);
  }

  /**
   * * 火星坐标系 (GCJ-02) to 84 * * @param lon * @param lat * @return
   * */
  static Gps gcj_To_Gps84(double lat, double lon) {
    Gps gps = transform(lat, lon);
    double lontitude = lon * 2 - gps.getWgLon();
    double latitude = lat * 2 - gps.getWgLat();
    return new Gps(latitude, lontitude);
  }

  /**
   * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 将 GCJ-02 坐标转换成 BD-09 坐标
   *
   * @param gg_lat
   * @param gg_lon
   */
  static Gps gcj02_To_Bd09(double gg_lat, double gg_lon) {
    double x = gg_lon, y = gg_lat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * pi);
    double bd_lon = z * cos(theta) + 0.0065;
    double bd_lat = z * sin(theta) + 0.006;
    return new Gps(bd_lat, bd_lon);
  }

  /**
   * * 火星坐标系 (GCJ-02) 与百度坐标系 (BD-09) 的转换算法 * * 将 BD-09 坐标转换成GCJ-02 坐标 * * @param
   * bd_lat * @param bd_lon * @return
   */
  static Gps bd09_To_Gcj02(double bd_lat, double bd_lon) {
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * pi);
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    return new Gps(gg_lat, gg_lon);
  }

  /**
   * (BD-09)-->84
   * @param bd_lat
   * @param bd_lon
   * @return
   */
  static Gps bd09_To_Gps84(double bd_lat, double bd_lon) {
    Gps gcj02 = PositionUtil.bd09_To_Gcj02(bd_lat, bd_lon);
    Gps map84 = PositionUtil.gcj_To_Gps84(gcj02.getWgLat(), gcj02.getWgLon());
    return map84;
  }

  static bool outOfChina(double lat, double lon) {
    if (lon < 72.004 || lon > 137.8347) return true;
    if (lat < 0.8293 || lat > 55.8271) return true;
    return false;
  }

  static Gps transform(double lat, double lon) {
    if (outOfChina(lat, lon)) {
      return new Gps(lat, lon);
    }
    double dLat = transformLat(lon - 105.0, lat - 35.0);
    double dLon = transformLon(lon - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
    double mgLat = lat + dLat;
    double mgLon = lon + dLon;
    return new Gps(mgLat, mgLon);
  }

  static double transformLat(double x, double y) {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
  }

  static double transformLon(double x, double y) {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
  }
}
