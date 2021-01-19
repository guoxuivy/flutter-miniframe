import 'package:agent/boot.dart';
import 'package:agent/net/http_manager.dart';
import 'package:agent/routers/routers.dart';
import 'package:flutter/material.dart';
import 'package:agent/utils/utils.dart';
import 'package:agent/widgets/ys_buttons.dart';
import 'package:agent/widgets/ys_forms.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //焦点
  FocusNode _focusNodeUserName = new FocusNode();
  FocusNode _focusNodePassWord = new FocusNode();

  //用户名输入框控制器，此控制器可以监听用户名输入框操作
  TextEditingController _userNameController = new TextEditingController();

  //表单状态
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var _password = ''; //用户名
  var _username = ''; //密码
  int showType = 1; // 显示类型 1 - 账号密码登录 2 - 手机号码登录
  var _isShowPwd = false; //是否显示密码
  var _isShowClear = false; //是否显示输入框尾部的清除按钮
  @override
  void initState() {
    // int a = int.parse("158000000030");
    // trace(a);
    trace(Boot.instance.user);
    // TODO: implement initState
    //设置焦点监听
    _focusNodeUserName.addListener(_focusNodeListener);
    _focusNodePassWord.addListener(_focusNodeListener);
    //监听用户名框的输入改变
    _userNameController.addListener(() {
      trace(_userNameController.text);
      // 监听文本框输入变化，当有内容的时候，显示尾部清除按钮，否则不显示
      if (_userNameController.text.length > 0) {
        _isShowClear = true;
      } else {
        _isShowClear = false;
      }
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // 移除焦点监听
    _focusNodeUserName.removeListener(_focusNodeListener);
    _focusNodePassWord.removeListener(_focusNodeListener);
    _userNameController.dispose();
    super.dispose();
  }

  // 监听焦点
  Future _focusNodeListener() async {
    if (_focusNodeUserName.hasFocus) {
      trace("用户名框获取焦点");
      // 取消密码框的焦点状态
      _focusNodePassWord.unfocus();
    }
    if (_focusNodePassWord.hasFocus) {
      trace("密码框获取焦点");
      // 取消用户名框焦点状态
      _focusNodeUserName.unfocus();
    }
  }

  // 验证用户名
  String validateUserName(value) {
    // 正则匹配手机号
    RegExp exp = RegExp(
        r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    if (value.isEmpty) {
      return '用户名不能为空!';
    } else if (!exp.hasMatch(value)) {
      return '请输入正确手机号';
    }
    return null;
  }

  // 验证密码
  String validatePassWord(value) {
    if (value.isEmpty) {
      return '密码不能为空';
    } else if (value.trim().length < 6) {
      return '密码长度不正确';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // logo 图片区域
    Widget logoImageArea = new Container(
        margin: EdgeInsets.only(top: 40, bottom: 10),
        // 设置图片为圆形
        child: Image.asset(
          'assets/images/logo.png',
        ));

    //输入文本框区域
    Widget inputTextArea = new Container(
      decoration: new BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Colors.white),
      child: new Form(
        key: _formKey,
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /* new TextFormField(
              controller: _userNameController,
              focusNode: _focusNodeUserName,
              //设置键盘类型
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "用户名",
                hintText: "请输入手机号",
                prefixIcon: Icon(Icons.person),
                //尾部添加清除按钮
                suffixIcon: (_isShowClear)
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          // 清空输入框内容
                          _userNameController.clear();
                        },
                      )
                    : null,
              ),
              //验证用户名
              validator: validateUserName,
              //保存数据
              onSaved: (String value) {
                _username = value;
              },
            ), */
            /* new TextFormField(
              focusNode: _focusNodePassWord,
              decoration: InputDecoration(
                  labelText: "密码",
                  hintText: "请输入密码",
                  prefixIcon: Icon(Icons.lock),
                  // 是否显示密码
                  suffixIcon: IconButton(
                    icon: Icon((_isShowPwd) ? Icons.visibility : Icons.visibility_off),
                    // 点击改变显示或隐藏密码`
                    onPressed: () {
                      setState(() {
                        _isShowPwd = !_isShowPwd;
                      });
                    },
                  )),
              obscureText: !_isShowPwd,
              //密码验证
              validator: validatePassWord,
              //保存数据
              onSaved: (String value) {
                _password = value;
              },
            ), */
            YsInput(
              // prefixIcon: '&#xe6c0;'
              // prefixIcon: Icons.cancel
              prefixIcon: '&#xe626;',
              margin: EdgeInsets.only(bottom: 15),
              hintText: '请输入手机号码',
              height: 48,
              stype: 'dark',
              onChanged: (val) {
                _username = val;
              },
            ),
            showType == 1
                ? YsInput(
                    prefixIcon: '&#xe605;',
                    margin: EdgeInsets.only(bottom: 15),
                    height: 48,
                    hintText: '请输入密码',
                    stype: 'dark',
                    type: 'password',
                    onChanged: (val) {
                      _password = val;
                      // trace(_password);
                    },
                  )
                : YsInput(
                    prefixIcon: '&#xe605;',
                    margin: EdgeInsets.only(bottom: 15),
                    height: 48,
                    hintText: '请输入短信验证码',
                    stype: 'dark',
                    onChanged: (val) {
                      // _password = val;
                    },
                    suffix: YsButtonSms(
                      captcha: 'aaa',
                    ),
                  ),
          ],
        ),
      ),
    );
    // 登录按钮区域
    Widget loginButtonArea = YsButton(
      margin: EdgeInsets.only(bottom: 15),
      title: '立即登录',
      height: 48,
      onPressed: () {
        //点击登录按钮，解除焦点，回收键盘
        _focusNodePassWord.unfocus();
        _focusNodeUserName.unfocus();
        // 需要明转下类型 不然报错
        if (_formKey.currentState.validate()) {
          //只有输入通过验证，才会执行这里
          _formKey.currentState.save();
          //todo 登录操作
          // trace("$_username + $_password");
          HttpManager().post("/backapi/login/agentLogin",
              data: {"username": _username, "password": _password,"remember":"yes"}).then((res) {
            trace(res);
            if (!res.isOk) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("error"),
                    content: Text(res.msg),
                  );
                },
              );
            } else {
              User user = Boot.instance.user;
              user.phone = res['phone'].d;
              user.name = res['name'].d;
              if (!res['remember_key'].isNull) {
                user.token = res['remember_key'].d;
              }
              user.refreshCache();
              Routers.go(context, '/home');
            }
          });
        }
      },
    );
    //第三方登录区域
    Widget thirdLoginArea = new Container(
      margin: EdgeInsets.only(left: 20, right: 20),
      child: new Column(
        children: [
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 80,
                height: 1.0,
                color: Colors.grey,
              ),
              Text('第三方登录'),
              Container(
                width: 80,
                height: 1.0,
                color: Colors.grey,
              ),
            ],
          ),
          new SizedBox(
            height: 18,
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                color: Colors.green[200],
                icon: Icon(Icons.add),
                iconSize: 40.0,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(Icons.add),
                iconSize: 40.0,
                onPressed: () {},
              ),
              IconButton(
                color: Colors.green[200],
                icon: Icon(Icons.add),
                iconSize: 40.0,
                onPressed: () {},
              )
            ],
          )
        ],
      ),
    );
    return Scaffold(
      /* appBar: AppBar(
        title: Text('登录'),
      ), */
      backgroundColor: Colors.white,
      // 外层添加一个手势，用于点击空白部分，回收键盘
      body: new GestureDetector(
          onTap: () {
            // 点击空白区域，回收键盘
            trace("点击了空白区域");
            _focusNodePassWord.unfocus();
            _focusNodeUserName.unfocus();
          },
          child: ListView(
            padding: EdgeInsets.only(right: 20, left: 20),
            children: [
              logoImageArea,
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(showType == 1 ? '账号密码登录' : '手机快捷登录',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                      YsButton(
                        title: showType == 1 ? '手机快捷登录' : '账号密码登录',
                        type: 'text',
                        onPressed: () {
                          showType = showType == 1 ? 2 : 1;
                          setState(() {});
                        },
                      )
                    ]),
              ),
              inputTextArea,
              loginButtonArea,
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  YsButton(
                    title: '忘记密码',
                    type: 'text',
                  )
                ],
              ),
            ],
          )),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 30),
        child: Text('''湖北云商云仓网络有限公司
          Copyright@ 2016-2021    cangxiaoer.com 版权所有''',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xff999999),
              fontSize: 12,
              height: 2,
            )),
      ),
    );
  }
}
