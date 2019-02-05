import 'package:flutter/material.dart';
import '../api/common_service.dart';
import '../model/BaseModel.dart';
import '../model/WebsiteCollectionModel.dart';

class WebsiteCollectionAddPageUI extends StatefulWidget {

  final WebsiteCollectionData website;

  WebsiteCollectionAddPageUI({Key key, @required this.website}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WebsiteCollectionAddPageUIState();
  }
}

class WebsiteCollectionAddPageUIState extends State<WebsiteCollectionAddPageUI> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _linkController = TextEditingController();

  Future<Null> _addWebsiteCollection() async {
    String _title = _titleController.text;
    String _link = _linkController.text;
    CommonService().addWebsiteCollectionList((BaseModel _baseModel) {
      if (_baseModel.errorCode == 0) {
        Navigator.of(context).pop();
      }
    }, _title, _link);
  }

  Future<Null> _editWebsiteCollection() async {
    String _title = _titleController.text;
    String _link = _linkController.text;
    CommonService().editWebsiteCollectionList((BaseModel _baseModel) {
      if (_baseModel.errorCode == 0) {
        Navigator.of(context).pop();
      }
    }, widget.website.id,_title, _link);
  }

  @override
  void initState() {
    super.initState();
    if(widget.website!=null){
      _titleController.text = widget.website.name;
      _linkController.text = widget.website.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("新增网站"), elevation: 0.4, actions: <Widget>[
          FlatButton(
              child: Text('保存'),
              onPressed: () {
                if(widget.website!=null){
                  _editWebsiteCollection();
                }else{
                  _addWebsiteCollection();
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
                    labelText: '请输入网站名称',
                    labelStyle: TextStyle(color: Colors.black54, fontSize: 16),),
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
                maxLines: 1,
              ),
            ],
          ),
        ));
  }
}
