import 'package:flutter/material.dart';
import '../ui/WebViewPageUI.dart';

/// 路由工具类
class RouteUtil{

  ///跳转到webview打开
  static void toWebView(BuildContext context,String title,String link) async {
    await Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new WebViewPageUI(
        title: title,
        url: link,
      );
    }));
  }

  // 
  static Future push(BuildContext context, Widget widget) {
    Future result = Navigator.push(
        context, MaterialPageRoute(builder: (context) => widget));
    return result;
  }
}