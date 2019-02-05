import 'package:flutter/material.dart';
import '../api/common_service.dart';
import '../model/BaseModel.dart';
import '../model/TodoListModel.dart';

class TodoAddPageUI extends StatefulWidget {
  final TodoData data;
  final int type;

  TodoAddPageUI({Key key, @required this.data, @required this.type})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TodoAddPageUIState();
  }
}

class TodoAddPageUIState extends State<TodoAddPageUI> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  Future<Null> _addTodo() async {
    String _title = _titleController.text;
    String _content = _contentController.text;
    CommonService().addTodoData((BaseModel _baseModel) {
      if (_baseModel.errorCode == 0) {
        Navigator.of(context).pop();
      }
    }, _title, _content, "2019-02-02", widget.type);
  }

  Future<Null> _updateTodo() async {
    String _title = _titleController.text;
    String _content = _contentController.text;
    CommonService().updateTodoData((BaseModel _baseModel) {
      if (_baseModel.errorCode == 0) {
        Navigator.of(context).pop();
      }
    }, widget.data.id, _title, _content, "2019-02-02", widget.data.status,
        widget.type);
  }

  @override
  void initState() {
    super.initState();
    if (widget.data != null) {
      _titleController.text = widget.data.title;
      _contentController.text = widget.data.content;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("添加待办清单"), elevation: 0.4, actions: <Widget>[
          FlatButton(
              child: Text('保存'),
              onPressed: () {
                if (widget.data != null) {
                  _updateTodo();
                } else {
                  _addTodo();
                }
              })
        ]),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.black26, width: 0.2)),
                  hintText: '',
                  labelText: '请输入标题',
                  labelStyle: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 0.2)),
                    hintText: '',
                    labelText: '请输入详情',
                    labelStyle: TextStyle(color: Colors.black54, fontSize: 16)),
                maxLines: 3,
              ),
              const SizedBox(height: 24.0),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black26))),
                  child: InkWell(
                      onTap: () {
                        // 调用函数打开
                        showDatePicker(
                          context: context,
                          initialDate: new DateTime.now(),
                          firstDate: new DateTime.now(), // 减 30 天
                          lastDate: new DateTime.now()
                              .add(new Duration(days: 36)), // 加 30 天
                        ).then((DateTime val) {
                          print(val); // 2018-07-12 00:00:00.000
                        }).catchError((err) {
                          print(err);
                        });
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("时间"),
                            const Icon(Icons.arrow_drop_down,
                                color: Colors.black54),
                          ])))
            ],
          ),
        ));
  }
}
