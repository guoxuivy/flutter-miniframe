import 'package:agent/net/result.dart';
import 'package:agent/widgets/ys_modal_form.dart';
import 'package:flutter/material.dart';
import 'package:agent/provider/user.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YsButtonMessage extends StatelessWidget {
  final VoidCallback submitted;
  final RData data;

  const YsButtonMessage({
    Key? key,
    required this.submitted,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = context.read(userProvider).current;
    if (data['follower_enterprise'].d == user.enterpriseId) {
      return YsModalForm(
        size: 'small',
        height: 36,
        title: data['state'].d == 0 ? '立即处理' : '修改状态',
        url: '/agentapi/intent/update',
        params: {
          'id': data['id'].d,
          'state': data['state'].d,
          'dealResult': data['state'].d == 0 ? '' : data['deal_remark'].d,
        },
        formItems: [
          {
            'label': '选择状态：',
            'type': 'radio',
            'name': 'state',
            'rules': [
              {'required': true, 'message': '状态必填'}
            ],
            'data': [
              {'type_id': 2, 'type_name': '已联系'},
              {'type_id': 3, 'type_name': '无法联系'},
            ]
          },
          {
            'label': '处理结果：',
            'type': 'textarea',
            'placeholder': '请拒绝原因',
            'name': 'dealResult',
            'rules': [
              {'required': true, 'message': '处理结果必填'}
            ]
          },
        ],
        submitted: (res) => submitted(),
      );
    }
    return Container();
  }
}
