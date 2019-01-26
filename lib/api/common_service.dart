import 'Api.dart';
import 'package:dio/dio.dart';
import '../net/dio_manager.dart';
import '../model/BannerModel.dart';
import '../model/ArticleModel.dart';
import '../model/SystemTreeModel.dart';
import '../model/SystemTreeContentModel.dart';
import '../model/WxArticleTitleModel.dart';
import '../model/WxArticleContentModel.dart';
import '../model/NaviModel.dart';
import '../model/ProjectListModel.dart';
import '../model/ProjectTreeModel.dart';
import '../model/HotWordModel.dart';


class CommonService{
  void getBanner(Function callback) async {
    DioManager.singleton.dio.get(Api.HOME_BANNER, options: _getOptions()).then((response) {
      callback(BannerModel(response.data));
    });
  }
  void getArticleList(Function callback,int _page) async {
    DioManager.singleton.dio.get(Api.HOME_ARTICLE_LIST+"$_page/json", options: _getOptions()).then((response) {
      callback(ArticleModel(response.data));
    });
  }
  
  /// 获取知识体系列表
  void getSystemTree(Function callback) async {
    DioManager.singleton.dio.get(Api.SYSTEM_TREE, options: _getOptions()).then((response) {
      callback(SystemTreeModel(response.data));
    });
  }
  /// 获取知识体系列表详情
  void getSystemTreeContent(Function callback,int _page,int _id) async {
    DioManager.singleton.dio.get(Api.SYSTEM_TREE_CONTENT+"$_page/json?cid=$_id", options: _getOptions()).then((response) {
      callback(SystemTreeContentModel(response.data));
    });
  }
  /// 获取公众号名称
  void getWxList(Function callback) async {
    DioManager.singleton.dio.get(Api.WX_LIST, options: _getOptions()).then((response) {
      callback(WxArticleTitleModel(response.data));
    });
  }
  /// 获取公众号文章
  void getWxArticleList(Function callback,int _id,int _page) async {
    DioManager.singleton.dio.get(Api.WX_ARTICLE_LIST+"$_id/$_page/json", options: _getOptions()).then((response) {
      callback(WxArticleContentModel(response.data));
    });
  }
  /// 获取导航列表数据
  void getNaviList(Function callback) async {
    DioManager.singleton.dio.get(Api.NAVI_LIST, options: _getOptions()).then((response) {
      callback(NaviModel(response.data));
    });
  }
  /// 获取项目分类
  void getProjectTree(Function callback) async {
    DioManager.singleton.dio.get(Api.PROJECT_TREE, options: _getOptions()).then((response) {
      callback(ProjectTreeModel(response.data));
    });
  }
  /// 获取项目列表
  void getProjectList(Function callback,int _page,int _id) async {
    DioManager.singleton.dio.get(Api.PROJECT_LIST+"$_page/json?cid=$_id", options: _getOptions()).then((response) {
      callback(ProjectTreeListModel(response.data));
    });
  }
  /// 获取搜索热词
  void getSearchHotWord(Function callback) async {
    DioManager.singleton.dio.get(Api.SEARCH_HOT_WORD, options: _getOptions()).then((response) {
      callback(HotWordModel(response.data));
    });
  }
  /// 获取搜索结果
  void getSearchResult(Function callback,int _page,String _id) async {
    FormData formData = new FormData.from({
      "k": _id,
    });
    DioManager.singleton.dio.post(Api.SEARCH_RESULT+"$_page/json", data: formData, options: _getOptions()).then((response) {
      callback(ArticleModel(response.data));
    });
  }

  /// 获取搜索结果
  void login(Function callback,String _username,String _password) async {
    FormData formData = new FormData.from({
      "username": _username,
      "password":_password
    });
    DioManager.singleton.dio.post(Api.USER_LOGIN, data: formData, options: _getOptions()).then((response) {
      callback(ArticleModel(response.data));
    });
  }

  Options _getOptions() {
    return null;
  }
}