import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

typedef CacheRender = Widget Function({
  double sumfileSize,
  int status,
  double lessFileSize,
  //String formatedSumSize,
  //String formatedlessSize,
  SizeFormate formator,
  //VoidCallback exec
  void Function(Function) exec
});
typedef FileSizeCallback = void Function(double size);
typedef  String SizeFormate(double size);

class CacheManager extends StatefulWidget {
  final CacheRender render;
  CacheManager({Key? key, required this.render}) : super(key: key);
  @override
  State<CacheManager> createState() => CacheManagerState();
}
const StatusInit = 0;
const StatusCalcalating = 1;
const StatusCalcalated = 2;
const StatusFlushing = 3;
const StatusFlushed = 4;
class CacheManagerState extends State<CacheManager> {
  int status = 0;
  double sumFileSize = 0;
  double lessFileSize = 0;
  List<Directory> _directories = [];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      _directories = await getFolders();
      sumFileSize = await  getAllSize();
      setState(() {
        status = StatusCalcalated;
      });

    });
    Timer(Duration(milliseconds: 200), () {
      if ([StatusCalcalating, StatusFlushing].contains(status)) {
        setState(() {});
      }
    });
  }
  Future<double> getFileSize(FileSystemEntity file) async {
    double ret = 0;
    if (file is File) {
      int len = await file.length();
      double _l = double.parse(len.toString());
      ret += _l;
    }
    if (file is Directory) {
      await Future.forEach(file.listSync(), (FileSystemEntity f) async {
          ret += await getFileSize(f);
      });

      //print('getFileSize Folder=> ${file.path} : ${formatSize(ret)}');
    }

    return ret;
  }

  Future<List<Directory>> getFolders() async{
    List<Directory> folders = [];
    Directory tmpDir = await getTemporaryDirectory();
    folders.add(tmpDir);
    Directory appDir = await getApplicationSupportDirectory();
    folders.add(appDir);
    Directory docDir = await getApplicationDocumentsDirectory();
    folders.add(docDir);
    if (Platform.isIOS) {
      folders.add(await getLibraryDirectory());
    }
    return folders;
  }

  Future<double> getAllSize() async {
    double sum =0;
    for (var folder in _directories) {
      if (folder.existsSync()) {
        double c = await getFileSize(folder);
        sum += c;
        //print('GetAllSize B=> cur folder: ${folder.path} Size:$c');
      }
    }
    return sum;
  }

  Future<void> deleteFolder(Directory file) async {
    if (file is Directory) {
      await Future.forEach(file.listSync(), (FileSystemEntity f) async {
        await f.delete(recursive: true);
      });
    }
  }
  Future<bool> clearAllCache() async {
    if (status != StatusCalcalated) {
      return false;
    }
    setState(() {
      status = StatusFlushing;
    });
    double less = sumFileSize;
    await Future.forEach(_directories, (Directory f) async {
      double sz = await getFileSize(f);
      less -= sz;
      await deleteFolder(f);
      lessFileSize = less;
      setState((){});
    });
    //Remove SharedPreferences
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    //await preferences.clear();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    //print('build cache_manager: status=$status, sumFileSize=$sumFileSize');
    return widget.render(
      status: status,
      sumfileSize: sumFileSize,
      lessFileSize: lessFileSize,
      //formatedSumSize: formatSize(sumFileSize),
      //formatedlessSize: formatSize(lessFileSize),
      formator: formatSize,
      exec: (Function fn) async {
        bool rs = await clearAllCache();
        if (rs) {
          setState(() {
            status = StatusFlushed;
          });
          Future.delayed(Duration(milliseconds: 500), fn());
        }
      }
    );
  }
  String formatSize(double value) {
    List<String> unitArr = ['B', 'K', 'M', 'G'];
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }
}
