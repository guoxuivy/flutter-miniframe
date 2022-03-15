import 'dart:async';

import 'package:agent/res/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnOkEvt = Future<bool> Function(String txt);

class InputDialog extends AlertDialog {
  InputDialog({required Widget contentWidget}) : super(content: contentWidget);
}

class InputDialogContent extends StatefulWidget {
  final String title;
  final String content;

  //final TextEditingController ctl;
  final String okBtnTitle;
  final String cancelBtnTitle;
  final OnOkEvt? okBtnTap;
  final VoidCallback? cancelBtnTap;
  final VoidCallback? onClose;

  InputDialogContent(
      {Key? key,
      required this.title,
      this.content = '',
      //this.ctl,
      this.okBtnTap,
      this.cancelBtnTap,
      this.okBtnTitle = '保存',
      this.cancelBtnTitle = '取消',
      this.onClose});

  @override
  State<InputDialogContent> createState() => _InputDialogState();
}

class _InputDialogState extends State<InputDialogContent> {
  late TextEditingController ctl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctl = TextEditingController();
    ctl.text = widget.content;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      height: 200,
      width: 500,
      alignment: Alignment.bottomCenter,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              widget.title,
              style: TextStyle(color: Colours.text_primary),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: TextField(
              controller: ctl,
              style: TextStyle(color: Colours.text_info),
              maxLines: 3,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colours.info)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colours.primary)),
              ),
            ),
          ),
          Container(
            height: 60,
            margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          widget.okBtnTap!(ctl.text).then((value) => ctl.text = '');
                          Navigator.maybeOf(context)!.pop();
                          if (widget.onClose != null) {
                            Future.delayed(Duration(milliseconds: 10), () {
                              widget.onClose!();
                            });
                          }
                        },
                        child: Text(widget.okBtnTitle)),
                    TextButton(
                        onPressed: () {
                          ctl.text = '';
                          widget.cancelBtnTap!();
                          Navigator.maybeOf(context)!.pop();
                          if (widget.onClose != null) {
                            Future.delayed(Duration(milliseconds: 10), () {
                              widget.onClose!();
                            });
                          }
                        },
                        child: Text(widget.cancelBtnTitle))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
