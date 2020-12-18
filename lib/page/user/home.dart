import 'package:cxe/routers/routers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../model/user.dart';
import 'package:cxe/util/utils.dart';

/*
class UserHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '用户中心',
      navigatorKey: Routers.navigatorKey,
      home: userConsumer(parentContext:context)
    );
  }
}
class userConsumer extends ConsumerWidget {
*/
class UserHome extends ConsumerWidget {
  Widget showUser() {
    return Column(
      children: [
        Text('你已登录，欢迎！'),
        RaisedButton(
          child: Text('去看看'),
          onPressed: () =>Routers.navigatorKey.currentState.pushNamed('/index')
        )
      ],
    );
  }
  Widget showNoUser(BuildContext context) {
    return Column(
      children: [
        Text('您未登录'),
        RaisedButton(
          child: Text('立即登录'),
          onPressed: () => Routers.go(context, '/login')
        )
      ],
    );
  }
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final User u = watch(userProvider).current;

    return Scaffold(
      appBar: AppBar(title: Text('用户')),
      body: u == null ? showNoUser(context) : showUser()
    );
  }
}