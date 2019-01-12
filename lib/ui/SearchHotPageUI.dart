import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../model/HotWordModel.dart';
import 'SearchPageUI.dart';

class SearchHotPageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new HotPageState();
  }
}

class HotPageState extends State<SearchHotPageUI> {
  List<Widget> hotkeyWidgets = new List();
  Dio dio;

  @override
  void initState() {
    super.initState();
    dio = new Dio();
    _getHotKey();
  }

  @override
  Widget build(BuildContext context) {
    return new ListView(
      children: <Widget>[
        new Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: new Text('大家都在搜',
                style: new TextStyle(
                    color: Colors.black, fontSize: 16))),
        new Padding(padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            alignment: WrapAlignment.start,
            children: hotkeyWidgets,
          )
        ),

      ],
    );
  }


  Future<Null> _getHotKey() async{
    Response response = await dio.get("http://www.wanandroid.com//hotkey/json");
    var hotWordModel = new HotWordModel(response.data);
    setState(() {
      List<HotWordData> datas = hotWordModel.data;
      hotkeyWidgets.clear();
      for (var value in datas) {
        Widget actionChip = new ActionChip(
            label: new Text(
              value.name,
            ),
            onPressed: () {
              Navigator
                  .of(context)
                  .pushReplacement(new MaterialPageRoute(builder: (context) {
                return new SearchPageUI(value.name);
              }));
            });

        hotkeyWidgets.add(actionChip);
      }
    });
  }

}