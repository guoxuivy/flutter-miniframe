import 'package:agent/res/colors.dart';
import 'package:flutter/material.dart';

Map<String, List<Map<String, dynamic>>?> categories = {
  'demand_status': [
    {'type_id': 1, 'type_name': '求租中'},
    {'type_id': 2, 'type_name': '求购中'},
    {'type_id': 3, 'type_name': '已成交'},
    {'type_id': 4, 'type_name': '已过期'},
    {'type_id': 6, 'type_name': '其他渠道成交'},
    {'type_id': 7, 'type_name': '已下架'},
    {'type_id': 8, 'type_name': '项目取消'},
  ],
  'deposit_demand': [
    {'type_id': 0, 'type_name': '自管'},
    {'type_id': 1, 'type_name': '全托管'},
    {'type_id': 2, 'type_name': '仓储代管'},
    {'type_id': 3, 'type_name': '配送代管'},
  ],
  'warehouse_application':
      null /*[
    {'type_id': 1, 'type_name': '普通仓'},
    {'type_id': 2, 'type_name': '恒温仓'},
    {'type_id': 3, 'type_name': '冷藏仓'},
    {'type_id': 4, 'type_name': '冷冻仓'},
    {'type_id': 6, 'type_name': '露天堆场'},
    {'type_id': 7, 'type_name': '有棚堆场'},
    {'type_id': 8, 'type_name': '危化品库'},
    {'type_id': 9, 'type_name': '医药库'},
    {'type_id': 5, 'type_name': '多温仓'},
    {'type_id': 10, 'type_name': '其他'},
  ]*/
  ,
  'cold_ware_type': null,
  'warehouse_type':
      null /*[
    {'type_id': 7, 'type_name': '坡道库'},
    {'type_id': 3, 'type_name': '高台库'},
    {'type_id': 6, 'type_name': '立体库'},
    {'type_id': 1, 'type_name': '平库'},
    {'type_id': 4, 'type_name': '楼库'},
    {'type_id': 8, 'type_name': '气体库'},
    {'type_id': 5, 'type_name': '地下库'},
    {'type_id': 0, 'type_name': '不限'},
    {'type_id': 9, 'type_name': '其他库型'},
    {'type_id': 2, 'type_name': '高标库'},
  ]*/
  ,
  'building_type': [
    {'type_id': 0, 'type_name': '不限'},
    {'type_id': 1, 'type_name': '只限一层'},
    {'type_id': 2, 'type_name': '二层以上'},
  ],
  'fire_control':
      null /*[
    {'type_id': 1, 'type_name': '戊类'},
    {'type_id': 2, 'type_name': '丁类'},
    {'type_id': 3, 'type_name': '丙二'},
    {'type_id': 4, 'type_name': '乙类'},
    {'type_id': 5, 'type_name': '甲类'},
    {'type_id': 8, 'type_name': '丙一'},
    {'type_id': 7, 'type_name': '无'},
    {'type_id': 0, 'type_name': '不限'},
  ]*/
  ,
  'landing_platform':
      null /*[
    {'type_id': 1, 'type_name': '无月台'},
    {'type_id': 2, 'type_name': '单面月台'},
    {'type_id': 3, 'type_name': '双面月台'},
    {'type_id': 4, 'type_name': '三面月台'},
    {'type_id': 0, 'type_name': '不限'},
    {'type_id': 5, 'type_name': '四面月台'},
  ]*/
  ,
  'terrace_quality':
      null /*[
    {'type_id': 1, 'type_name': '混凝土'},
    {'type_id': 2, 'type_name': '地砖'},
    {'type_id': 3, 'type_name': '金刚砂'},
    {'type_id': 4, 'type_name': '防尘'},
    {'type_id': 5, 'type_name': '防潮'},
    {'type_id': 6, 'type_name': '防静电'},
    {'type_id': 7, 'type_name': '环氧'},
    {'type_id': 0, 'type_name': '不限'},
    {'type_id': 8, 'type_name': '水磨石'},
    {'type_id': 9, 'type_name': '地漆'},
  ]*/
  ,
  'store_merit':
      null /*[
    {'type_id': 12, 'type_name': '空地'},
    {'type_id': 11, 'type_name': '食堂'},
    {'type_id': 10, 'type_name': '宿舍'},
    {'type_id': 9, 'type_name': '办公室'},
    {'type_id': 1, 'type_name': '独门独院'},
    {'type_id': 2, 'type_name': '可改造'},
    {'type_id': 3, 'type_name': '可轻加工'},
    {'type_id': 4, 'type_name': '有产权证'},
    {'type_id': 5, 'type_name': '有土地证'},
    {'type_id': 6, 'type_name': '有排污证'},
  ]*/
  ,
  'truck_type': [
    {'type_id': 1, 'type_name': '4.2米'},
    {'type_id': 2, 'type_name': '7.2米'},
    {'type_id': 3, 'type_name': '9.6米'},
    {'type_id': 4, 'type_name': '13米'},
    {'type_id': 5, 'type_name': '17.5米'},
    {'type_id': 6, 'type_name': '大于17.5米'},
    {'type_id': 0, 'type_name': '小于4.2米'},
  ],
  'is_light_machining': [
    {'type_id': 1, 'type_name': '需要'},
    {'type_id': 0, 'type_name': '不需要'},
  ],
  'surface_tax_property': [
    {'type_id': 1, 'type_name': '含税含物业'},
    {'type_id': 2, 'type_name': '含税'},
    {'type_id': 3, 'type_name': '含物业'},
    {'type_id': 4, 'type_name': '无'},
  ],
  'warehouse_use_for': [
    {'type_id': 9, 'type_name': '销售周边仓'},
    {'type_id': 8, 'type_name': '生产周边仓'},
    {'type_id': 7, 'type_name': '区域中心仓'},
    {'type_id': 6, 'type_name': '市内配送仓'},
    {'type_id': 5, 'type_name': '快递快运网点仓'},
    {'type_id': 4, 'type_name': '快递快运转运中心'},
    {'type_id': 3, 'type_name': '电商仓'},
    {'type_id': 2, 'type_name': '物流专线仓'},
    {'type_id': 1, 'type_name': '长期存储仓'},
  ],
  'acceptable_pollution':
      null /*[
    {'type_id': 1, 'type_name': '无污染'},
    {'type_id': 2, 'type_name': '粉尘污染'},
    {'type_id': 3, 'type_name': '空气污染'},
    {'type_id': 4, 'type_name': '噪音污染'},
    {'type_id': 5, 'type_name': '排水污染'},
    {'type_id': 6, 'type_name': '化学污染'},
    {'type_id': 7, 'type_name': '热污染'},
    {'type_id': 8, 'type_name': '电磁污染'},
    {'type_id': 9, 'type_name': '危险废物污染'},
  ]*/
  ,
  'building_standard':
      null /*[
    {'type_id': 1, 'type_name': '砖瓦混合'},
    {'type_id': 2, 'type_name': '轻钢结构'},
    {'type_id': 3, 'type_name': '重钢结构'},
    {'type_id': 0, 'type_name': '不限'},
    {'type_id': 4, 'type_name': '钢混结构'},
  ]*/
  ,
  'land_uses':
      null /*[
    {'type_id': 4, 'type_name': '住宅用地'},
    {'type_id': 3, 'type_name': '商业用地'},
    {'type_id': 2, 'type_name': '工交仓用地'},
    {'type_id': 1, 'type_name': '物流仓储用地'},
    {'type_id': 10, 'type_name': '工业用地'},
    {'type_id': 9, 'type_name': '其它'},
    {'type_id': 5, 'type_name': '集体用地'},
    {'type_id': 6, 'type_name': '农业用地'},
    {'type_id': 0, 'type_name': '不限'},
  ]*/
  ,
  'other_system': null, // 配套设施
  'floor_requirement': [
    {'type_id': 0, 'type_name': '不限'},
    {'type_id': 1, 'type_name': '只限一层'},
    {'type_id': 2, 'type_name': '二层以上'},
  ],
  'park_type': [
    {'type_id': 3, 'type_name': '保税园区'},
    {'type_id': 2, 'type_name': '产业园'},
    {'type_id': 1, 'type_name': '物流园区'},
    {'type_id': 0, 'type_name': '工业园区'},
    {'type_id': 9, 'type_name': '其它'},
  ],
  'park_tag': [
    {'type_id': 1, 'type_name': '可租售'},
    {'type_id': 2, 'type_name': '自用'},
    {'type_id': 3, 'type_name': '不可租售'},
  ],
  'security_system':
      null /* [
    {'type_id': 1, 'type_name': '警钟'},
    {'type_id': 2, 'type_name': '连线报警'},
    {'type_id': 3, 'type_name': '保安'},
    {'type_id': 4, 'type_name': '视频监控'},
    {'type_id': 5, 'type_name': '通水电'},
  ]*/
  ,
  'other_facilities':
      null /*[
    {'type_id': 1, 'type_name': '食堂'},
    {'type_id': 2, 'type_name': '宿舍'},
    {'type_id': 3, 'type_name': '独立办公楼'},
    {'type_id': 4, 'type_name': '独立停车场'},
    {'type_id': 7, 'type_name': '医务室'},
    {'type_id': 8, 'type_name': '警务室'},
    {'type_id': 6, 'type_name': '库内办公室'},
    {'type_id': 5, 'type_name': '夹层办公室'},
    {'type_id': 9, 'type_name': '小卖部'},
    {'type_id': 10, 'type_name': '空地'},
  ]*/
  ,
  'landing_type': [
    {'type_id': 1, 'type_name': '内嵌式'},
    {'type_id': 2, 'type_name': '外置式'},
  ],
  'build_area': [
    {'type_id': '0|1000', 'type_name': '1000㎡以下'},
    {'type_id': '1001|5000', 'type_name': '1001㎡-5000㎡'},
    {'type_id': '5001|10000', 'type_name': '5000㎡-10000㎡'},
    {'type_id': '10001|20000', 'type_name': '10001㎡-20000㎡'},
    {'type_id': '20001|50000', 'type_name': '20001㎡-50000㎡'},
    {'type_id': '50001|99999999', 'type_name': '50001㎡以上'}
  ],
  'origin_type': [
    {'type_id': 1, 'type_name': '私客来源'},
    {'type_id': 2, 'type_name': '线上客户'},
    {'type_id': 3, 'type_name': '合作客户'},
    {'type_id': 4, 'type_name': '共享池客户'},
  ],
  // 通用面积
  'area': [
    {'type_id': '0|1', 'type_name': '1㎡'},
    {'type_id': '1|100', 'type_name': '100㎡'},
    {'type_id': '100|200', 'type_name': '200㎡'},
    {'type_id': '200|500', 'type_name': '500㎡'},
    {'type_id': '500|1000', 'type_name': '1000㎡'},
    {'type_id': '1000|1500', 'type_name': '1500㎡'},
    {'type_id': '1500|2000', 'type_name': '2000㎡'},
    {'type_id': '2000|5000', 'type_name': '5000㎡'},
    {'type_id': '5000|7000', 'type_name': '7000㎡'},
    {'type_id': '7000|1000000', 'type_name': '10000㎡'},
  ],

  // 土地面积
  'land_area': [
    {'type_id': '0|10', 'type_name': '10亩以下'},
    {'type_id': '10|100', 'type_name': '10-100亩'},
    {'type_id': '100|500', 'type_name': '100-500亩'},
    {'type_id': '500|1000', 'type_name': '500-1000亩'},
    {'type_id': '1000|5000', 'type_name': '1000-5000亩'},
    {'type_id': '5000|1000000', 'type_name': '5000亩以上'},
  ],
  'land_rent': [
    {'type_id': '0|150', 'type_name': '150元/亩/年以下'},
    {'type_id': '151|200', 'type_name': '151-200元/亩/年'},
    {'type_id': '201|300', 'type_name': '201-300元/亩/年'},
    {'type_id': '301|500', 'type_name': '301-500元/亩/年'},
    {'type_id': '500|1000000', 'type_name': '500元/亩/年以上'},
  ],
  'land_price': [
    {'type_id': '0|10', 'type_name': '10元/亩'},
    {'type_id': '10|30', 'type_name': '10-300元/亩'},
    {'type_id': '31|50', 'type_name': '31-50元/亩'},
    {'type_id': '50|100000', 'type_name': '>50元/亩'}
  ],

  'usable_area': [
    {'type_id': '1|99999999', 'type_name': '1㎡以上'},
    {'type_id': '100|99999999', 'type_name': '100㎡以上'},
    {'type_id': '200|99999999', 'type_name': '200㎡以上'},
    {'type_id': '500|99999999', 'type_name': '500㎡以上'},
    {'type_id': '1000|99999999', 'type_name': '1000㎡以上'},
    {'type_id': '1500|99999999', 'type_name': '1500㎡以上'},
    {'type_id': '2000|99999999', 'type_name': '2000㎡以上'},
    {'type_id': '5000|99999999', 'type_name': '5000㎡以上'},
    {'type_id': '7000|99999999', 'type_name': '7000㎡以上'},
    {'type_id': '9000|99999999', 'type_name': '9000㎡以上'},
    {'type_id': '10000|99999999', 'type_name': '10000㎡以上'}
  ],
  'surface_rent': [
    {'type_id': '0|10', 'type_name': '10元/㎡/月'},
    {'type_id': '0|15', 'type_name': '15元/㎡/月'},
    {'type_id': '0|20', 'type_name': '20元/㎡/月'},
    {'type_id': '0|25', 'type_name': '25元/㎡/月'},
    {'type_id': '0|30', 'type_name': '30元/㎡/月'},
    {'type_id': '0|35', 'type_name': '35元/㎡/月'},
    // {'type_id': '0|40', 'type_name': '40元/㎡/月'},
  ],
  'selling_price': [
    {'type_id': '0|1000', 'type_name': '≤1000元/㎡'},
    {'type_id': '1001|2000', 'type_name': '1001-2000元/㎡'},
    {'type_id': '2001|5000', 'type_name': '2001-5000元/㎡'},
    {'type_id': '5001|10000', 'type_name': '5001-10000元/㎡'},
    {'type_id': '10001|99999999999', 'type_name': '≥10001元/㎡'},
  ],
  'ware_type': [
    {'type_id': 1, 'type_name': '仓库'},
    {'type_id': 2, 'type_name': '厂房'},
    {'type_id': 3, 'type_name': '仓库／厂房'},
    {'type_id': 4, 'type_name': '土地'},
  ],
  'ware_type_ex': [
    {'type_id': 1, 'type_name': '仓库/仓储'},
    {'type_id': 2, 'type_name': '厂房/生产'},
  ],
  'business_type': [
    {'type_id': 1, 'type_name': '出租'},
    {'type_id': 2, 'type_name': '出售'},
  ],
  // 租租方式
  'business_way': [
    {'type_id': 1, 'type_name': '可分租'},
    {'type_id': 2, 'type_name': '整体出租'},
  ],
  // 出售方式
  'business_sell': [
    {'type_id': 1, 'type_name': '可分售'},
    {'type_id': 2, 'type_name': '整体出售'},
  ],
  'surface_rent_currency': [
    {'type_name': '元/㎡/月', 'type_id': 1},
    {'type_name': '元/㎡/天', 'type_id': 2},
  ],
  'payment_way': [
    {'type_id': 1, 'type_name': '押一付三'},
    {'type_id': 2, 'type_name': '押二付六'},
    {'type_id': 3, 'type_name': '年付'},
  ],
  // 发票开具
  'invoice': [
    {'type_id': 1, 'type_name': '增值税专用'},
    {'type_id': 2, 'type_name': '增值税普通纸质'},
    {'type_id': 3, 'type_name': '定额发票'},
    {'type_id': 4, 'type_name': '无发票'},
  ],
  'surface_rent_unit': [
    {'type_name': '元/平米/月（含税含物业）', 'type_id': 1},
    {'type_name': '元/平米/天（含税含物业）', 'type_id': 2},
  ],
  'selling_tax_property': [
    {'type_id': 1, 'type_name': '不含税'},
    {'type_id': 2, 'type_name': '含税'},
  ],

  'arrival_customer': null,
  'service_range': null,
  'library_equipment': null,
  'industry_for': null,
  // '园区相关  start ',
  //园区标记
  'single': [
    {'type_id': 0, 'type_name': '标准园区'},
    {'type_id': 1, 'type_name': '独栋库房'},
  ],
  // 园区状态
  'park_status': [
    {'type_id': 0, 'type_name': '在建'},
    {'type_id': 1, 'type_name': '建成'},
    {'type_id': 2, 'type_name': '未开工'},
  ],
  // 保税仓
  'bonded_warehouse': [
    {'type_id': 2, 'type_name': '非保税仓'},
    {'type_id': 1, 'type_name': '保税仓'}
  ],
  // '园区相关  end ',

  //land
  'land_business_type': [
    {'type_id': 1, 'type_name': '出租'},
    {'type_id': 2, 'type_name': '转让'},
  ],
  'land_rent_currency': [
    {'type_name': '元/亩/月', 'type_id': 1},
    {'type_name': '元/亩/年', 'type_id': 2},
    {'type_name': '元/㎡/月', 'type_id': 3},
    {'type_name': '元/㎡/年', 'type_id': 4},
  ],
  'land_use_year': [
    {'type_id': '0|10', 'type_name': '10年以下'},
    {'type_id': '11|20', 'type_name': '11-20年'},
    {'type_id': '21|50', 'type_name': '21-50年'},
    {'type_id': '50|10000', 'type_name': '50年以上'},
  ],
  'land_merit': [
    {'type_id': 1, 'type_name': '面积大'},
    {'type_id': 2, 'type_name': '有土地证'},
    {'type_id': 3, 'type_name': '权属清晰'},
    {'type_id': 4, 'type_name': '交易快捷'},
    {'type_id': 5, 'type_name': '地段好'},
  ],

  'store_update': [
    {'type_id': 7, 'type_name': '7天未更新'},
    {'type_id': 15, 'type_name': '15天未更新'},
    {'type_id': 30, 'type_name': '30天未更新'},
  ],
  'maintain': [
    {'type_id': 7, 'type_name': '7天未维护'},
    {'type_id': 15, 'type_name': '15天未维护'},
    {'type_id': 30, 'type_name': '30天未维护'}
  ],
  'tag_use': [
    {'type_id': 1, 'type_name': '可合作'},
    // {'type_id': 2, 'type_name': 'B'},
    // {'type_id': 3, 'type_name': 'C'},
    {'type_id': 4, 'type_name': '不可合作'},
  ],
  'add_status': [
    {'type_name': '存草稿', 'type_id': 0},
    {'type_name': '已发布', 'type_id': 1},
    {'type_name': '已下架', 'type_id': 3},
  ],
  'company_relation': [
    {'type_id': 1, 'type_name': '联系企业'},
    {'type_id': 2, 'type_name': '母子公司'},
    {'type_id': 3, 'type_name': '控股公司'},
    {'type_id': 4, 'type_name': '同一法人'},
    {'type_id': 5, 'type_name': '同一集团下'}
  ],
  'is_canopy': [
    {'type_name': '有', 'type_id': 1},
    {'type_name': '无', 'type_id': 0},
  ],
  'contract_status': [
    {'type_id': 0, 'type_name': '待审核'},
    {'type_id': 1, 'type_name': '生效中'},
    {'type_id': 2, 'type_name': '已终止'},
    {'type_id': 4, 'type_name': '已作废'}
  ],
  'is_property': [
    {'type_id': 1, 'type_name': '业主自营'},
    {'type_id': 2, 'type_name': '第三方承包'},
    {'type_id': 3, 'type_name': '无'}
  ],
  'floor_equipment': null,
  'identity': [
    {'type_name': '业主', 'type_id': 1},
    {'type_name': '租户', 'type_id': 2},
    {'type_name': '身份不明', 'type_id': 3}
  ],
  'user_origin': [
    {'type_id': 1, 'type_name': '后台'},
    {'type_id': 2, 'type_name': '仓小二PC端'},
    {'type_id': 3, 'type_name': '仓小二WAP端'},
    {'type_id': 4, 'type_name': '仓小二APP[Android]'},
    {'type_id': 5, 'type_name': '仓小二APP[IOS]'},
    {'type_id': 6, 'type_name': '选址顾问PC端'},
    {'type_id': 7, 'type_name': '选址顾问WAP端'},
    {'type_id': 9, 'type_name': '代理商'},
    {'type_id': 10, 'type_name': '代理商App'}
  ],
  'bill_type': [
    {'type_id': 1, 'type_name': '400漏接客户'},
    {'type_id': 2, 'type_name': '客户租期将至'},
    {'type_id': 3, 'type_name': '委托期限将至'},
    {'type_id': 4, 'type_name': '平台派单'}
  ],
  'is_audited': [
    {'type_id': 0, 'type_name': '未核实'},
    {'type_id': 1, 'type_name': '核实失败'},
    {'type_id': 2, 'type_name': '已电话核实'},
    {'type_id': 3, 'type_name': '已现场核实'}
  ],
  'take_type': [
    {'type_id': 1, 'type_name': '快递'},
    {'type_id': 2, 'type_name': '自取'},
    {'type_id': 4, 'type_name': '无需寄送'}
  ],
  'contract_type': [
    {'type_id': 1, 'type_name': '委托招商'},
    {'type_id': 2, 'type_name': '委托选址'},
    /*{
            'type_id': 3,
            'type_name': '其他'
        }*/
    {'type_id': 13, 'type_name': '佣金确认书'},
    {'type_id': 4, 'type_name': '带看确认书'},
  ],
  'contract_format_type': [
    {'type_id': 1, 'type_name': '制式合同'},
    {'type_id': 2, 'type_name': '非制式合同'},
  ],
  'stamp_status': [
    {'type_id': 1, 'type_name': '已盖章', 'color': Colours.warning},
    {'type_id': 0, 'type_name': '未盖章', 'color': Colours.primary}
  ],
  'deliver_state': [
    {'type_id': 1, 'type_name': '已自取'},
    {'type_id': 2, 'type_name': '已快递'},
    {'type_id': 3, 'type_name': '已完结'},
  ],
  'doc_state': [
    {'type_id': 1, 'type_name': '已入档', 'color': Colours.primary},
    {'type_id': 2, 'type_name': '未入档', 'color': Colours.danger}
  ],
  'receive_company': [
    {'type_id': '芜湖仓小二企业管理咨询有限公司', 'type_name': '芜湖仓小二企业管理咨询有限公司'},
    {'type_id': '湖北云商云仓网络有限公司', 'type_name': '湖北云商云仓网络有限公司'},
    {'type_id': '重庆仓四号企业管理咨询有限公司', 'type_name': '重庆仓四号企业管理咨询有限公司'},
    {'type_id': '武汉仓二号企业管理咨询有限公司', 'type_name': '武汉仓二号企业管理咨询有限公司'},
    {'type_id': '芜湖仓掌柜网络科技有限公司', 'type_name': '芜湖仓掌柜网络科技有限公司'},
  ],
  'invoice_status': [
    {'type_id': 1, 'type_name': '待开票', 'color': Colours.primary},
    {'type_id': 2, 'type_name': '审核通过', 'color': Colours.warning},
    {'type_id': 3, 'type_name': '已开票', 'color': Colours.success},
    {'type_id': 4, 'type_name': '审核失败', 'color': Colours.danger},
  ],
  'publish_status': [
    {'type_id': 1, 'type_name': '草稿', 'color': Colours.info},
    //{'type_id': 2, 'type_name': '等待发布'},
    {'type_id': 3, 'type_name': '已发布', 'color': Colours.primary},
    {'type_id': 4, 'type_name': '已删除', 'color': Colours.danger},
    {'type_id': 5, 'type_name': '已下架', 'color': Colours.primary},
    {'type_id': 6, 'type_name': '核实中', 'color': Colours.warning},
    {'type_id': 7, 'type_name': '核实失败', 'color': Colours.danger},
  ],
  'land_area_currency': [
    {'type_name': '亩', 'type_id': 1},
    {'type_name': '平米', 'type_id': 2},
  ],
  'land_other_system': [
    {'type_id': 1, 'type_name': '可改造 '},
    {'type_id': 2, 'type_name': '地面硬化 '},
    {'type_id': 3, 'type_name': '有土地证 '},
    {'type_id': 4, 'type_name': '水电网 '},
    {'type_id': 5, 'type_name': '消防设施 '},
  ],
  'park_identity': [
    {
      'type_id': 1,
      'type_name': '业主',
    },
    {
      'type_id': 2,
      'type_name': '普通租户',
    },
    {
      'type_id': 3,
      'type_name': '二房东租户',
    },
  ],
  'sub_type': [
    {
      'type_id': 7,
      'type_name': '发布库房',
    },
    {
      'type_id': 8,
      'type_name': '修改库房',
    },
    {
      'type_id': 1,
      'type_name': '修改基本信息',
    },
    {
      'type_id': 4,
      'type_name': '修改租售信息',
    },
    {
      'type_id': 2,
      'type_name': '修改联系方式',
    },
  ],
};

fieldTitle({List? data, required value, prop, sep = ',', isArray = false, render}) {
  List _data = data ?? [];
  List values = [];
  List titles = [];
  List _activeItems = [];
  if (_data.length == 0) {
    _data = categories[prop] ?? [];
  }
  if (value is List) {
    values = value;
  } else if (value != null) {
    values = [value];
  }

  if (_data.length > 0) {
    values.forEach((v) {
      Map _item =
          _data.firstWhere((item) => item['type_id'] == v, orElse: () => <String, Object>{});
      if (_item.isNotEmpty) {
        titles.add(_item['type_name']);
        _activeItems.add(_item);
      }
    });
  } else {
    titles = values;
  }

  if (render != null) {
    var res;
    if (_activeItems.length == 1) {
      res = _activeItems[0];
    } else if (_activeItems.length > 1) {
      // res = _activeItems;
      res = {'type_name': titles.join(sep)};
    }
    if (res == null) {
      return Container(
        child: Text(
          '--',
          style: TextStyle(color: Colours.muted, fontSize: 13),
        ),
      );
    }
    return render(res);
  }
  if (isArray) {
    return titles;
  }
  return titles.length > 0 ? titles.join(sep) : '--';
}
