import 'package:flutter/material.dart';
import '../api/common_service.dart';
import '../model/BaseModel.dart';

class CollectionAddPageUI extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CollectionAddPageUIState();
  }
}

class CollectionAddPageUIState extends State<CollectionAddPageUI> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _linkController = TextEditingController();

  Future<Null> _addCollection() async {
    String _title = _titleController.text;
    String _author = _authorController.text;
    String _link = _linkController.text;
    CommonService().addCollection((BaseModel _baseModel) {
      if (_baseModel.errorCode == 0) {
        Navigator.of(context).pop();
      }
    }, _title, _author, _link);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("新增收藏"), elevation: 0.4, actions: <Widget>[
          FlatButton(
              child: Text('保存'),
              onPressed: () {
                _addCollection();
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
                    labelStyle: TextStyle(color: Colors.black54, fontSize: 16)),
                maxLines: 2,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _authorController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 0.2)),
                    hintText: '',
                    labelText: '请输入作者',
                    labelStyle: TextStyle(color: Colors.black54, fontSize: 16)),
                maxLines: 1,
              ),
              const SizedBox(height: 24.0),
              TextFormField(
                controller: _linkController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.black26, width: 0.2)),
                    hintText: '',
                    labelText: '请输入链接地址',
                    labelStyle: TextStyle(color: Colors.black54, fontSize: 16)),
                maxLines: 2,
              ),
            ],
          ),
        ));
  }
}
