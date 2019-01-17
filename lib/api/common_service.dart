import 'Api.dart';
import 'package:dio/dio.dart';
import '../net/dio_manager.dart';
import '../model/BannerModel.dart';

class CommonService{
  void getBanner(Function callback) async {
    DioManager.singleton.dio.get(Api.HOME_BANNER, options: _getOptions()).then((response) {
      callback(BannerModel(response.data));
    });
  }

  Options _getOptions() {
    return null;
  }
}