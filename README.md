# cxe

仓小二用户端 **flutter**

## Getting Started

This project is a starting point for a Flutter application.

- flutter相关 [快速入门文档](https://flutter.cn/docs)

- flutter开发文档参考 [快速入门文档](https://book.flutterchina.club/chapter1/flutter_intro.html)



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
│  ├─provider                           状态管理模块（使用riverpod进行模块间数据传递）
│  │  └─theme.dart                      主题状态管理示例
│  ├─res                                自主定义的一些静态资源（封装dio）
│  │  ├─colors.dart                     颜色静态常量
│  │  └─...
│  ├─routers                            路由管理
│  │  ├─routers.dart                    路由加载分发类
│  │  └─not_found_page.dart             404页面路由
│  ├─util                               工具模块
│  │  ├─utils.dart                      自定义各种快捷工具
│  │  ├─local_storage.dart              本地存储工具封装
│  │  └─logs.dart                       全局系统日志处理
│  ├─page                               主页面逻辑【前端灵活布局】
│  │  ├─home.dart                       首页逻辑
│  │  ├─...                             公用小组件封装widget
│  │  └─
│  │
│  ├─...
│  └─main.dart                          入口文件

├─...                
├─pubspec.yaml                          第三方类库依赖库配置文件
├─README.md                             README 文件
~~~


## 命名规范

### 目录和文件

*   目录小写；
*   文件小写+下划线模式；
*   类名和类文件名保持一致，统一采用驼峰法命名（首字母大写）；
*   page目录下类名加上目录前缀，比如page/demo/home.dart 类名为 DemoHomePage

### 函数和类、属性命名
*   类的命名采用驼峰法，并且首字母大写，例如 `User`、`UserType`；
*   私有成员属性or方法下划线开头 例如 `_title`、`_getInstance`；
*   方法的命名使用驼峰法，并且首字母小写，例如 `getUserName`；
*   属性的命名使用驼峰法，并且首字母小写，例如 `tableName`、`instance`；

### 环境依赖
*  environment: sdk: ">=2.10.3 <3.0.0"
*  android/build.gradle 下添加国内源
*  Flutter 1.22.4 • channel stable 
*  Dart 2.10.4


