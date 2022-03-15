import 'package:http_parser/http_parser.dart';

/// 快捷工具类
class FileUtils {
  static listIsEmpty(List val) {
    return val.length > 0 ? val.every((item) => item == null) : true;
  }

  static String name(path) {
    List _paths = path.split('/');
    return _paths[_paths.length - 1];
  }

  static String ext(path) {
    List _paths = path.split('.');
    return _paths[_paths.length - 1];
  }

  static String type(path) {
    String _type='';
    String fileExt = ext(path);
    if (['jpg', 'jpeg', 'png', 'heic', 'webp'].contains(fileExt)) {
      _type = 'image';
    } else if (['mp4', 'mov', 'heiv', 'webm'].contains(fileExt)) {
      _type = 'video';
    }
    return _type;
  }

  static String getDir(String path) {
    List _paths = path.split('/');
    return _paths.sublist(0, _paths.length-1).join('/');
  }
  static String baseName(String path, {bool noExt=false}) {
    String _name = path.split('/').last;
    if (noExt) {
      List<String> _names = _name.split('.');
      if (_names.length  < 2) {
        return _name;
      }
      return _names.sublist(0, _names.length-1).join('.');
    } else {
      return _name;
    }
  }

  static MediaType mediaType(final String path) {
    final fileExt = ext(path);
    switch (fileExt) {
      case "jpg":
      case "jpeg":
      case "jpe":
        return new MediaType("image", "jpeg");
      case "png":
        return new MediaType("image", "png");
      case "bmp":
        return new MediaType("image", "bmp");
      case "gif":
        return new MediaType("image", "gif");
      case "json":
        return new MediaType("application", "json");
      case "svg":
      case "svgz":
        return new MediaType("image", "svg+xml");
      case "mp3":
        return new MediaType("audio", "mpeg");
      case "mp4":
        return new MediaType("video", "mp4");
      case "htm":
      case "html":
        return new MediaType("text", "html");
      case "css":
        return new MediaType("text", "css");
      case "csv":
        return new MediaType("text", "csv");
      case "txt":
      case "text":
      case "conf":
      case "def":
      case "log":
      case "in":
        return new MediaType("text", "plain");
    }
    return new MediaType("text", "plain");
  }
}
