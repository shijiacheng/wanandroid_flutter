import 'package:flutter/material.dart';
import 'SearchHotPageUI.dart';
import 'SearchResultPageUI.dart';

class SearchPageUI extends StatefulWidget {

  String searchStr;

  SearchPageUI(this.searchStr);

  @override
  State<StatefulWidget> createState() {
    return new SearchPageState(searchStr);
  }
}

class SearchPageState extends State<SearchPageUI> {
  TextEditingController _searchController = new TextEditingController();

  SearchResultPageUI _searchListPage;
  String searchStr ;
  SearchPageState(this.searchStr);

  @override
  void initState() {
    super.initState();

    _searchController = new TextEditingController(text: searchStr);
    changeContent();
  }



  void changeContent(){
    setState(() {
      _searchListPage = new SearchResultPageUI(new ValueKey(_searchController.text));
    });
  }
  @override
  Widget build(BuildContext context) {
    TextField searchField = new TextField(
      autofocus: true,
      decoration: new InputDecoration(
        border: InputBorder.none,
        hintText: '搜索关键词',
        hintStyle: TextStyle(color: Colors.white70)
      ),
      controller: _searchController,
      style: TextStyle(color: Colors.white),
    );




    return new Scaffold(
      appBar: new AppBar(
        title: searchField,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                changeContent();
              }),
          new IconButton(
              icon: new Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _searchController.clear();
                });

              }),
        ],
      ),
      body: (_searchController.text==null||_searchController.text.isEmpty)?new Center(
        child:new  SearchHotPageUI(),
      ):_searchListPage,
//    body: Center(
//      child: SearchHotPageUI(),
//    ),

    );
  }
}