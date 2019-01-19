import 'package:flutter/material.dart';
import '../model/ArticleModel.dart';
import 'WebViewPageUI.dart';
import '../utils/timeline_util.dart';
import '../api/common_service.dart';

/// 搜索结果
class SearchResultPageUI extends StatefulWidget {
  String id;

  SearchResultPageUI(ValueKey<String> key) : super(key: key) {
    this.id = key.value.toString();
  }

  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<SearchResultPageUI> {
  List<Article> _datas = new List();
  ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 0; //加载的页数

  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMore();
      }
    });
  }

  Future<Null> _getData() async {
    String str = widget.id;
    _page = 0;
    CommonService().getSearchResult((ArticleModel _articleModel) {
      setState(() {
        _datas = _articleModel.data.datas;
      });
    }, _page, str);
  }

  Future<Null> _getMore() async {
    _page++;
    String str = widget.id;
    CommonService().getSearchResult((ArticleModel _articleModel) {
      setState(() {
        _datas.addAll(_articleModel.data.datas);
      });
    }, _page, str);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: _getData,
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
      child: _newsRow(_datas[index]),
      onTap: () {
        _onItemClick(_datas[index]);
      },
    );
  }

  void _onItemClick(Article itemData) async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new WebViewPageUI(
        title: itemData.title,
        url: itemData.link,
      );
    }));
  }

  Widget _separatorView(BuildContext context, int index) {
    return Container(
      height: 0.5,
      color: Colors.black26,
    );
  }

  Widget _newsRow(Article item) {
//    return new Row(
//      children: <Widget>[
//        Container(
//            padding: EdgeInsets.fromLTRB(8,16,8,8),
//            child: Image.network(item.envelopePic,width: 80,height: 120,fit: BoxFit.fill,)
//        ),

    return new Column(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              children: <Widget>[
                Expanded(
//                          child: Rich(item.title,
//                            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
//                            textAlign: TextAlign.left,
//                          )
                  child: RichText(
                      text: TextSpan(
                    text: item.title
                        .replaceAll("<em class='highlight'>", "")
                        .replaceAll("<\/em>", ""),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                    ),
                  )),
                )
              ],
            )),
        Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: <Widget>[
                Expanded(
                    child: Text(
                  item.desc,
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.left,
                  maxLines: 3,
                ))
              ],
            )),
        new Container(
            padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  item.author,
                  style: TextStyle(fontSize: 12),
                ),
                new Expanded(
                  child: new Text(
                    TimelineUtil.format(item.publishTime),
                    style: TextStyle(fontSize: 12),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            )),
      ],
//          ),
//        ),
//      ],
    );
  }

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
