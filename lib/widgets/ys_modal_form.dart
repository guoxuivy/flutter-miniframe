import 'package:agent/utils/dialogs.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:agent/widgets/ys_form.dart';
import 'package:flutter/material.dart';

class YsModalForm extends StatefulWidget {
  YsModalForm({
    Key? key,
    this.title,
    this.modalTitle,
    this.body,
    this.type,
    this.size,
    this.icon,
    this.textStyle,
    this.plain,
    this.text,
    this.disabled,
    this.updateState = false,
    this.height,
    this.width,
    this.padding,
    this.iconSize,
    this.url = '',
    this.params,
    this.submitBefore,
    this.submitted,
    this.renderButton,
    required this.formItems,
    this.controller,
  }) : super(key: key);

  final String? title;
  final Widget? body;
  final String? modalTitle;
  final String? type;
  final String? size;
  final String? icon;
  final textStyle;
  final bool? plain;
  final bool? text;
  final bool? disabled;
  final bool? updateState;
  final double? height;
  final double? width;
  final EdgeInsets? padding;
  final double? iconSize;
  final String url;
  final params;
  final submitBefore;
  final submitted;
  // button常用属性直接设置，完整需求请直接使用renderButton
  final Function? renderButton;
  final List<Map<String, dynamic>> formItems;
  final FormController? controller;

  @override
  State<StatefulWidget> createState() {
    return YsModalFormState();
  }
}

class YsModalFormState extends State<YsModalForm> {
  FormController _controller = FormController(url: '');
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? _controller;
    _controller.setOption(
      url: widget.url,
      data: widget.params,
      submitBefore: widget.submitBefore,
      submitted: (res) {
        Navigator.pop(context);
        if (widget.submitted != null) {
          widget.submitted(res);
        }
      },
    );
  }

  Widget renderButton() {
    return YsButton(
      title: widget.title ?? '',
      padding: widget.padding ?? EdgeInsets.only(left: 15, right: 15),
      type: widget.type ?? 'primary',
      size: widget.size ?? 'medium',
      plain: widget.plain ?? false,
      text: widget.text ?? false,
      disabled: widget.disabled ?? false,
      height: widget.height,
      width: widget.width ?? 0,
      icon: widget.icon,
      iconSize: widget.iconSize ?? 14,
      textStyle: widget.textStyle,
      onPressed: showModal,
    );
  }

  /* @override
  void didUpdateWidget(covariant YsModalForm oldWidget) {
    // 父节点调用setState方法后触发
    super.didUpdateWidget(oldWidget);
  } */

  showModal() {
    _controller.setOption(
      data: widget.params,
    );

    Dialogs.bottomPop(
      updateState: true,
      title: widget.modalTitle != null ? widget.modalTitle : widget.title,
      body: (setDialogState) {
        return YsForm(
          // 需要更新弹窗的视图
          setDialogState: widget.updateState! ? setDialogState : null,
          controller: _controller,
          formItems: widget.formItems,
        );
      },
      footer: () {
        return Padding(
          padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 15),
          child: YsButton(
            title: '确定',
            type: 'primary',
            onPressed: () {
              _controller.submit();
              // Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.renderButton != null) {
      return widget.renderButton!(showModal);
    }
    return renderButton();
  }
}
