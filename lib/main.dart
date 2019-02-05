import 'package:flutter/material.dart';
import './widget/BottomNavigationBarDemo.dart';
import './ui/HomePageUI.dart';
import './ui/SystemTreeUI.dart';
import './ui/WxArticlePageUI.dart';
import './ui/ProjectTreePageUI.dart';
import './ui/NaviPageUI.dart';
import './ui/DrawerWidgetUI.dart';
import 'GlobalConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event/theme_change_event.dart';
import 'common/Application.dart';
import './ui/SearchPageUI.dart';
import 'package:event_bus/event_bus.dart';
import './common/User.dart';

void main() async {
  bool themeIndex = await getTheme();
  getLoginInfo();
  runApp(MyApp(themeIndex));
}

Future<bool> getTheme() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool themeIndex = sp.getBool("themeIndex");
  if (themeIndex == null) {
    themeIndex = false;
  }
  GlobalConfig.dark = themeIndex;
  return themeIndex;
}

Future<Null> getLoginInfo() async {
  User.singleton.getUserInfo();
}

class MyApp extends StatefulWidget {
  final bool themeIndex;
  MyApp(this.themeIndex);

  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  ThemeData themeData;

  @override
  void initState() {
    super.initState();
    Application.eventBus = EventBus();
    themeData = GlobalConfig.getThemeData(widget.themeIndex);
    this.registerThemeEvent();
  }

  void registerThemeEvent() {
    Application.eventBus
        .on<ThemeChangeEvent>()
        .listen((ThemeChangeEvent onData) => this.changeTheme(onData));
  }

  void changeTheme(ThemeChangeEvent onData) {
    setState(() {
      themeData = GlobalConfig.getThemeData(onData.dark);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "玩Android",
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: themeData,
    );
  }

  @override
  void dispose() {
    super.dispose();
    Application.eventBus.destroy();
  }
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> with AutomaticKeepAliveClientMixin {
  int _index = 0;
  var _pageList;
  var _titleList = [
    "首页",
    "知识体系",
    "公众号",
    "导航",
    "项目",
  ];

  bool _showAppbar = true;
  bool _showDrawer = true;

  @override
  void initState() {
    super.initState();
    _pageList = [
      HomePageUI(),
      SystemTreeUI(),
      WxArticlePageUI(),
      NaviPageUI(),
      ProjectTreePageUI(),
    ];
  }

  void _handleTabChanged(int newValue) {
    setState(() {
      _index = newValue;
      if (_index == 0 || _index == 1 || _index == 3) {
        _showAppbar = true;
      } else {
        _showAppbar = false;
      }

      if (_index == 0) {
        _showDrawer = true;
      } else {
        _showDrawer = false;
      }
    });
  }

  Widget _appBarWidget(BuildContext context) {
    return AppBar(
        title: Text(_titleList[_index]),
        elevation: 0.4,
        actions: _actionsWidget());
  }

  List<Widget> _actionsWidget() {
    if (_showDrawer) {
      return [
        new IconButton(
            icon: new Icon(Icons.search),
            onPressed: () {
              onSearchClick();
            })
      ];
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: DefaultTabController(
          length: 5,
          child: Scaffold(
            appBar: _showAppbar ? _appBarWidget(context) : null,
            drawer: _showDrawer ? DrawerDemo() : null,
            body: IndexedStack(
              index: _index,
              children: _pageList,
            ),
            bottomNavigationBar: BottomNavigationBarDemo(
              index: _index,
              onChanged: _handleTabChanged,
            ),
          )),
    );
  }


  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('提示'),
        content: new Text('确定退出应用吗？'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('再看一会'),
          ),
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('退出'),
          ),
        ],
      ),
    ) ?? false;
  }


  void onSearchClick() async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new SearchPageUI(null);
    }));
  }

  @override
  bool get wantKeepAlive => true;
}
