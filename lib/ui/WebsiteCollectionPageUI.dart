import 'package:flutter/material.dart';
import '../api/common_service.dart';
import '../model/WebsiteCollectionModel.dart';
import 'WebsiteCollectionAddPageUI.dart';
import '../model/BaseModel.dart';
import '../utils/route_util.dart';

class WebsiteCollectionPageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WebsiteCollectionPageUIState();
  }
}

class WebsiteCollectionPageUIState extends State<WebsiteCollectionPageUI> {
  bool editStatus = false;

  List<WebsiteCollectionData> _datas = new List();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<Null> _getData() async {
    CommonService()
        .getWebsiteCollectionList((WebsiteCollectionModel _collectionModel) {
      _datas = _collectionModel.data;
      setState(() {});
    });
  }

  Future<Null> _cancelCollect(int _id, WebsiteCollectionData _item) async {
    CommonService().cancelWebsiteCollectionList((BaseModel _baseModel) {
      if (_baseModel.errorCode == 0) {
        _datas.remove(_item);
      }
      setState(() {});
    }, _id);
  }

  Widget buildChip(BuildContext context, WebsiteCollectionData _item) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Chip(
          label: FlatButton(
            child: Text(_item.name),
            onPressed: () => editStatus
                ? onWebsiteEditClick(context, _item)
                : RouteUtil.toWebView(context, _item.name, _item.link),
          ),
          avatar: Icon(Icons.web, color: Colors.lightBlue),
          deleteIcon: Icon(Icons.delete_forever),
          deleteIconColor: Colors.red,
          onDeleted: editStatus
              ? () {
                  showDialog(
                    context: context,
                    child: new AlertDialog(
                      title: new Text('提示'),
                      content: new Text("确定删除${_item.name}吗？"),
                      actions: <Widget>[
                        new FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('取消')),
                        new FlatButton(
                          onPressed: () {
                            _cancelCollect(_item.id, _item);
                            Navigator.of(context).pop();
                          },
                          child: const Text('确定'),
                        ),
                      ],
                    ),
                  );
                }
              : null),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("常用网站"), elevation: 0.4, actions: <Widget>[
        FlatButton(
            child: Text(editStatus ? "完成" : '编辑'),
            onPressed: () {
              editStatus = !editStatus;
              setState(() {});
            })
      ]),
      body: RefreshIndicator(
        onRefresh: () => _getData(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Wrap(
            children: _datas.map((item) {
              return buildChip(context, item);
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          onWebsiteAddClick(context);
        },
        tooltip: '收藏',
        child: new Icon(Icons.add),
      ),
    );
  }

  void onWebsiteAddClick(BuildContext context) async {
    await Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new WebsiteCollectionAddPageUI(
          website: null,
        );
      },
      fullscreenDialog: true,
    ));
  }

  void onWebsiteEditClick(
      BuildContext context, WebsiteCollectionData _item) async {
    await Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new WebsiteCollectionAddPageUI(
          website: _item,
        );
      },
      fullscreenDialog: true,
    ));
  }
}
