import 'package:flutter/material.dart';

class BottomNavigationBarDemo extends StatefulWidget {

  final int index;
  final ValueChanged<int> onChanged;

  BottomNavigationBarDemo({Key key, this.index: 0, @required this.onChanged})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _BottomNavigationBarDemoState();
  }
}

class _BottomNavigationBarDemoState extends State<BottomNavigationBarDemo>  with AutomaticKeepAliveClientMixin{
  int _currentIndex = 0;

  void _onTapHandler(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _onTapHandler,
      type: BottomNavigationBarType.fixed,
      fixedColor: Colors.blue,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('首页'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.streetview),
          title: Text('体系'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          title: Text('公众号'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.navigation),
          title: Text('导航'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apps),
          title: Text('项目'),
        ),

      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
