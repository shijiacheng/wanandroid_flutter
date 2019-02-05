import 'package:flutter/material.dart';
import '../account/RegisterPageUI.dart';
import '../../api/common_service.dart';
import '../../model/UserModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import '../../common/User.dart';
import '../../common/Application.dart';
import '../../event/login_event.dart';

class LoginPageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LoginPageUIState();
  }
}

class LoginPageUIState extends State<LoginPageUI> {
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _psdController = TextEditingController();

  Future<Null> _login() async {
    String username = _userNameController.text;
    String password = _psdController.text;
    CommonService().login((UserModel _userModel,Response response) {
      if (_userModel != null) {
        User().saveUserInfo(_userModel, response);
        Application.eventBus.fire(new LoginEvent());
        if (_userModel.errorCode == 0) {
          Fluttertoast.showToast(msg: "登录成功！");
          Navigator.of(context).pop();
        } else {
          Fluttertoast.showToast(msg: _userModel.errorMsg);
        }
      }
    }, username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.4,
          title: Text("登录"),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "用户登录",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "请使用WanAndroid账号登录",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                TextField(
                  autofocus: true,
                  controller: _userNameController,
                  decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "请输入用户名或邮箱",
                    labelStyle: TextStyle(color: Colors.blue),
                    prefixIcon: Icon(Icons.person),
                  ),
                  maxLines: 1,
                ),
                TextField(
                  controller: _psdController,
                  decoration: InputDecoration(
                      labelText: "密码",
                      labelStyle: TextStyle(color: Colors.blue),
                      hintText: "您的登录密码",
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  maxLines: 1,
                ),

                // 登录按钮
                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.all(16.0),
                          elevation: 0.5,
                          child: Text("登录"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {
                            _login();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.only(top: 10),
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      child:
                          Text("还没有账号，注册一个？", style: TextStyle(fontSize: 14)),
                      onPressed: () {
                        onRegisterClick();
                      },
                    )),
              ],
            ),
          ),
        ));
  }

  void onRegisterClick() async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new RegisterPageUI();
    }));
  }
}
