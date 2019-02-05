import 'package:flutter/material.dart';
import '../GlobalConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/Application.dart';
import '../event/theme_change_event.dart';
import 'AboutAppPageUI.dart';
import 'MyCollectionPageUI.dart';
import 'WebsiteCollectionPageUI.dart';
import './account/LoginPageUI.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'TodoPageUI.dart';
import '../common/User.dart';
import '../event/login_event.dart';

class DrawerDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DrawerDemoState();
  }
}

class DrawerDemoState extends State<DrawerDemo> {
  @override
  void initState() {
    super.initState();
    this.registerThemeEvent();
  }

  void registerThemeEvent() {
    Application.eventBus
        .on<LoginEvent>()
        .listen((LoginEvent onData) => this.changeUI());
  }

  changeUI() async {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: InkWell(
                child: Text(
                    User.singleton.userName != null
                        ? User.singleton.userName
                        : "未登录",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  if (User.singleton.userName != null) {
                    return null;
                  } else {
                    onLoginClick();
                  }
                }),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('images/avatar.jpg'),
            ),
            decoration: BoxDecoration(
              color: Colors.grey[800],
              image: DecorationImage(
                image: AssetImage(GlobalConfig.dark
                    ? 'images/bg_dark.png'
                    : 'images/bg_light.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.grey[800].withOpacity(0.6), BlendMode.hardLight),
              ),
            ),
          ),
          ListTile(
            title: Text(
              '我的收藏',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.collections,
                color: GlobalConfig.themeData.accentColor, size: 22.0),
            onTap: () {
              if (User.singleton.userName != null) {
                onCollectionClick();
              } else {
                onLoginClick();
              }
            },
          ),
          ListTile(
            title: Text(
              '常用网站',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.web,
                color: GlobalConfig.themeData.accentColor, size: 22.0),
            onTap: () {
              if (User.singleton.userName != null) {
                onWebsiteCollectionClick();
              } else {
                onLoginClick();
              }
            },
          ),
          ListTile(
            title: Text(
              'TODO',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.today,
                color: GlobalConfig.themeData.accentColor, size: 22.0),
            onTap: () {
              if (User.singleton.userName != null) {
                onTodoClick();
              } else {
                onLoginClick();
              }
            },
          ),
          ListTile(
            title: Text(
              GlobalConfig.dark ? '日间模式' : '夜间模式',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.wb_sunny,
                color: GlobalConfig.themeData.accentColor, size: 22.0),
            onTap: () {
              setState(() {
                if (GlobalConfig.dark == true) {
                  GlobalConfig.dark = false;
                } else {
                  GlobalConfig.dark = true;
                }

                changeTheme();
              });
            },
          ),
          ListTile(
            title: Text(
              '设置',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.settings_applications,
                color: GlobalConfig.themeData.accentColor, size: 22.0),
            onTap: () {
//              Navigator.pop(context);
              Fluttertoast.showToast(msg: "该功能暂未上线~");
            },
          ),
          ListTile(
            title: Text(
              '关于App',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.people,
                color: GlobalConfig.themeData.accentColor, size: 22.0),
            onTap: () {
              onAboutClick();
              Scaffold.of(context).openEndDrawer();
            },
          ),
          const SizedBox(height: 24.0),
          logoutWidget(),
        ],
      ),
    );
  }

  Widget logoutWidget() {
    if (User.singleton.userName != null) {
      return Center(
        child: FlatButton(
          child: Text("退出登录",style: TextStyle(color: Colors.red),),
          onPressed: (){
            User.singleton.clearUserInfor();
            setState(() {
              
            });
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        ),
      );
    } else {
      return SizedBox(
        height: 10,
      );
    }
  }

  void onAboutClick() async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new AboutAppPageUI();
    }));
  }

  void onLoginClick() async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new LoginPageUI();
    }));
  }

  void onCollectionClick() async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new MyCollectionPageUI();
    }));
  }

  void onWebsiteCollectionClick() async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new WebsiteCollectionPageUI();
    }));
  }

  void onTodoClick() async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new TodoPageUI();
    }));
  }

  changeTheme() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool("themeIndex", GlobalConfig.dark);
    Application.eventBus.fire(new ThemeChangeEvent(GlobalConfig.dark));
  }
}
