import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
//当前登录用户
final ChangeNotifierProvider<UserModel> userProvider = ChangeNotifierProvider((_)=> UserModel() );

class User  {
  int id = 0;
  String username = '';
  String password = '';
  User ({this.id, this.username});
}

class UserModel extends ChangeNotifier {
  User _user;
  User get current => this._user;
  void setUser(User u) {
    this._user = u;
    notifyListeners();
  }
  void clearUser() {
    this._user = null;
    notifyListeners();
  }
}