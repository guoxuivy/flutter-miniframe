import 'dart:async';

import 'package:agent/res/colors.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/services/map_controller.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:agent/widgets/buttons/ys_button_back.dart';
import 'package:agent/widgets/ys_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bmflocation/bdmap_location_flutter_plugin.dart';
import 'package:flutter_bmflocation/flutter_baidu_location.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_android_option.dart';
import 'package:flutter_bmflocation/flutter_baidu_location_ios_option.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agent/provider/map_location.dart';

/// 地图坐标拾取
class YsMapPicker extends StatefulWidget {
  //导航到Marker
  YsMapPicker({Key? key, @required this.mapLocation, this.mapPolygon, this.title}) : super(key: key);

  final List? mapLocation; //[114.207229,30.650951]
  final Map? mapPolygon; //{paths: [{lat: 11, lng: 111}], marker: {lat: 11, lng: 111}, zoom: 16}
  final String? title;

  @override
  _YsMapPickerState createState() => _YsMapPickerState();
}

class _YsMapPickerState extends State<YsMapPicker> {
  MapController _mapController = MapController();
  int _mode = 1;

  double? lon; //经度 114
  double? lat; //纬度 30

  late StreamSubscription<Map<String, Object>?> _locationListener;
  LocationFlutterPlugin _locationPlugin = new LocationFlutterPlugin();

  @override
  void initState() {
    super.initState();

    /// 动态申请定位权限
    _locationPlugin.requestPermission();

    /// 设置ios端ak, android端ak可以直接在清单文件中配置
    _locationListener = _locationPlugin.onResultCallback().listen((Map<String, Object>? result) {
      BaiduLocation newLocation = BaiduLocation.fromMap(result); // 将原生端返回的定位结果信息存储在定位结果类中
      _mapController.city = newLocation.city ?? _mapController.city;
      if (newLocation.errorCode == null) {
        context.read(locationProvider).change(newLocation.latitude!, newLocation.longitude!);
      }
    });


    _startLocation();
    _mapController.setOption(
      // from重新打开时，显示原状态
      mapLocation: List.from(widget.mapLocation ?? []),
      mapPolygon: Map.from(widget.mapPolygon ?? {'paths': [], 'marker': null}),
      mapPressed: (point) {
        if (_mode == 1) {
          _mapController.initMarker(point);
        } else if (_mode == 2) {
          _mapController.initPolyline(point);
        } else if (_mode == 3) {
          _mapController.initMarkerGate(point);
        }
        setState(() {});
      },
      showZoomControl: false,
    );
  }

