import 'package:agent/res/colors.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/ys_form.dart';
import 'package:agent/widgets/ys_modal_form.dart';
import 'package:flutter/material.dart';

getContacts({formController, setState}) {
  List<Widget> _contacts = [];
  // print(formController.data);
  Utils.forEach(formController.data['contacts'], (contact, i) {
    FormController _contactFormController = FormController(url: '');
    _contacts.add(Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contact['name'],
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xff555555))),
              SizedBox(height: 5),
              Text(
                '${contact['post']} ${contact['phone']}',
                style: TextStyle(color: Colours.text_muted),
              ),
            ],
          ),
          YsModalForm(
              title: '删除',
              type: 'info',
              size: 'mini',
              text: true,
              controller: _contactFormController,
              formItems: [
                {
                  'label': '删除原因：',
                  'name': 'reasonRadio',
                  'type': 'radio',
                  'rules': [
                    {
                      'required': true,
                      'message': '必填',
                    },
                  ],
                  'data': [
                    {
                      'type_id': '已离职',
                      'type_name': '已离职',
                    },
                    {
                      'type_id': '已调岗',
                      'type_name': '已调岗',
                    },
                    {
                      'type_id': '联系人错误',
                      'type_name': '联系人错误',
                    },
                    {
                      'type_id': '其他原因',
                      'type_name': '其他原因',
                    },
                  ],
                  'onChanged': (val) {
                    _contactFormController.data['reason'] = val != '其他原因' ? val : '';
                  },
                },
                {
                  'name': 'reason',
                  'type': 'textarea',
                  'rules': [
                    {
                      'required': true,
                      'message': '必填',
                    },
                  ],
                },
              ],
              submitBefore: (d) {
                List _reason = formController.data['reason'] != null
                    ? [
                        formController.data['reason'],
                      ]
                    : [];
                _reason.add('删除原因：${d['reason']}');
                formController.data['reason'] = _reason.join(',');
                formController.data['contacts'].remove(contact);

                formController.validateOptions.remove('contacts.$i.phone');
                formController.validateOptions.remove('contacts.$i.name');
                formController.validateOptions.remove('contacts.$i.sex');
                setState(() {});
                BuildContext context = Routers.context();
                Navigator.pop(context);
                return false;
              })
        ],
      ),
    ));
  });
  List<Map<String, dynamic>> _options = [
    {
      'type': 'block',
      'render': () {
        return Column(children: _contacts);
      },
      'name': 'contacts',
      'rules': [
        {'required': true, 'message': '联系人必填'},
      ],
    }
  ];
  return _options;
}

renderAddContact({formController, setState, context, onChanged, isRequired = true}) {
  return () => Padding(
        padding: EdgeInsets.all(10),
        child: YsModalForm(
          icon: '&#xe635;',
          title: '新增联系人',
          modalTitle: '新增联系人',
          plain: true,
          type: 'primary',
          formItems: [
            {
              'label': '联系人手机号',
              'name': 'phone',
              'fromField': 'username',
              'rules': [
                {'required': isRequired, 'message': '手机号码必填'}
              ],
              'type': 'autocomplete',
              'renderItem': (item) {
                return Text(
                    '${item['real_name']} (${item['sex'] == 1 ? '男' : '女'}) ${item['username']}');
              },
              'onChanged': (v, item, d) {
                d.addAll({
                  'phone': item['username'] ?? v,
                  'name': item['real_name'],
                  'sex': item['sex'],
                  'post': item['post'] ?? '无',
                });
              }
            },
            {
              'label': '联系人姓名',
              'name': 'name',
              'rules': [
                {'required': isRequired, 'message': '联系人必填'}
              ],
              'type': 'input',
            },
            {
              'label': '联系人性别 ',
              'name': 'sex',
              'type': 'radio',
              'rules': [
                {'required': isRequired, 'message': '性别必填'}
              ],
              'data': [
                {'type_id': 1, 'type_name': '男'},
                {'type_id': 2, 'type_name': '女'},
              ],
            },
            {
              'label': '联系人职位',
              'name': 'post',
              'type': 'input',
            },
            {
              'label': '联系人邮箱',
              'name': 'email',
              'type': 'input',
            },
          ],
          submitBefore: (d) {
            Navigator.pop(context);
            d['name'] = d['name'] ?? '--';
            d['phone'] = d['phone'] ?? '--';
            d['post'] = d['post'] ?? '--';
            d['real_name'] = d['name'];
            d['username'] = d['phone'];
            formController.data['contacts'].add(d);
            setState(() {});
            return false;
          },
        ),
      );
}
