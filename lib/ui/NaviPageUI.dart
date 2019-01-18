import 'package:flutter/material.dart';
import '../model/NaviModel.dart';
import 'WebViewPageUI.dart';
import '../api/common_service.dart';

class NaviPageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new NaviPageUIState();
  }
}

class NaviPageUIState extends State<NaviPageUI> {
  List<NaviData> _naviTitles = new List();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("导航"),
      //   elevation: 0.4,
      // ),

      body: Container(
        child: _rightListView(context),
      ),
    );
  }

  Widget _leftListView(BuildContext context) {
    return ListView.builder(
      itemBuilder: _renderRow,
      itemCount: _naviTitles.length,
    );
  }

  Widget _rightListView(BuildContext context) {
    return ListView.builder(
      itemBuilder: _renderContent,
      itemCount: _naviTitles.length,
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    return Container(
      alignment: Alignment.center,
      height: 50,
      child: Text(_naviTitles[index].name),
    );
  }

  Widget _renderContent(BuildContext context, int index) {
    return Container(
        child: Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              _naviTitles[index].name,
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              child: buildChildren(_naviTitles[index].articles)),
        ],
      ),
    ));
  }

  Widget buildChildren(List<NaviArticle> children) {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in children) {
      tiles.add(new InkWell(
        child: new Chip(
          label: new Text(item.title),
        ),
        onTap: () {
          _onItemClick(item);
        },
      ));
    }

    content = Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.start,
        children: tiles);

    return content;
  }

  void _onItemClick(NaviArticle itemData) async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new WebViewPageUI(
        title: itemData.title,
        url: itemData.link,
      );
    }));
  }

  Future<Null> _getData() async {
    CommonService().getNaviList((NaviModel _naviData) {
      setState(() {
        _naviTitles = _naviData.data;
      });
    });
  }
}