  /// 设置android端和ios端定位参数
  void _setLocOption() {
    /// android 端设置定位参数
    BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
    androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
    androidOption.setScanspan(1000); // 设置发起定位请求时间间隔

    Map androidMap = androidOption.getMap();

    /// ios 端设置定位参数
    ///
    BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
    iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    iosOption.setBMKLocationCoordinateType("BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
    iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
    iosOption.setLocationTimeout(10); // 设置位置获取超时时间
    iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
    iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
    iosOption.setDistanceFilter(100); // 设置定位最小更新距离
    iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
    iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停

    Map iosMap = iosOption.getMap();
    _locationPlugin.prepareLoc(androidMap, iosMap);
  }

  /// 启动定位
  void _startLocation() {
    _setLocOption();
    _locationPlugin.startLocation();
  }

  /// 停止定位
  void _stopLocation() {
    _locationPlugin.stopLocation();
  }

  @override
  void dispose() {
    super.dispose();
    _locationListener.cancel(); // 停止定位
    _stopLocation();
    _mapController.dispose();
  }

  @override
  void didUpdateWidget(covariant YsMapPicker oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: YsButtonBack(),
        actions: [
          YsButton(
            title: '保存',
            padding: EdgeInsets.only(left: 10, right: 10),
            size: 'small',
            text: true,
            onPressed: () {
              Routers.goBackWithParams(context, {
                // 'map_location':
                // '${_mapController.mapLocation['lng']},${_mapController.mapLocation['lat']}',
                // 接收和返回数据格式一致
                'map_location': [
                  _mapController.mapLocation['lng'],
                  _mapController.mapLocation['lat']
                ],
                'map_polygon': _mapController.mapPolygon,
              });
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          widget.title ?? '更新定位',
          style: TextStyle(
            color: Colours.text_info,
            fontSize: 17.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          _mapController.renderMap(),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(10),
              child: YsButton(
                type: 'muted',
                icon: '&#xe600;',
                size: 'small',
                title: '搜索地点',
                onPressed: () {
                  _mapController.myMapController!.getMapStatus().then((value) {
                    Routers.go(context, '/search_map', {
                      'center': value!.targetGeoPt,
                      'city': _mapController.city,
                      'onChanged': (v) {
                        _mapController.updateOverlay({'map_location': v});
                      }
                    });
                  });
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 44,
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  YsTabs(
                    tabs: [
                      {'type_id': 1, 'type_name': '位置定位'},
                      {'type_id': 2, 'type_name': '占位图'},
                      {'type_id': 3, 'type_name': '大门'},
                    ],
                    size: 'mini',
                    type: TabsType.capsule,
                    onPressed: (item, i) {
                      _mode = item['type_id'];
                      setState(() {});
                    },
                  ),
                  _mode == 2 && _mapController.polylineData.length > 1
                      ? Row(
                          children: [
                            _mapController.polylineData.length > 2
                                ?
                                // 撤消
                                YsButton(
                                    text: true,
                                    icon: '&#xe645;',
                                    iconSize: 16,
                                    width: 32,
                                    height: 24,
                                    size: 'mini',
                                    onPressed: () {
                                      _mapController.removePolylineLast();
                                      setState(() {});
                                    },
                                  )
                                : Container(),
                            // 取消
                            YsButton(
                              text: true,
                              icon: '&#xe612;',
                              width: 32,
                              height: 24,
                              iconColor: Colors.red,
                              size: 'mini',
                              onPressed: () {
                                _mapController.removePolyline();
                              },
                            ),
                            _mapController.polylineData.length > 2
                                ? YsButton(
                                    text: true,
                                    icon: '&#xe6db;',
                                    iconSize: 16,
                                    width: 32,
                                    height: 24,
                                    size: 'mini',
                                    onPressed: () {
                                      _mapController.initPolygon(_mapController.polylineData);
                                      _mapController.polylineData = [];
                                      setState(() {});
                                    },
                                  )
                                : Container(),
                          ],
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Column(
              children: [
                YsButton(
                  icon: '&#xe62d;',
                  title: '切换',
                  iconPosition: 'top',
                  iconSize: 18,
                  iconColor: Color(0xff444444),
                  color: Colors.white,
                  textStyle: TextStyle(color: Color(0xff444444), fontSize: 11),
                  height: 44,
                  width: 44,
                  space: 0,
                  padding: EdgeInsets.only(top: 2),
                  onPressed: _mapController.toggleType,
                ),
                SizedBox(height: 10),
                Consumer(builder: (context, watch, _) {
                  List<double> location = watch(locationProvider).data;
                  BMFCoordinate coordinate = BMFCoordinate(location[1], location[0]);
                  return YsButton(
                    icon: '&#xe62e;',
                    title: '定位',
                    iconPosition: 'top',
                    iconSize: 18,
                    iconColor: Color(0xff444444),
                    color: Colors.white,
                    textStyle: TextStyle(color: Color(0xff444444), fontSize: 11),
                    height: 44,
                    width: 44,
                    space: 0,
                    padding: EdgeInsets.only(top: 2),
                    onPressed: () {
                      _mapController.toCenter(coordinate);
                      _mapController.initLocation(coordinate);
                    },
                  );
                }),
                SizedBox(height: 10),
                YsButton(
                  round: false,
                  icon: '&#xe601;',
                  iconColor: Color(0xff444444),
                  color: Colors.white,
                  height: 44,
                  width: 44,
                  onPressed: () {
                    if (21 != _mapController.zoom) {
                      _mapController.myMapController!.zoomIn();
                    }
                  },
                ),
                Divider(),
                YsButton(
                  round: false,
                  icon: '&#xe711;',
                  iconColor: Color(0xff444444),
                  color: Colors.white,
                  height: 44,
                  width: 44,
                  onPressed: () {
                    if (14 != _mapController.zoom) {
                      _mapController.myMapController!.zoomOut();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
