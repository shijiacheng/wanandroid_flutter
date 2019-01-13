import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import '../model/WxArticleTitleModel.dart';
import '../model/WxArticleContentModel.dart';
import '../utils/timeline_util.dart';

class WxArticlePageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyTabbedPageState();
  }

}


class _MyTabbedPageState extends State<WxArticlePageUI> with TickerProviderStateMixin {

  Future<Null> getData() async{
    Response response = await dio.get("http://wanandroid.com/wxarticle/chapters/json");
    var articleTitleModel = new WxArticleTitleModel(response.data);
    setState(() {
      _datas = articleTitleModel.data;
    });
  }


  //将每个Tab页都结构化处理下，由于http的请求需要传入新闻类型的参数，因此将新闻类型参数值作为对象属性传入Tab中
  List<WxArticleTitleData> _datas = new List();

  TabController _tabController;
  Dio dio;

  @override
  void initState() {
    super.initState();
    dio = new Dio();
    getData();
//    _tabController = new TabController(vsync: this, length: _datas.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = new TabController(vsync: this, length: _datas.length);
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.purple,
        title: new TabBar(
          controller: _tabController,
          tabs: _datas.map((WxArticleTitleData item){
            return Tab(text: item.name,);
          }).toList(),
          indicatorColor: Colors.white,
          isScrollable: true,   //水平滚动的开关，开启后Tab标签可自适应宽度并可横向拉动，关闭后每个Tab自动压缩为总长符合屏幕宽度的等宽，默认关闭
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: _datas.map((item) {
          return NewsList(idsss: item.id,);
        }).toList(),
      ),
    );
  }
}

//新闻列表
class NewsList extends StatefulWidget{
  final int idsss;    //新闻类型
  @override
  NewsList({Key key, this.idsss} ):super(key:key);

  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<NewsList>{

  List<WxArticleContentDatas> _datas  = new List();
  ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数

  Dio dio;

  @override
  void initState() {
    dio = new Dio();
    getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');

        _getMore();
      }
    });
  }


  Future<Null> getData() async{
    _page = 1;
    print("$widget.idsss");
    int _id = widget.idsss;
    Response response = await dio.get("http://wanandroid.com/wxarticle/list/$_id/$_page/json");
    var articleContentModel = new WxArticleContentModel(response.data);
    setState(() {
      _datas = articleContentModel.data.datas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: getData,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemBuilder: _renderRow,
          itemCount: _datas.length + 1,
          controller: _scrollController,
        ),
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
//    if(_datas.length == 0){
//      return();
//    }

    if (index < _datas.length) {
      return _newsRow(_datas[index]);
    }
    return _getMoreWidget();
  }

  //新闻列表单个item
  Widget _newsRow(WxArticleContentDatas item){
    return new Card(

      child: new Column(
        children: <Widget>[

          Container(
              padding: EdgeInsets.fromLTRB(16,8,16,8),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(item.title,
                        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      )
                  )
                ],
              )
          ),

          new Container(
              padding: EdgeInsets.fromLTRB(16,0,16,8),
              child:new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Expanded(
                    child: new Text(TimelineUtil.format(item.publishTime),
                      style: TextStyle(fontSize: 12,color: Colors.grey),
                    ),
                  ),
                ],
              )),

        ],
      ),
    );
  }

  Future<Null> _getMore() async{
    _page++;
    print("$_page");
    int _id = widget.idsss;
    Response response = await dio.get("http://wanandroid.com/wxarticle/list/$_id/$_page/json");
    var articleContentModel = new WxArticleContentModel(response.data);
    setState(() {
      _datas.addAll(articleContentModel.data.datas);
    });
  }

//  /**
//   * 加载更多时显示的组件,给用户提示
//   */
  Widget _getMoreWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2,),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }





}