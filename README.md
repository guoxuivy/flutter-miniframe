# flutter-miniframe

flutter-miniframe

## Getting Started

This project is a starting point for a Flutter application.

- flutter相关 [快速入门文档](https://flutter.cn/docs)

- flutter开发文档参考 [快速入门文档](https://book.flutterchina.club/chapter1/flutter_intro.html)


## 安装

1. 在需要安装的目录执行 `git clone https://github.com/flutter/flutter.git -b stable`
1. 将flutter加入环境变量
1. flutter 和 dart 命令是否位于同一目录以确保兼容 `which flutter dart`
1. flutter doctor 诊断
1. flutter pub get 安装依赖
1. flutter run 启用应用

## 国内镜像

两个用户变量
FLUTTER_STORAGE_BASE_URL
https://storage.flutter-io.cn
PUB_HOSTED_URL
https://pub.flutter-io.cn

## 目录结构

初始的目录结构如下：

~~~
project  WEB部署目录（或者子目录）
├─android                               安装相关目录
│  ├─build.gradle                       安卓依赖包相关配置
│  ├─app                                安卓原生相关
│  └─...
├─build                                 打包输出目录
│  └─...
├─ios                                   ios相关目录
│  └─...
├─test                                  测试逻辑目录
│  └─...
├─lib                                   flutter项目主目录（内部结构自定义）
│  ├─net                                网络处理模块（封装dio）
│  │  ├─http_manager.dart               网络请求主类
│  │  ├─auth_interceptors.dart          网络安全验证拦截器
│  │  └─logs_interceptors.dart          网络日志拦截器
│  ├─provider                           状态管理模块（使用riverpod进行模块间数据传递）store(vuex)
│  │  └─theme.dart                      主题状态管理示例
│  ├─res                                自主定义的一些静态资源
│  │  ├─colors.dart                     颜色静态常量
│  │  └─...
│  ├─routers                            路由管理
│  │  ├─routers.dart                    路由加载分发类
│  │  └─not_found_page.dart             404页面路由
│  ├─utils                              工具模块
│  │  ├─utils.dart                      自定义各种快捷工具
│  │  ├─local_storage.dart              本地存储工具封装
│  │  └─logs.dart                       全局系统日志处理
│  ├─pages                              主页面逻辑【前端灵活布局】
│  │  ├─home.dart                       首页逻辑
│  │  ├─...                             公用小组件封装widget
│  │  └─
│  ├─widgets                            公用小组件封装widget(components)
│  ├─services                           服务
│  │
│  ├─...
│  ├─boot.dart                          APP启动
│  ├─config.dart                        配置文件
│  ├─launch.dart                        启动页
│  └─main.dart                          入口文件

├─...
├─pubspec.yaml                          第三方类库依赖库配置文件
├─README.md                             README 文件
~~~


## 规范
###目录和文件
*   目录小写；
*   文件小写+下划线模式；
*   类名和类文件名保持一致，统一采用驼峰法命名（首字母大写）；
*   page目录下类名加上目录前缀，比如page/demo/home.dart 类名为 DemoHomePage
### 函数和类、属性命名
*   不使用new创建
*   类的命名采用驼峰法，并且首字母大写，例如 `User`、`UserType`；
*   私有成员属性or方法下划线开头 例如 `_title`、`_getInstance`；
*   方法的命名使用驼峰法，并且首字母小写，例如 `getUserName`；
*   变量、属性的命名使用驼峰法，并且首字母小写，例如 `tableName`、`instance`；
### 导入
*   导包有顺序要求,且每"部分"间空行分隔开,每部分内按字母排序,按如下顺序排序：
*   dart sdk内的库
*   flutter内的库
*   第三方库
*   自己的库 (采用项目方式引入，编辑器支持，不建议相对路径引用)
*   先全部import再export,不要交替进行
### 注释
*   使用 /// 注释成员和类型 （可生成文档）
*   使用 // 处理不需要生成文档的注释
*   推荐使用（/ * … * /）注释代码，其他文字注释应该使用//
### 组件，建议封装
*   函数体代码不宜过多，最好在20 - 30行以内 过多改用调用 一个方法中尽量只做一件事
*   flutter嵌套层数最好3以内 改为调用



## 环境依赖
*  environment: sdk: ">=2.10.3 <3.0.0"
*  android/build.gradle 下添加国内源
*  Flutter 1.22.4 • channel stable
*  Dart 2.10.4

