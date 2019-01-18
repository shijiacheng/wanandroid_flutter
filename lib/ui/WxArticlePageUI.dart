import 'package:flutter/material.dart';
import '../model/WxArticleTitleModel.dart';
import '../model/WxArticleContentModel.dart';
import '../utils/timeline_util.dart';
import '../utils/route_util.dart';
import '../api/common_service.dart';

class WxArticlePageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyTabbedPageState();
  }
}


class _MyTabbedPageState extends State<WxArticlePageUI> with TickerProviderStateMixin {

  List<WxArticleTitleData> _datas = new List();
  TabController _tabController;

  Future<Null> _getData() async{
    CommonService().getWxList((WxArticleTitleModel _articleTitleModel){
      setState(() {
        _datas = _articleTitleModel.data;
      });
    });

  }

  @override
  void initState() {
    super.initState();
    _getData();
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
        elevation: 0.4,
        title: new TabBar(
          controller: _tabController,
          tabs: _datas.map((WxArticleTitleData item){
            return Tab(text: item.name,);
          }).toList(),
          isScrollable: true,   //水平滚动的开关，开启后Tab标签可自适应宽度并可横向拉动，关闭后每个Tab自动压缩为总长符合屏幕宽度的等宽，默认关闭
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: _datas.map((item) {
          return NewsList(id: item.id,);
        }).toList(),
      ),
    );
  }
}

class NewsList extends StatefulWidget{
  final int id; 
  @override
  NewsList({Key key, this.id} ):super(key:key);

  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<NewsList>{
  List<WxArticleContentDatas> _datas  = new List();
  ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 1; //加载的页数

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

  Future<Null> _getData() async{
    _page = 1;
    int _id = widget.id;
    CommonService().getWxArticleList((WxArticleContentModel _articleContentModel){
      setState(() {
        _datas = _articleContentModel.data.datas;
      });
    }, _id, _page);
  }

  Future<Null> _getMore() async{
    _page++;
    int _id = widget.id;
    CommonService().getWxArticleList((WxArticleContentModel _articleContentModel){
      setState(() {
        _datas.addAll(_articleContentModel.data.datas);
      });
    }, _id, _page);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: _getData,
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
    if (index < _datas.length) {
      return _newsRow(_datas[index]);
    }
    return _getMoreWidget();
  }

  Widget _newsRow(WxArticleContentDatas item){
    return InkWell(
      onTap: (){
        RouteUtil.toWebView(context, item.title, item.link);
      },
      child: new Card(
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
      ),
    );
  }

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
    super.dispose();
    _scrollController.dispose();
  }

}