import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../model/ArticleModel.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import '../model/BannerModel.dart';
import '../utils/timeline_util.dart';
import 'WebViewPageUI.dart';
import 'SearchPageUI.dart';
import 'DrawerWidgetUI.dart';
///
/// 首页
///
class HomePageUI extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageUIState();
  }

}

class HomePageUIState extends State<HomePageUI> with AutomaticKeepAliveClientMixin{

  List<Article> _datas  = new List();
  ScrollController _scrollController = ScrollController(); //listview的控制器
  int _page = 0; //加载的页数


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
    _page = 0;
    print("$_page");
    Response response = await dio.get("http://www.wanandroid.com/article/list/$_page/json");
    var articleModel = new ArticleModel(response.data);
    setState(() {
      _datas = articleModel.data.datas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("首页"),
        elevation: 0.0,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                onSearchClick();
              })
        ],
      ),

      body: RefreshIndicator(
        onRefresh: getData,
        child: ListView.separated(
          itemBuilder: _renderRow,
          separatorBuilder: (BuildContext context, int index){
            return Container(
              height: 0.5,
              color: Colors.black26,
            );
          },
          itemCount: _datas.length + 2,
          controller: _scrollController,
        ),
      ),

      drawer: DrawerDemo(),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
//    if(_datas.length == 0){
//      return();
//    }
    if(index == 0){
      return Container(
        height: 200,
        color: Colors.purple,
        child: SwiperPage(),
      );
    }
  
    if (index-1 < _datas.length) {
      return GestureDetector(
        onTap: (){
          //条目点击事件
          onItemClick(_datas[index-1]);
        },
        child: Column(
          children: <Widget>[
            Container(
                padding: EdgeInsets.fromLTRB(16,16,16,8),
                child: Row(
                  children: <Widget>[
                    Text(_datas[index-1].author,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.left,
                    ),
                    Expanded(
                        child:Text(TimelineUtil.format(_datas[index-1].publishTime),
                          textAlign: TextAlign.right,
                          style: TextStyle(fontSize: 12),
                        )
                    ),

                  ],
                )
            ),

            Container(
                padding: EdgeInsets.fromLTRB(16,0,16,0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Text(_datas[index-1].title,
                          maxLines: 2,
                          style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        )
                    )
                  ],
                )
            ),

            Container(
                padding: EdgeInsets.fromLTRB(16,8,16,16),
                child: Row(
                  children: <Widget>[
                    Text(_datas[index-1].superChapterName,
                      style: TextStyle(fontSize: 12),
                      textAlign: TextAlign.left,
                    ),

                  ],
                )
            ),

          ],
        )
      );

    }
    return _getMoreWidget();
  }

  void onItemClick(Article itemData) async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new WebViewPageUI(
        title: itemData.title,
        url: itemData.link,
      );
    }));
  }

  void onSearchClick() async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new SearchPageUI(null);
    }));
  }

  Future<Null> _getMore() async{
    _page++;
    print("$_page");
    Response response = await dio.get("http://www.wanandroid.com/article/list/$_page/json");
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

  @override
  bool get wantKeepAlive => true;
}







class SwiperPage extends StatefulWidget {
  @override
  SwiperPageState createState() {
    return SwiperPageState();
  }
}

class SwiperPageState extends State<SwiperPage> {
  Dio dio;
  List<BannerData> _bannerList  = new List();

  @override
  void initState() {
    dio = new Dio();
    _bannerList.add(null);
    _getBanner();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshSafeArea(
      child: new Swiper(
        itemHeight: 100,
        itemBuilder: (BuildContext context,int index){
          if(_bannerList[index] == null || _bannerList[index].imagePath == null){
            return new Container(color: Colors.grey[100],);
          }else{
            return new Image.network(_bannerList[index].imagePath,fit: BoxFit.fill,);
          }

        },
        itemCount: _bannerList.length,
        autoplay: true,
        pagination: new SwiperPagination(),
      ),
    ) ;

  }


  Future<Null> _getBanner() async{
    Response response = await dio.get("http://www.wanandroid.com/banner/json");
    var bannerModel = new BannerModel(response.data);
    _bannerList = bannerModel.data;
//    _bannerList.addAll(bannerModel.data);

    setState(() {

    });
  }



}
class RefreshSafeArea extends StatelessWidget{
  final Widget child;

  // 构造函数
  RefreshSafeArea({
    Key key,
    @required this.child,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return NotificationListener(
      onNotification: (ScrollNotification notification) {
        return true;
      },
      child: this.child,
    );
  }
}