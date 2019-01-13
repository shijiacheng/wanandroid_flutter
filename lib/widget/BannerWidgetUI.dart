import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import '../model/BannerModel.dart';
import '../utils/RouteUtil.dart';

class BannerWidgetUI extends StatefulWidget {
  @override
  BannerWidgetUIState createState() {
    return BannerWidgetUIState();
  }
}

class BannerWidgetUIState extends State<BannerWidgetUI> {
  Dio _dio;
  List<BannerData> _bannerList  = new List();

  @override
  void initState() {
    _dio = new Dio();
    _bannerList.add(null);
    _getBanner();
  }

  Future<Null> _getBanner() async{
    Response response = await _dio.get("http://www.wanandroid.com/banner/json");
    var bannerModel = new BannerModel(response.data);
    _bannerList = bannerModel.data;
    setState(() {

    });
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
            return buildItemImageWidget(context,index);
          }
        },
        itemCount: _bannerList.length,
        autoplay: true,
        pagination: new SwiperPagination(),
      ),
    ) ;
  }


  Widget buildItemImageWidget(BuildContext context,int index){
    return new InkWell(
      onTap: () {
        RouteUtil.toWebView(context, _bannerList[index].title, _bannerList[index].url);
      },
      child: new Container(
        child: new Image.network(_bannerList[index].imagePath,fit: BoxFit.fill,),
      ),
    );
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