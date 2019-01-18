import 'package:flutter/material.dart';
import '../model/ProjectListModel.dart';
import '../model/ProjectTreeModel.dart';
import '../utils/timeline_util.dart';
import 'WebViewPageUI.dart';
import '../api/common_service.dart';

class ProjectTreePageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyTabbedPageState();
  }
}

class _MyTabbedPageState extends State<ProjectTreePageUI>
    with TickerProviderStateMixin {

  List<ProjectTreeData> _datas = new List();
  TabController _tabController;

  Future<Null> _getData() async {
    CommonService().getProjectTree((ProjectTreeModel _projectTreeModel){
      setState(() {
        _datas = _projectTreeModel.data;
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
          tabs: _datas.map((ProjectTreeData item) {
            return Tab(
              text: item.name,
            );
          }).toList(),
          isScrollable:
              true, //水平滚动的开关，开启后Tab标签可自适应宽度并可横向拉动，关闭后每个Tab自动压缩为总长符合屏幕宽度的等宽，默认关闭
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: _datas.map((item) {
          return NewsList(
            id: item.id,
          );
        }).toList(),
      ),
    );
  }
}

class NewsList extends StatefulWidget {
  final int id;
  @override
  NewsList({Key key, this.id}) : super(key: key);

  _NewsListState createState() => new _NewsListState();
}

class _NewsListState extends State<NewsList> {
  List<ProjectTreeListDatas> _datas = new List();
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

  Future<Null> _getData() async {
    _page = 1;
    int _id = widget.id;
    CommonService().getProjectList((ProjectTreeListModel _projectTreeListModel){
      setState(() {
        _datas = _projectTreeListModel.data.datas;
      });
    }, _page, _id);
  }

  Future<Null> _getMore() async {
    _page++;
    int _id = widget.id;
    CommonService().getProjectList((ProjectTreeListModel _projectTreeListModel){
      setState(() {
        _datas.addAll(_projectTreeListModel.data.datas);
      });
    }, _page, _id);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        onRefresh: _getData,
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
      return _itemView(context, index);
    }
    return _getMoreWidget();
  }

  Widget _itemView(BuildContext context, int index) {
    return InkWell(
      child: _newsRow(_datas[index]),
      onTap: () {
        _onItemClick(_datas[index]);
      },
    );
  }

  void _onItemClick(ProjectTreeListDatas itemData) async {
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

  Widget _newsRow(ProjectTreeListDatas item) {
    return new Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.fromLTRB(8, 16, 8, 8),
            child: Image.network(
              item.envelopePic,
              width: 80,
              height: 120,
              fit: BoxFit.fill,
            )),
        Expanded(
          child: new Column(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        item.title,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ))
                    ],
                  )),
              Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        item.desc,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.left,
                        maxLines: 3,
                      ))
                    ],
                  )),
              new Container(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        item.author,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      new Expanded(
                        child: new Text(
                          TimelineUtil.format(item.publishTime),
                          style: TextStyle(fontSize: 12, color: Colors.grey),
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

  Widget _getMoreWidget() {
    return Container(
      padding: EdgeInsets.all(16),
      alignment: Alignment.center,
      child: SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
