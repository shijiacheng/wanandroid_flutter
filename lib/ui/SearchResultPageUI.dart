import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../model/ArticleModel.dart';
import 'WebViewPageUI.dart';
import '../utils/timeline_util.dart';

//新闻列表
class SearchResultPageUI extends StatefulWidget{
  String id;

  //这里为什么用含有key的这个构造,大家可以试一下不带key 直接SearchListPage(this.id) ,看看会有什么bug;

  SearchResultPageUI(ValueKey<String> key) : super(key: key) {
    this.id = key.value.toString();
  }

  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<SearchResultPageUI>{

  List<Article> _datas  = new List();
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

    FormData formData = new FormData.from({
      "k": widget.id,
    });
    Response response = await dio.post("http://www.wanandroid.com/article/query/$_page/json",data: formData);
    var articleModel = new ArticleModel(response.data);
    setState(() {
      _datas = articleModel.data.datas;
    });
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
      return _itemView(context,index);
    }
    return _getMoreWidget();
  }

  Widget _itemView(BuildContext context, int index) {
    return GestureDetector(
      child:_newsRow(_datas[index]),
      onTap: (){
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



  //新闻列表单个item
  Widget _newsRow(Article item){
    return new Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(8,16,8,8),
            child: Image.network(item.envelopePic,width: 80,height: 120,fit: BoxFit.fill,)
        ),

        Expanded(
          child: new Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(8,8,8,8),
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

              Container(
                  padding: EdgeInsets.fromLTRB(8,0,8,8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(item.desc,
                            style: TextStyle(fontSize: 12,color: Colors.grey),
                            textAlign: TextAlign.left,
                            maxLines: 3,
                          )
                      )
                    ],
                  )
              ),

              new Container(
                  padding: EdgeInsets.fromLTRB(8,0,8,8),
                  child:new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(item.author,
                        style: TextStyle(fontSize: 12,color: Colors.grey),
                      ),

                      new Expanded(
                        child: new Text(TimelineUtil.format(item.publishTime),
                          style: TextStyle(fontSize: 12,color: Colors.grey),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  )),

            ],
          ),
        ),



      ],

    );
  }

  Future<Null> _getMore() async{
    _page++;
    print("$_page");

    FormData formData = new FormData.from({
      "k": widget.id,
    });
    Response response = await dio.post("http://www.wanandroid.com/article/query/$_page/json",data: formData);
    var articleModel = new ArticleModel(response.data);

    setState(() {
      _datas.addAll(articleModel.data.datas);
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