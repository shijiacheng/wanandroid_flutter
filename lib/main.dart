import 'package:flutter/material.dart';
import './widget/BottomNavigationBarDemo.dart';
import './ui/HomePageUI.dart';
import './ui/SystemTreeUI.dart';
import './ui/WxArticlePageUI.dart';
import './ui/ProjectTreePageUI.dart';
import './ui/NaviPageUI.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      title: "WanAndroid Flutter",
      debugShowCheckedModeBanner: false,
      home: Home(),
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
    );
  }
}

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new HomeState();
  }

}

class HomeState extends State<Home> with AutomaticKeepAliveClientMixin{
  int  _index = 0;
  var _pageList;

  @override
  void initState() {
    // TODO: implement initState
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
//          body: _pageList[_index],

          body: IndexedStack(
            index: _index,
            children: _pageList,
          ),
//      drawer: DrawerDemo(),
          bottomNavigationBar: BottomNavigationBarDemo(
            index: _index,
            onChanged: _handleTabChanged,
          ),
        )
    );
  }


  @override
  bool get wantKeepAlive => true;
}



