import 'package:agent/utils/field_title.dart';

mixin StoreListMixin {
  List getFilterOptions(_params) => [
        {
          'label': '全部库房',
          'prop': 'more',
          'items': [
            {
              'label': '展示范围',
              'prop': 'store_show_range',
              'type': 'radio',
              'data': [
                {'type_id': 1, 'type_name': '归属分部房源'},
                {'type_id': 2, 'type_name': '其他分部'},
              ]
            },
            {
              'label': '我的角色',
              'prop': 'store_play_role',
              'type': 'radio',
              'data': [
                {'type_id': 1, 'type_name': '推荐人'},
                {'type_id': 2, 'type_name': '合同促成人'},
                {'type_id': 3, 'type_name': '维护人'},
              ]
            },
            {'label': '维护情况', 'prop': 'maintain', 'type': 'radio', 'data': categories['maintain']},
            {
              'label': '更新情况',
              'prop': 'store_update',
              'type': 'radio',
              'data': categories['store_update']
            },
            {
              'label': '带看进度',
              'prop': 'see_num',
              'type': 'radio',
              'data': [
                {'type_id': 10, 'type_name': '未带看'},
                {'type_id': 1, 'type_name': '带看1次'},
                {'type_id': 2, 'type_name': '带看2次'},
                {'type_id': 3, 'type_name': '带看3次'},
                {'type_id': 4, 'type_name': '带看4次'},
                {'type_id': 5, 'type_name': '带看5次'},
                {'type_id': 6, 'type_name': '带看5次以上'},
              ]
            },
            {'label': '是否合作', 'prop': 'tag_use', 'type': 'radio', 'data': categories['tag_use']},
            /* {
              'label': '关注点',
              'prop': 'view_tag',
              'type': 'radio',
              'data': [
                {'type_id': 1, 'type_name': '重点关注'},
              ]
            } */
          ]
        },
        {
          'label': '区域',
          'prop': 'city_code',
          'type': 'area',
          'height': 280.0,
          'userFilter': true //只显示看可见区域
        },
        // 租金
        _params['ware_type'] == 4
            ? ({
                'label': '价格',
                'prop': 'land_rent',
                'data': categories['land_rent'],
              })
            : (_params['business_type'] == 1
                ? {
                    'label': '价格',
                    'prop': 'surface_rent',
                    'data': categories['surface_rent'],
                  }
                : {
                    'label': '价格',
                    'prop': 'selling_price',
                    'data': categories['selling_price'],
                  }),
        _params['ware_type'] == 4
            ? ({
                'label': '面积',
                'prop': 'land_area',
                'data': categories['land_area'],
              })
            : (_params['business_type'] == 1
                ? {
                    'label': '面积',
                    'prop': 'usable_area',
                    'data': categories['usable_area'],
                  }
                : {
                    'label': '面积',
                    'prop': 'saleable_area',
                    'data': categories['usable_area'],
                  }),

        _params['ware_type'] != 4
            ? {
                'label': '更多',
                'prop': 'more',
                'items': [
                  {
                    'label': '库房用途',
                    'prop': 'ware_type',
                    'type': 'radio',
                    'data': [
                      {'type_id': 1, 'type_name': '仓库'},
                      {'type_id': 2, 'type_name': '厂房'},
                    ]
                  },
                  {
                    'prop': 'merge_floor',
                    'label': '栋座筛选',
                    'data': [
                      {'type_id': 1, 'type_name': '单栋'},
                      {'type_id': 0, 'type_name': '全园区'}
                    ]
                  },
                  {
                    'label': '委托合同',
                    'prop': 'is_entrust',
                    'type': 'radio',
                    'data': [
                      {'type_id': 1, 'type_name': '有合同'},
                      {'type_id': 0, 'type_name': '无合同'},
                    ]
                  },
                  {
                    'label': '签约状态',
                    'prop': 'is_sign',
                    'type': 'radio',
                    'data': [
                      {'type_id': 1, 'type_name': '已签约'},
                      {'type_id': 0, 'type_name': '未签约'},
                    ]
                  },
                  {
                    'prop': 'floor_requirement',
                    'label': '楼层筛选',
                    'data': [
                      {'type_id': 1, 'type_name': '只限一层'},
                      {'type_id': 2, 'type_name': '二层以上'},
                    ]
                  },
                  {
                    'label': '仓库类型',
                    'subLabel': '(多选)',
                    'prop': 'warehouse_application',
                    // 'type': 'radio',
                    'type': 'checkbox',
                    'data': categories['warehouse_application']
                        ?.where((el) => el['type_id'] != 0)
                        .toList(),
                  },
                  {
                    'label': '建筑类型',
                    'subLabel': '(多选)',
                    'prop': 'warehouse_type',
                    // 'type': 'radio',
                    'type': 'checkbox',
                    'data':
                        categories['warehouse_type']?.where((el) => el['type_id'] != 0).toList(),
                  },
                  {
                    'label': '建筑结构',
                    'subLabel': '(多选)',
                    'prop': 'building_standard',
                    // 'type': 'radio',
                    'type': 'checkbox',
                    'data':
                        categories['building_standard']?.where((el) => el['type_id'] != 0).toList(),
                  },
                  {
                    'prop': 'terrace_quality',
                    'subLabel': '(多选)',
                    'label': '地坪质地',
                    // 'type': 'radio',
                    'type': 'checkbox',
                    'data':
                        categories['terrace_quality']?.where((el) => el['type_id'] != 0).toList(),
                  },
                  {
                    'label': '层高',
                    'prop': 'bottom_height',
                    'type': 'radio',
                    'data': [
                      {'type_id': '3|9999', 'type_name': '3米'},
                      {'type_id': '5|9999', 'type_name': '5米'},
                      {'type_id': '7|9999', 'type_name': '7米'},
                      {'type_id': '9|9999', 'type_name': '9米'},
                      {'type_id': '11|9999', 'type_name': '11米'},
                      {'type_id': '13|9999', 'type_name': '13米'}
                    ]
                  },
                  {
                    'label': '消防',
                    'prop': 'fire_control',
                    'type': 'radio',
                    'data': categories['fire_control']
                        ?.where((el) => el['type_id'] != 0)
                        .toList()
                        .map((e) => {
                              'type_name': e['type_name'],
                              'type_id': e['type_id'] == 0
                                  ? '0'
                                  : categories['fire_control']!
                                      .asMap()
                                      .entries
                                      .where(
                                          (me) => me.key >= categories['fire_control']!.indexOf(e))
                                      .map((e) => e.value['type_id'])
                                      .toList()
                                      .join(',')
                            })
                        .toList(),
                  },
                  {
                    'label': '卸货平台',
                    'prop': 'landing_platform',
                    'type': 'radio',
                    'data': categories['landing_platform']
                        ?.where((el) => el['type_id'] != 0)
                        .toList()
                        .map((e) => {
                              'type_name': e['type_name'],
                              'type_id': e['type_id'] < 2
                                  ? e['type_id'].toString()
                                  : categories['landing_platform']!
                                      .asMap()
                                      .entries
                                      .where((me) =>
                                          me.key >= categories['landing_platform']!.indexOf(e))
                                      .map((e) => e.value['type_id'])
                                      .toList()
                                      .join(',')
                            })
                        .toList(),
                  },
                  {
                    'prop': 'arrival_customer',
                    'label': '入驻客户要求',
                    'type': 'radio',
                    'data': categories['arrival_customer'],
                  },
                  {
                    'prop': 'service_range',
                    'label': '业主可提供服务',
                    'subLabel': '(多选)',
                    'type': 'checkbox',
                    'data': categories['service_range'],
                  },
                  {
                    'label': '特点优势',
                    'prop': 'store_merit',
                    'type': 'checkbox',
                    'subLabel': '(多选)',
                    'data': categories['store_merit'],
                  },
                  {
                    'prop': 'library_equipment',
                    'label': '库内设备',
                    'type': 'checkbox',
                    'subLabel': '(多选)',
                    'data': categories['library_equipment'],
                  },
                  {
                    'prop': 'other_facilities',
                    'label': '园区配套',
                    'type': 'checkbox',
                    'subLabel': '(多选)',
                    'data': categories['other_facilities'],
                  },
                ]
              }
            : {
                'label': '更多',
                'prop': 'more',
                'items': [
                  {
                    'label': '租售类型',
                    'prop': 'land_business_type',
                    'type': 'radio',
                    'data': categories['land_business_type']
                  },
                  {
                    'label': '土地性质',
                    'prop': 'land_uses',
                    'type': 'radio',
                    'data': categories['land_uses']
                  },
                  {
                    'label': '使用年限',
                    'prop': 'land_use_year',
                    'type': 'radio',
                    'data': categories['land_use_year']
                  },
                  {
                    'prop': 'land_merit',
                    'label': '土地优势',
                    'type': 'radio',
                    'data': categories['land_merit']
                  },
                  {
                    'prop': 'add_status',
                    'label': '发布状态',
                    'type': 'radio',
                    'data': categories['add_status']
                  },
                  /*{
            'prop': 'tag_use',
            'label': '标签标记',
            'type': 'radio',
            'data': categories['tag_use']
          },*/
                  {
                    'label': '签约状态',
                    'prop': 'is_sign',
                    'type': 'radio',
                    'data': [
                      {'type_id': 1, 'type_name': '已签约'},
                      {'type_id': 0, 'type_name': '未签约'},
                    ]
                  },
                  /*{
            'label': '更新情况',
            'prop': 'store_update',
            'type': 'radio',
            'data': categories['store_update']
          },
          {
            'label': '维护情况',
            'prop': 'maintain',
            'type': 'radio',
            'data': categories['maintain']
          }*/
                ]
              },
      ];

  List getSortOption(Map<String, dynamic> _params) {
    List d = <Map<String, dynamic>>[
      {'type_id': 'modify_date desc', 'type_name': '最近更新'},
      {'type_id': 'create_date desc', 'type_name': '最新发布'},
      {'type_id': 'usable_area desc', 'type_name': '可租面积从大到小'},
      {'type_id': 'start_usable_area asc', 'type_name': '起租面积从小到大'},
      {'type_id': 'surface_rent desc', 'type_name': '价格从高到低'},
      {'type_id': 'surface_rent asc', 'type_name': '价格从低到高'},
    ];
    if (_params.containsKey('ware_type') && _params['ware_type'] == 4) {
      //Land
      d = <Map<String, dynamic>>[
        {'type_id': 'modify_date desc', 'type_name': '最近更新'},
        {'type_id': 'land_use_year desc', 'type_name': '使用年限从大到小'},
        {'type_id': 'land_area desc', 'type_name': '面积从大到小'},
        {'type_id': 'land_area asc', 'type_name': '面积从小到大'}
      ];
      if (_params.containsKey('land_business_type') && _params['land_business_type'] == 2) {
        d.addAll(<Map<String, dynamic>>[
          {'type_id': 'land_price asc', 'type_name': '价格从低到高'},
          {'type_id': 'land_price desc', 'type_name': '价格从高到低'}
        ]);
      } else {
        d.addAll(<Map<String, dynamic>>[
          {'type_id': 'land_rent asc', 'type_name': '价格从低到高'},
          {'type_id': 'land_rent desc', 'type_name': '价格从高到低'}
        ]);
      }
    } else {
      if (_params.containsKey('business_type') && _params['business_type'] == 2) {
        d
          ..removeRange(2, 6)
          ..addAll(<Map<String, dynamic>>[
            {'type_id': 'saleable_area desc', 'type_name': '可售面积从大到小'},
            {'type_id': 'saleable_area desc', 'type_name': '可售面积从大到小'},
            {'type_id': 'start_saleable_area asc', 'type_name': '起售面积从小到大'},
            {'type_id': 'selling_price desc', 'type_name': '价格从高到低'},
            {'type_id': 'selling_price asc', 'type_name': '价格从低到高'}
          ]);
      }
    }
    return d;
  }
}
