import 'package:flutter/material.dart';

class RegisterPageUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.4,
          title: Text("注册"),
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
                    "注册用户",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "用户注册后可使用收藏文章等众多功能！",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "用户名",
                    hintText: "请输入用户名或邮箱",
                    labelStyle: TextStyle(color: Colors.blue),
                    prefixIcon: Icon(Icons.person),
                  ),
                  maxLines: 1,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: "密码",
                      labelStyle: TextStyle(color: Colors.blue),
                      hintText: "请输入密码",
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  maxLines: 1,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: "再次输入密码",
                      labelStyle: TextStyle(color: Colors.blue),
                      hintText: "请再次输入密码",
                      prefixIcon: Icon(Icons.lock)),
                  obscureText: true,
                  maxLines: 1,
                ),


                Padding(
                  padding: const EdgeInsets.only(top: 28.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          padding: EdgeInsets.all(16.0),
                          elevation: 0.5,
                          child: Text("注册"),
                          color: Colors.blue,
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                
              ],
            ),
          ),
        ));
  }
}
