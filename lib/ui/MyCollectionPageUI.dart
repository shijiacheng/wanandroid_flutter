import 'package:flutter/material.dart';
import '../utils/timeline_util.dart';
import '../utils/route_util.dart';
import '../api/common_service.dart';
import '../model/CollectionModel.dart';
import '../model/BaseModel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'CollectionAddPageUI.dart';

class MyCollectionPageUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("我的收藏"),
        elevation: 0.4,
      ),
      body: NewsList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          onCollectionAddClick(context);
        },
        tooltip: '收藏',
        child: new Icon(Icons.add),
      ),
    );
  }

  void onCollectionAddClick(BuildContext context) async {
    await Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new CollectionAddPageUI();
      },
      fullscreenDialog: true,
    ));
  }
}

//知识体系文章列表
class NewsList extends StatefulWidget {
  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<Collection> _datas = new List();
  ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 0; //加载的页数

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

  Future<Null> getData() async {
    _page = 0;
    CommonService().getCollectionList((CollectionModel _collectionModel) {
      setState(() {
        _datas = _collectionModel.data.datas;
      });
    }, _page);
  }

  Future<Null> _getMore() async {
    _page++;
    CommonService().getCollectionList((CollectionModel _collectionModel) {
      setState(() {
        _datas.addAll(_collectionModel.data.datas);
      });
    }, _page);
  }

  Future<Null> _cancelCollection(int _position, int _id, int _originId) async {
    CommonService().cancelCollection((BaseModel _baseModel) {
      if (_baseModel.errorCode == 0) {
        _datas.removeAt(_position);
      }
      Scaffold.of(context).showSnackBar(new SnackBar(
        content: Text("移除成功！"),
      ));
      setState(() {});
    }, _id, _originId);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: getData,
        child: ListView.separated(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: _renderRow,
          itemCount: _datas.length + 1,
          controller: _scrollController,
          separatorBuilder: _separatorView,
        ),
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < _datas.length) {
      return _itemView(context, index);
    }
    return _getMoreWidget();
  }

  Widget _itemView(BuildContext context, int index) {
    return InkWell(
      child: _slideRow(index, _datas[index]),
      onTap: () {
        RouteUtil.toWebView(context, _datas[index].title, _datas[index].link);
      },
    );
  }

  Widget _separatorView(BuildContext context, int index) {
    return Container(
      height: 0.5,
      color: Colors.black26,
    );
  }

  Widget _slideRow(int index, Collection item) {
    return new Slidable(
      delegate: new SlidableDrawerDelegate(),
      actionExtentRatio: 0.25,
      child: _newsRow(item),
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: '取消收藏',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () {
            _cancelCollection(index, item.id, item.originId);
          },
        ),
      ],
    );
  }

  Widget _newsRow(Collection item) {
    return new Column(
      children: <Widget>[
        new Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "作者：" + item.author,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                new Expanded(
                  child: new Text(
                    "收藏时间：" + TimelineUtil.format(item.publishTime),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            )),
        Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  item.title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                ))
              ],
            )),
        Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: <Widget>[
                item.chapterName.isNotEmpty
                    ? Expanded(
                        child: Text(
                          "分类：" + item.chapterName,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      )
                    : Text("")
              ],
            )),
      ],
    );
  }

  // 加载更多时显示的组件,给用户提示
  Widget _getMoreWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
