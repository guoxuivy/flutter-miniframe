import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("404", style: Theme.of(context).textTheme.subtitle2),
      ),
      body: Text("页面不存在"),
    );
  }
}
