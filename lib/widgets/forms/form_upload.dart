import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:agent/boot.dart';
import 'package:agent/net/http_manager.dart';
import 'package:agent/net/result.dart';
import 'package:agent/res/colors.dart';
import 'package:agent/routers/routers.dart';
import 'package:agent/utils/dialogs.dart';
import 'package:agent/utils/file.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/buttons/ys_button.dart';
import 'package:agent/widgets/ys_drag.dart';
import 'package:agent/widgets/ys_icon.dart';
import 'package:agent/widgets/ys_img.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
//import 'package:wechat_camera_picker/wechat_camera_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:path_provider/path_provider.dart';

/// 图片选择组件，长按换出相机拍摄
class FormUpload extends StatefulWidget {
  const FormUpload({
    Key? key,
    this.remove,
    this.value,
    this.limit = 800,
    this.crossAxisCount = 4,
    this.placeholder,
    this.disabled = false,
    this.accept,
    this.onChanged,
    this.camera = false,
    this.remote = false,
    this.multiple = true,
    this.water = 1,
    this.fileKey = 'store',
  }) : super(key: key);

  /// 上传后的回调函数注入
  final void Function()? remove;

  final value;
  final int limit;
  final int crossAxisCount;
  final String? placeholder;
  final bool disabled;
  final List<String>? accept;
  final onChanged;
  final bool camera;
  final bool remote;
  final bool multiple;
  final int? water;
  final String? fileKey;

  @override
  FormUploadState createState() => FormUploadState();
}

