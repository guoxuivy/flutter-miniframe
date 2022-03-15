import 'package:agent/res/colors.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:flutter/material.dart';

class YsListHeader extends StatelessWidget {
  YsListHeader({
    Key? key,
    this.params,
    this.keywords,
    this.title,
    this.trailing,
    this.onRemoveKeywords,
  }) : super(key: key);

  final Map? params;
  final List? keywords;
  final String? title;
  final Widget? trailing;
  final onRemoveKeywords;

  @override
  Widget build(BuildContext context) {
    // print(params);
    String keyWords = Utils.pickerMapToList(params, keywords!).join(',');
    if (keyWords == '' && title == null) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.only(left: 15, top: 10, right: 15, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          keyWords != ''
              ? RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 15, color: Colours.info),
                    children: [
                      TextSpan(text: '有关'),
                      WidgetSpan(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 220,
                          ),
                          // color: Colors.red,
                          child: Text(
                            keyWords,
                            style: TextStyle(fontSize: 15, color: Colors.red),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      TextSpan(text: '的信息'),
                      WidgetSpan(
                        child: YsButton(
                          width: 20,
                          height: 20,
                          text: true,
                          type: 'muted',
                          icon: '&#xe61b;',
                          iconSize: 12,
                          onPressed: () {
                            if (onRemoveKeywords != null) {
                              onRemoveKeywords();
                            }
                          },
                        ),
                      )
                    ],
                  ),
                )
              : Text(
                  title!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
          trailing ?? Container(),
        ],
      ),
    );
  }
}
