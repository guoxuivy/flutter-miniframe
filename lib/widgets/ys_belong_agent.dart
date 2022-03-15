import 'package:agent/widgets/forms/form_select.dart';
import 'package:flutter/material.dart';
import 'package:agent/net/http_manager.dart';

typedef OnAgentSelect = void Function(List<int?>);

class YsBelongAgent extends StatefulWidget {
  final List <Map <String, dynamic>> options;
  final bool? notNo;
  final OnAgentSelect onChange;
  final Map<String, dynamic> params;

  YsBelongAgent({
    Key? key,
    required this.options,
    this.notNo,
    required this.onChange,
    required this.params
  }):super(key:key);

  @override
  State<YsBelongAgent> createState () => _YsBelongAgentState();
}
class _YsBelongAgentState extends State<YsBelongAgent> {
  List<Map<String, dynamic>> companyList = [];
  List<Map<String, dynamic>> memberList = [];
  int? companyId ;
  int? memberId ;

  List <String> labels = ['代理商企业', '选择成员'];
  List <String> props = ['agent_enterprise', 'agent_id'];

  @override
  void initState() {
    super.initState();



    Future.delayed(Duration(milliseconds: 10), () {
      _getCompanyList();
    });
  }

  @override
  Widget build(BuildContext context) {
    [0,1].forEach((i) {
      if (widget.options.length > i) {
        if (widget.options[i].isNotEmpty) {
          if (widget.options[i].containsKey('label')) {
            labels[i] = widget.options[i]['label'];
          }
          if (widget.options[i].containsKey('prop')) {
            props[i] = widget.options[i]['prop'];
          }
        }
      }
    });
    companyId = widget.params.isNotEmpty && widget.params.containsKey(props[0]) ? widget.params[props[0]] : null;
    memberId = widget.params.isNotEmpty && widget.params.containsKey(props[1]) ? widget.params[props[1]] : null;

    return Container(
      constraints: BoxConstraints(minWidth: 50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children:[
          Container(
            constraints: BoxConstraints(minHeight: 30),
            child: FormSelect(
              placeholder: labels[0],
              data: companyList,
              value: companyId,
              onChanged: (v,_item) {
                _onCompanyChange(v);
              },
            ),
          ),

          companyId != null && companyId! > 0 ? Container(
            constraints: BoxConstraints(minHeight: 30),
            child: FormSelect(
              placeholder: labels[1],
              data:memberList,
              value: memberId,
              onChanged: (v, _item) {
                memberId = v;
                widget.onChange([companyId!,memberId!]);
              },
            )
          ): Container()


        ]
      ),
    );
  }

  void _getCompanyList(){
    Map<String, dynamic> defItem = {
      'type_id': 0,
      'type_name': '无'
    };
    companyList = (widget.notNo!=null && widget.notNo! ? <Map<String, dynamic>>[] : <Map<String, dynamic>>[defItem]);
    HttpManager().get('/agentapi/ComManager/agentCompanies?status=2&from_type=3&page_index=1&page_size=100').then((res) {
      List _companyList = res.data['list'].range().map((e) =>{'type_id':e['id'].d, 'type_name':e['name'].s}).toList();
      _companyList.forEach((el) {
        companyList.add({
          'type_id': el['type_id'],
          'type_name': el['type_name']
        });
      });
      _onCompanyChange(companyId);
    });
  }
  void _onCompanyChange(int? comId) {
      if (comId != null && comId > 0) {
        _getMemberList(comId);
      } else {
        _setState((){
          memberList = widget.notNo != null && widget.notNo! ?  <Map<String, dynamic>>[{'type_id':0, 'type_name':'无'}] : <Map<String, dynamic>>[];
        });
      }
      widget.onChange([comId]);
  }
  void _setState(f) {
    if (mounted) {
      setState(f);
    }
  }
  void _getMemberList(int comId) {
    HttpManager().get('/agentapi/ComManager/getAgentCompanyMember?page_size=50&id=$comId').then((res) {
      var _memberList = res.data['list'].range().map((e)=>{'type_id':e['id'].d, 'type_name':e['real_name'].s}).toList();
      memberList = [];
      _memberList.forEach((el) {
        memberList.add({
          'type_id': el['type_id'],
          'type_name': el['type_name']
        });
      });
      _setState(() {

      });
    });
  }
}
