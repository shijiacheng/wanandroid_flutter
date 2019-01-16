import 'package:flutter/material.dart';
import '../GlobalConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../common/Application.dart';
import '../event/theme_change_event.dart';
import 'AboutAppPageUI.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DrawerDemo extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DrawerDemoState();
  }
}

class DrawerDemoState extends State<DrawerDemo> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName:
            Text('shijiacheng', style: TextStyle(fontWeight: FontWeight.bold)),
            accountEmail: Text('iot_shijiacheng@163.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'http://life.southmoney.com/tuwen/UploadFiles_6871/201808/20180828134237360.jpg'),
            ),
            decoration: BoxDecoration(
              color: Colors.yellow[400],
              image: DecorationImage(
                image: NetworkImage(
                    'http://www.jituwang.com/uploads/allimg/130206/260506-13020619115780.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                    Colors.yellow[400].withOpacity(0.6), BlendMode.hardLight),
              ),
            ),
          ),
          ListTile(
            title: Text(
              '夜间模式',
              textAlign: TextAlign.left,
            ),
            leading: Icon(Icons.wb_sunny, color: GlobalConfig.themeData.accentColor, size: 22.0),
            onTap: () {
              setState((){
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
            leading: Icon(Icons.settings_applications, color: GlobalConfig.themeData.accentColor, size: 22.0),
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
            leading: Icon(Icons.people, color: GlobalConfig.themeData.accentColor, size: 22.0),
            onTap: () {
              onAboutClick();
//              Navigator.pop(context);
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
      ),
    );
  }

  void onAboutClick() async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new AboutAppPageUI();
    }));
  }

  changeTheme() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool("themeIndex", GlobalConfig.dark);
    Application.eventBus.fire(new ThemeChangeEvent(GlobalConfig.dark));
  }
}