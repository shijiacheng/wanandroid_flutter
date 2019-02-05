import 'package:flutter/material.dart';
import '../api/common_service.dart';
import '../model/TodoListModel.dart';
import '../model/BaseModel.dart';
import '../utils/timeline_util.dart';
import 'TodoAddPageUI.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../common/Application.dart';
import '../event/event_config.dart';

class TodoPageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoPageUIState();
  }
}

class TodoPageUIState extends State<TodoPageUI> {
  List<TodoListDatas> _doneList = new List();
  List<TodoListDatas> _todoList = new List();

  List<TodoDataEntry> datas = new List();

  TodoDataEntry buildTree(List<TodoListDatas> _datas, String _title) {
    TodoDataEntry groupEntry = new TodoDataEntry();
    TodoData titleModel = new TodoData();
    titleModel.title = _title;
    groupEntry.data = titleModel;
    groupEntry.level = 1;
    List<TodoDataEntry> childrenEntry = new List();
    for (TodoListDatas _childModel in _datas) {
      TodoDataEntry _childTitleEntry = new TodoDataEntry();
      _childTitleEntry.level = 2;
      _childTitleEntry.data =
          TodoData.origin(TimelineUtil.format(_childModel.date));
      List<TodoDataEntry> _childEntry = new List();
      for (TodoData _childData in _childModel.todoList) {
        TodoDataEntry _childDataEntry = new TodoDataEntry();
        _childDataEntry.data = _childData;
        _childDataEntry.level = 3;
        _childDataEntry.children = [];
        _childEntry.add(_childDataEntry);
      }
      _childTitleEntry.children = _childEntry;
      childrenEntry.add(_childTitleEntry);
    }
    groupEntry.children = childrenEntry;
    return groupEntry;
  }

  Future<Null> _getData() async {
    CommonService().getTodoList((TodoListModel _model) {
      _doneList = _model.data.doneList;
      _todoList = _model.data.todoList;
      
      datas.clear();
      if(_todoList.length>0){
datas.add(buildTree(_todoList, "待办清单"));
      }
      if(_doneList.length>0){
        datas.add(buildTree(_doneList, "已完成清单"));
      }
      
      

      setState(() {});
    }, _currentType.type);
  }

  @override
  void initState() {
    super.initState();
    _currentType = _simpleValue1;
    _getData();
    registerThemeEvent();
  }

  void registerThemeEvent() {
    Application.eventBus
        .on<TodoChangeEvent>()
        .listen((TodoChangeEvent onData) => this.changeUI());
  }

  changeUI() async {
    _getData();
  }

  final FilterType _simpleValue1 = FilterType(0, '只用这一个');
  final FilterType _simpleValue2 = FilterType(1, '工作');
  final FilterType _simpleValue3 = FilterType(2, '学习');
  final FilterType _simpleValue4 = FilterType(3, '生活');
  FilterType _currentType;

  void showMenuSelection(FilterType value) {
    if (<FilterType>[_simpleValue1, _simpleValue2, _simpleValue3, _simpleValue4]
        .contains(value)) _currentType = value;
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: const Text('TODO'),
        elevation: 0.4,
      ),
      body: Column(
        children: <Widget>[
          PopupMenuButton<FilterType>(
              padding: EdgeInsets.zero,
              initialValue: _currentType,
              onSelected: showMenuSelection,
              child: ListTile(
                  title: Text(_currentType.text), subtitle: Text("点击切换分类"),
                  leading: Icon(Icons.apps),),
              itemBuilder: (BuildContext context) =>
                  <PopupMenuItem<FilterType>>[
                    PopupMenuItem<FilterType>(
                        value: _simpleValue1, child: Text(_simpleValue1.text)),
                    PopupMenuItem<FilterType>(
                        value: _simpleValue2, child: Text(_simpleValue2.text)),
                    PopupMenuItem<FilterType>(
                        value: _simpleValue3, child: Text(_simpleValue3.text)),
                    PopupMenuItem<FilterType>(
                        value: _simpleValue4, child: Text(_simpleValue4.text))
                  ]),
          
          Expanded(
            child: new ListView.builder(
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) =>
                  new EntryItem(context, datas[index]),
              itemCount: datas.length,
            ),
          )
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          onTodoAddClick(context, 0);
        },
        tooltip: '新增',
        child: new Icon(Icons.add),
      ),
    );
  }

  void onTodoAddClick(BuildContext context, int _type) async {
    await Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new TodoAddPageUI(
          data: null,
          type: _type,
        );
      },
      fullscreenDialog: true,
    ));
  }
}

class TodoDataEntry {
  TodoData data;
  int level;
  int type;//0:代办 1：已办
  List<TodoDataEntry> children;
}

class EntryItem extends StatefulWidget {
  const EntryItem(this.context, this.entry);

  final TodoDataEntry entry;
  final BuildContext context;

  @override
  State<StatefulWidget> createState() {
    return EntryItemState();
  }
}

class EntryItemState extends State<EntryItem> {
  Widget _buildTiles(TodoDataEntry root) {
    if (root.children.isEmpty)
      return new Slidable(
        delegate: new SlidableDrawerDelegate(),
        actionExtentRatio: 0.25,
        child: InkWell(
          child: Container(
            padding: EdgeInsets.all(16),
            alignment: Alignment.centerLeft,
            child: new Text(root.data.title),
            color: Colors.white,
          ),
          onTap: ()=> onTodoEditClick(context, root.data, 0),
        ),
        actions: <Widget>[
          new IconSlideAction(
            caption: '完成',
            icon: Icons.update,
            color: Colors.blue,
            onTap: () {
              int _status = 0;
              if (root.data.status == 0) {
                _status = 1;
              }
              _updateTodo(root.data.id, _status);
            },
          ),
        ],
        secondaryActions: <Widget>[
          new IconSlideAction(
            caption: '删除',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              _deleteTodo(root.data.id);
            },
          ),
        ],
      );
    // return new ListTile(title: new Text(root.data.title));
    return new ExpansionTile(
      leading: root.level == 1?Icon(Icons.local_post_office):null,
      key: new PageStorageKey<TodoDataEntry>(root),
      initiallyExpanded: true,
      title: new Text(root.data.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(widget.entry);
  }

  void onTodoEditClick(BuildContext context, TodoData _item, int _type) async {
    await Navigator.of(context).push(new MaterialPageRoute(
      builder: (context) {
        return new TodoAddPageUI(
          data: _item,
          type: _type,
        );
      },
      fullscreenDialog: true,
    ));
  }

  Future<Null> _deleteTodo(int _id) async {
    CommonService().deleteTodoData((BaseModel _baseModel) {
      if (_baseModel.errorCode == 0) {}
      setState(() {
         Application.eventBus.fire(new TodoChangeEvent());
      });
    }, _id);
  }

  Future<Null> _updateTodo(int _id, int _status) async {
    CommonService().doneTodoData((BaseModel _baseModel) {
      if (_baseModel.errorCode == 0) {}
      setState(() {
        Application.eventBus.fire(new TodoChangeEvent());
      });

    }, _id, _status);
  }
}

class FilterType {
  FilterType(this.type, this.text);
  int type;
  String text;
}
