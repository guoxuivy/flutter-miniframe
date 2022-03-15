import 'package:agent/utils/field_title.dart';

List getMapStoreFilterOptions(_params) {
  List _res = [
    {
      'label': '全部库房',
      'prop': 'more',
      'items': [
        {
          'label': '展示范围',
          'prop': 'store_show_range',
          'type': 'radio',
          'data': [
            {'type_id': 1, 'type_name': '本分部'},
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
        {
          'label': '维护情况',
          'prop': 'maintain',
          'type': 'radio',
          'data': [
            {'type_id': 7, 'type_name': '7天未维护'},
            {'type_id': 15, 'type_name': '15天未维护'},
            {'type_id': 30, 'type_name': '30天未维护'},
          ]
        },
        {
          'label': '更新情况',
          'prop': 'store_update',
          'type': 'radio',
          'data': [
            {'type_id': 7, 'type_name': '7天未更新'},
            {'type_id': 15, 'type_name': '15天未更新'},
            {'type_id': 30, 'type_name': '30天未更新'},
          ]
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
        {
          'label': '标签标记',
          'prop': 'tag_use',
          'type': 'radio',
          'data': [
            {'type_id': 1, 'type_name': 'A'},
            {'type_id': 2, 'type_name': 'B'},
            {'type_id': 3, 'type_name': 'C'},
            {'type_id': 4, 'type_name': 'D'},
          ]
        },
        {
          'label': '关注点',
          'prop': 'view_tag',
          'type': 'radio',
          'data': [
            {'type_id': 1, 'type_name': '重点关注'},
          ]
        }
      ]
    },
    {
      'label': '面积',
      'prop': 'usable_area',
      'data': categories['usable_area'],
    },
    {
      'label': '价格',
      'prop': 'surface_rent',
      'data': categories['surface_rent'],
    },
    {
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
          'label': '签约状态',
          'prop': 'is_sign',
          'type': 'radio',
          'data': [
            {'type_id': 1, 'type_name': '已签约'},
            {'type_id': 0, 'type_name': '未签约'},
          ]
        },
        {
          'label': '楼层筛选',
          'prop': 'floor_requirement',
          'type': 'radio',
          'data': [
            {'type_id': 1, 'type_name': '只看一层'},
            {'type_id': 2, 'type_name': '二层及以上'},
          ]
        },
        {
          'label': '仓库类型',
          'prop': 'warehouse_application',
          'type': 'checkbox',
          'subLabel': '(多选)',
          'data': categories['warehouse_application']?.where((el) => el['type_id'] != 0).toList()
        },
        {
          'label': '建筑类型',
          'prop': 'warehouse_type',
          'type': 'checkbox',
          'subLabel': '(多选)',
          'data': categories['warehouse_type']?.where((el) => el['type_id'] != 0).toList()
        },
        {
          'label': '建筑结构',
          'prop': 'building_standard',
          'type': 'checkbox',
          'subLabel': '(多选)',
          'data': categories['building_standard']?.where((el) => el['type_id'] != 0).toList(),
        },
        {
          'prop': 'terrace_quality',
          'label': '地坪质地',
          'subLabel': '(多选)',
          'type': 'checkbox',
          'data': categories['terrace_quality']?.where((el) => el['type_id'] != 0).toList(),
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
                        : categories['fire_control']
                            ?.asMap()
                            .entries
                            .where((me) => me.key >= categories['fire_control']!.indexOf(e))
                            .map((e) => e.value['type_id'])
                            .toList()
                            .join(',')
                  })
              .toList(),
        },
        {
          'label': '卸货平台',
          'prop': 'landing_platform',
          'type': 'checkbox',
          'subLabel': '(多选)',
          'data': categories['landing_platform']
              ?.where((el) => el['type_id'] != 0)
              .toList()
              .map((e) => {
                    'type_name': e['type_name'],
                    'type_id': e['type_id'] < 2
                        ? e['type_id'].toString()
                        : categories['landing_platform']
                            ?.asMap()
                            .entries
                            .where((me) => me.key >= categories['landing_platform']!.indexOf(e))
                            .map((e) => e.value['type_id'])
                            .toList()
                            .join(',')
                  })
              .toList(),
        },
        {
          'label': '特点优势',
          'prop': 'store_merit',
          'type': 'checkbox',
          'subLabel': '(多选)',
          'data': categories['store_merit'],
        },
      ]
    },
  ];

  if (_params['business_type'] == 2) {
    _res
      ..removeAt(1)
      ..insert(1, {
        'label': '面积',
        'prop': 'saleable_area',
        'data': categories['area'],
      })
      ..removeAt(2)
      ..insert(2, {
        'label': '价格',
        'prop': 'selling_price',
        'data': categories['selling_price'],
      });
  }
  if (_params['table_name'] == 'land') {
    _res
      ..removeAt(1)
      ..insert(1, {
        'label': '面积',
        'prop': 'land_area_type',
        'data': categories['land_area'],
      })
      ..removeAt(2)
      ..insert(
          2, //价格
          _params['land_business_type'] != 2 && _params['land_business_type'] != 3
              ? {'label': '价格', 'prop': 'land_rent_type', 'data': categories['land_rent']}
              : {'label': '价格', 'prop': 'land_price_type', 'data': categories['land_price']})
      ..removeAt(3)
      ..insert(3, {
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
            'type': 'checkbox',
            'subLabel': '(多选)',
            'data': categories['land_uses']?.where((el) => el['type_id'] != 0).toList(),
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
            'type': 'checkbox',
            'subLabel': '(多选)',
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
          }
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
      });
  }
  return _res;
}

List getParkFilterOptions(_params) => [
      {
        'label': '区域',
        'prop': 'city_code',
        'type': 'area',
        'height': 210.0,
        'userFilter': true,
      },
      {
        'label': '面积',
        'prop': 'build_area',
        'data': categories['build_area'],
      },
      {
        'label': '更多',
        'prop': 'more',
        'items': [
          {
            'label': '园区类型',
            'prop': 'park_type',
            'type': 'checkbox',
            'subLabel': '(多选)',
            'data': categories['park_type'],
          },
          {
            'label': '用地性质',
            'prop': 'land_uses',
            'type': 'checkbox',
            'subLabel': '(多选)',
            'data': categories['land_uses']?.where((el) => el['type_id'] != 0).toList(),
          },
          {
            'label': '建设状态',
            'prop': 'park_status',
            'type': 'radio',
            'data': categories['park_status'],
          },
          {
            'label': '可否租售',
            'prop': 'park_tag',
            'type': 'radio',
            'data': categories['park_tag'],
          },
          {
            'label': '配套设施',
            'prop': 'other_facilities',
            'type': 'checkbox',
            'subLabel': '(多选)',
            'data': categories['other_facilities'],
          },
        ]
      }
    ];
