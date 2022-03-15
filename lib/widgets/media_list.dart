import 'package:agent/net/http_manager.dart';
import 'package:agent/res/colors.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/utils/file.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/ys_img.dart';
import 'package:flutter/material.dart';


typedef Widget FilesRender(BuildContext context, List<Map<String, dynamic>> files);

class MediaList extends StatefulWidget {
  final List files;
  final FilesRender? render;
  final String? placeholder;
  final String size;
  MediaList({Key? key, required this.files, this.render, this.placeholder, this.size = 'small'}) : super(key: key);

  @override
  State<MediaList> createState() => _MediaListState();
}
class _MediaListState extends State<MediaList> {
  List<Map<String, dynamic>> fileList = [];
  double _size = 50;
  @override
  void initState() {
    super.initState();
    Map<String, double> sizeMap = {
      'tiny': 30,
      'mini': 50,
      'small': 75,
      'normal': 110,
      'big': 150,
      'large': 300
    };
    _size = sizeMap.containsKey(widget.size) ? sizeMap[widget.size]! : 75;
    List<String> _ids = [];
    widget.files.forEach((el) {
      if (el is String) {
        _ids.add(el);
      }
    });
    if (_ids.length > 0) {
      HttpManager.instance.get(
        '/agentapi/system/fileInfo',
        data: {
          'id': _ids
        }
      ).then((result) {
        Map _d = result.data.d;
        if (_d != null) {
          fileList = _d.keys.map(
              (key) {
              Map _item = _d[key];
              return {
                'id': key,
                'type': FileUtils.type(_item['file_name']),
              };
            },
          ).toList();
          setState(() {});
        }
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    if (widget.render != null) {
      return widget.render!(context, fileList);
    } else {
      List _fileItems = [];
      Utils.forEach(fileList, (f, index) {
        _fileItems.add(_getFileItem(f, index));
      });
      return Wrap(
        children: [
          widget.placeholder != null
            ? Container(
            margin: EdgeInsets.only(bottom: 10),
            width: double.infinity,
            child: Text(
              widget.placeholder!,
              style: TextStyle(color: Colours.muted, fontSize: 12),
            ),
          )
            : Container(),
          ..._fileItems,
        ],
      );
    }
  }

  Widget _getFileItem(item, index) {
    String _src = item['id'];
    String _type = item['type'];
    Map icons = {
      'video': 'icon_ship@2x.png',
      'audio': 'icon_yinp@2x.png',
      'pdf': 'icon_pdf@2x.png',
      'doc': 'icon_doc@2x.png',
      'other': 'icon_doc@2x.png',
    };
    if (_type == 'image') {
      _src = item['id'];
    } else {
      _src = 'assets/images/${icons[_type]}';
    }
    Widget _item = GestureDetector(
      child: YsImg(
        margin: EdgeInsets.only(right: 6, bottom: 10),
        src: _src,
        width: _size,
        height: _size,
        thumb: true,
      ),
      onTap: () {
        Routers.go(context, '/image_preview', {
          'items': fileList.map((e) => e['id']).toList(),
          'initialIndex': index,
          //'remote': widget.remote,
        });
      },
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        _item,
        // 关闭
        /*Positioned(
          right: 6,
          top: -1,
          child: YsButton(
            width: 18,
            height: 18,
            icon: '&#xe61b;',
            text: true,
            type: 'muted',
            onPressed: () {
              remove(item);
            },
          ),
        )*/
      ],
    );
  }
}


