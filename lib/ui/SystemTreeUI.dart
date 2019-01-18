import 'package:flutter/material.dart';
import '../model/SystemTreeModel.dart';
import 'SystemTreeContentPageUI.dart';
import '../api/common_service.dart';

/// 知识体系页面
class SystemTreeUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SystemTreeUIState();
  }
}

class SystemTreeUIState extends State<SystemTreeUI> {
  List<SystemTreeData> _datas = new List();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: new AppBar(
      //   title: new Text("知识体系"),
      //   elevation: 0.4,
      // ),
      body: RefreshIndicator(
        onRefresh: _getData,
        child: ListView.separated(
          itemBuilder: _renderRow,
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              height: 0.5,
              color: Colors.black26,
            );
          },
          itemCount: _datas.length,
        ),
      ),
    );
  }

  void _onItemClick(SystemTreeData itemData) async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new SystemTreeContentPageUI(new ValueKey(itemData));
    }));
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < _datas.length) {
      return InkWell(
        onTap: () {
          _onItemClick(_datas[index]);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
                child: Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(bottom: 8),
                    child: Text(
                      _datas[index].name,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      child: buildChildren(_datas[index].children)),
                ],
              ),
            )),
            Icon(Icons.chevron_right)
          ],
        ),
      );
    }

    return null;
  }

  Widget buildChildren(List<SystemTreeChild> children) {
    List<Widget> tiles = []; //先建一个数组用于存放循环生成的widget
    Widget content; //单独一个widget组件，用于返回需要生成的内容widget
    for (var item in children) {
      tiles.add(
        new Chip(
          label: new Text(item.name),
//          avatar: new CircleAvatar(backgroundColor: Colors.blue,child: Text("A"),),
        ),
      );
    }

    content = Wrap(
        spacing: 8.0,
        runSpacing: 4.0,
        alignment: WrapAlignment.start,
        children: tiles);

    return content;
  }

  Future<Null> _getData() async {
    CommonService().getSystemTree((SystemTreeModel _systemTreeModel) {
      setState(() {
        _datas = _systemTreeModel.data;
      });
    });
  }
}