class FormUploadState extends State<FormUpload> {
  List<Map<String, dynamic>> _fileList = [];
  // 上传最大文件限制
  double maxSize = 50.0 * 1024 * 1024;
  // 每块文件大小
  // int eachSize = 1 * 1024 * 1000;
  // int eachSize = 65536;
  int eachSize = 1 * 1024 * 512;
  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant FormUpload oldWidget) {
    super.didUpdateWidget(oldWidget);
    // _init();
  }

  _init() async {
    // 转换结构
    List _val = widget.multiple
        ? (widget.value ?? [])
        : (Utils.isEmpty(widget.value) ? [] : [widget.value]);

    if (Utils.isEmpty(_val)) {
      return;
    }

    if (widget.remote) {
      // 指请求获取文件的详情
      final ajax = HttpManager.instance;
      Result result = await ajax.get(
        '/agentapi/system/fileInfo',
        data: {
          'id': _val,
        },
      );
      Map _d = result.data.d;
      if (_d != null) {
        _fileList = _d.keys.map(
          (key) {
            Map _item = _d[key];
            return {
              'id': key,
              // 通过name获取文件的type, 视图可以按type显示不同的效果
              'type': FileUtils.type(_item['file_name']),
            };
          },
        ).toList();
        setState(() {});
      }
    } else {
      _fileList = _val.map(
        (key) {
          return {
            'id': key,
            'type': 'image',
          };
        },
      ).toList();
      setState(() {});
    }
  }

  List<String> get _fileListIds {
    return _fileList.map((item) => item['id'].toString()).toList();
  }

  _onChanged() {
    if (widget.onChanged != null) {
      widget.onChanged(widget.multiple ? _fileListIds : _fileListIds[0]);
    }
  }

  // 选择文件
  Future<void> _callPicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      // withData: true,
      allowedExtensions: widget.accept ?? ['jpg', 'jpeg', 'png', 'pdf', 'doc'],
    );
    if (result != null) {
      for (var item in result.paths) {
        await _upload(item);
      }
      _onChanged();
    } else {
      // User canceled the picker
    }
  }

  // Uint8List data = Uint8List(0);
  // 拍照
  _cameraPicker() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _upload(pickedFile.path);
        _onChanged();
      } else {
        print('No image selected.');
      }
    });

    /*final Size size = MediaQuery.of(context).size;
    final double scale = MediaQuery.of(context).devicePixelRatio;
    final AssetEntity _entity = await CameraPicker.pickFromCamera(
      context,
      enableRecording: true,
    );
    if (_entity != null && entity != _entity) {
      entity = _entity;
      final _file = await _entity.file;
      _upload(_file.path);

      if (widget.onChanged != null) {
        widget.onChanged(_fileList);
      }
    }*/
  }

  // 上传
  _upload(_path) async {
    var fileType = FileUtils.type(_path);
    var value;
    File _file = File(_path);
    /*if (fileType != 'image') {
      // 文件上传
      value = await _splitUpload(_file);
    } else {
      // 图片上传
      var image = await imageCompressAndGetFile(_file);
      String url = Boot.instance.config.imgBaseUrl +
          '/api/img/upload?key=${widget.fileKey}&status=1&water=${widget.water}';
      value = await HttpManager.instance.upLoad(url, image);
    }*/
    if (fileType == 'image') {
      if (FileUtils.ext(_path) == 'heic') {
        // convert HEIC to JPG
        Directory tmpDir = await getTemporaryDirectory();
        String _bname = FileUtils.baseName(_path, noExt: true);
        String _jpgPath = tmpDir.path + '/' + _bname + '.jpg';
        await HeicToJpg.convert(_path, jpgPath: _jpgPath);
        _path = _jpgPath;
        _file = File(_path);
      }
      _file = await imageCompressAndGetFile(_file);
    }
    const maxFileSize = 2 * 1024 * 1024;
    int _fsize = await _file.length();
    if (_fsize > maxFileSize) {
      value = await _splitUpload(_file);
    } else {
      String url = Boot.config.imgBaseUrl +
          '/api/img/upload?key=${widget.fileKey}&status=1&water=${widget.water}';
      value = await HttpManager.instance.upLoad(url, _file);
    }
    if (value.isOk) {
      _fileList.add({
        // 文件上传完成里返回的id
        'id': !Utils.isEmpty(value.msg) ? value.msg : value['id'].d,
        'type': fileType,
      });
      setState(() {});
    }
  }

  // 分片上传
  _splitUpload(File file) async {
    var fileSize = file.lengthSync();
    var result;
    int chunks = (fileSize / eachSize).ceil();

    var sfile = file.openSync();
    // List fileChunks = file.rea;
    int chunksTotal = 0;
    MediaType contentType = FileUtils.mediaType(file.path);
    String fileName = FileUtils.name(file.path);
    Dio dio = Dio();
    Dialogs.showLoading();
    for (var i = 0; i < chunks; i++) {
      int _len = fileSize - chunksTotal >= eachSize ? eachSize : fileSize - chunksTotal;
      // 每次取eachSize部分
      Uint8List _file = sfile.readSync(_len);
      chunksTotal += _len;
      // 使用未封装的dio
      var res = await dio.post(
        Boot.config.imgBaseUrl + '/api/file/uploadChunks',
        data: FormData.fromMap({
          'key': file.hashCode,
          // 'key': widget.fileKey,
          'water': widget.water,
          'chunked': true,
          'chunk': i,
          'chunks': chunks,
          'eachSize': eachSize,
          'fileName': fileName,
          'file_name': fileName,
          'file_size': fileSize,
          'file_id': file.hashCode,
          'type': 'video/mp4',
          'file': MultipartFile.fromBytes(
            _file,
            filename: fileName,
            contentType: contentType,
          ),
        }),
      );
      result = res;
      var _res = jsonDecode(res.toString());
      if (_res['code'] != 1) {
        break;
      }
    }
    Dialogs.easyLoadingDismiss();
    dio.close();
    await sfile.close();
    var http = HttpManager();
    // 重新包装，返回结果一致
    return http.parseResponse(result, method: 'post');
  }

  void remove(item) {
    _fileList.remove(item);
    _onChanged();
    setState(() {});
  }

  /// 图片压缩 File -> File
  Future<File> imageCompressAndGetFile(File file) async {
    if (file.lengthSync() < 200 * 1024) {
      return file;
    }
    var quality = 100;
    if (file.lengthSync() > 4 * 1024 * 1024) {
      quality = 50;
    } else if (file.lengthSync() > 2 * 1024 * 1024) {
      quality = 60;
    } else if (file.lengthSync() > 1 * 1024 * 1024) {
      quality = 70;
    } else if (file.lengthSync() > 0.5 * 1024 * 1024) {
      quality = 80;
    } else if (file.lengthSync() > 0.25 * 1024 * 1024) {
      quality = 90;
    }
    var dir = await path_provider.getTemporaryDirectory();

    String fileExt = FileUtils.ext(file.path);
    String fileType = FileUtils.type(file.path);
    var targetPath = '${dir.absolute.path}/${DateTime.now().millisecondsSinceEpoch}.$fileExt';

    var result;
    // 只处理图片格式
    if (fileType == 'image') {
      final _format = {
        'jpg': CompressFormat.jpeg,
        'jpeg': CompressFormat.jpeg,
        'png': CompressFormat.png,
        'heic': CompressFormat.heic,
        'webp': CompressFormat.webp,
      };

      result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        minWidth: 600,
        quality: quality,
        rotate: 0,
        format: _format[fileExt]!,
      );
    } else {
      result = file;
    }

    print("压缩前：${file.lengthSync() / 1024}KB");

    print("压缩后：${result.lengthSync() / 1024}KB");

    return result;
  }

  Widget _getFileItem({item, index, size}) {
    // String _src = item is Map ? item['msg'] : item;
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
        src: _src,
        width: size,
        height: size,
      ),
      onTap: () {
        Routers.go(context, '/image_preview', {
          'items': _fileListIds,
          'initialIndex': index,
          'remote': widget.remote,
        });
      },
    );
    return Stack(
      alignment: Alignment.center,
      children: [
        _item,
        // 关闭
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                ),
                color: Colors.black.withOpacity(.8),
              ),
              width: 18,
              height: 18,
              child: YsIcon(
                src: '&#xe612;',
                color: Colors.white,
                size: 9,
              ),
            ),
            onTap: () {
              remove(item);
            },
          ),
        ),
      ],
    );
  }

  // 上传按钮
  Widget _getAddButton(size) {
    if ((widget.limit == 1 && _fileList.length == 0) ||
        (widget.limit > 1 && _fileList.length < widget.limit)) {
      return YsButton(
        icon: '&#xe62a;',
        title: '上传图片',
        iconPosition: 'top',
        width: size,
        height: size,
        disabled: widget.disabled,
        iconSize: 28,
        type: 'muted',
        size: 'mini',
        plain: true,
        onPressed: () async {
          if (!widget.camera) {
            return await _callPicker();
          }
          Dialogs.bottomPop(
            title: '选择方式',
            bodyPadding: EdgeInsets.all(20),
            body: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                YsButton(
                  icon: '&#xe613;',
                  width: 80,
                  height: 80,
                  iconSize: 30,
                  iconPosition: 'top',
                  title: '文件',
                  size: 'small',
                  type: 'info',
                  text: true,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _callPicker();
                  },
                ),
                YsButton(
                  icon: '&#xe62a;',
                  width: 80,
                  height: 80,
                  iconSize: 30,
                  iconPosition: 'top',
                  title: '拍照',
                  size: 'small',
                  type: 'info',
                  text: true,
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _cameraPicker();
                  },
                ),
              ],
            ),
          );
        },
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
        YsDrag(
          data: _fileList,
          crossAxisCount: widget.crossAxisCount,
          renderItem: _getFileItem,
          append: _getAddButton,
          onChanged: (newFileList) {
            // print(_fileListIds);
            _onChanged();
          },
        ),
      ],
    );
  }
}
