import 'package:flutter/material.dart';
import './widget/BottomNavigationBarDemo.dart';
import './ui/HomePageUI.dart';
import './ui/SystemTreeUI.dart';
import './ui/WxArticlePageUI.dart';
import './ui/ProjectTreePageUI.dart';
import './ui/NaviPageUI.dart';
import 'GlobalConfig.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'event/theme_change_event.dart';
import 'common/Application.dart';
import 'package:event_bus/event_bus.dart';

void main() async {
  bool themeIndex = await getTheme();
  runApp(MyApp(themeIndex));
}

Future<bool> getTheme() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  bool themeIndex = sp.getBool("themeIndex");
  if (themeIndex == null) {
    themeIndex = false;
  }
  return themeIndex;
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
      title: "WanAndroid Flutter",
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
          body: IndexedStack(
            index: _index,
            children: _pageList,
          ),
//      drawer: DrawerDemo(),
          bottomNavigationBar: BottomNavigationBarDemo(
            index: _index,
            onChanged: _handleTabChanged,
          ),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
