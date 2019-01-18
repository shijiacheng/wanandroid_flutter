import 'package:flutter/material.dart';
import '../utils/route_util.dart';

/// 关于APP页面
class AboutAppPageUI extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("关于App"),
        elevation: 0.4,
      ),
      body: Scrollbar(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text("网站内容",style: titleStyle,),

                      Text("    本网站每天新增20~30篇优质文章，并加入到现有分类中，力求整理出一份优质而又详尽的知识体系，闲暇时间不妨上来学习下知识； 除此以外，并为大家提供平时开发过程中常用的工具以及常用的网址导航。",style: contentStyle,),

                      Text("    当然这只是我们目前的功能，未来我们将提供更多更加便捷的功能...",style: contentStyle,),

                      Text('''
如果您有任何好的建议:
  —关于网站排版
  —关于新增常用网址以及工具
  —未来你希望增加的功能等
可以在 https://github.com/hongyangAndroid/xueandroid 项目中以issue的形式提出，我将及时跟进。''',style: contentStyle,),

                      Text("    如果您希望长期关注本站，可以加入我们的QQ群：591683946",style: contentStyle,),

                      SizedBox(
                        height: 10,
                      ),
                      Text("关于App",style: titleStyle),

                      Text("    本应用是使用Flutter开发的WanAndroid网站的Android客户端，由于初入Flutter，难免有bug，如果你发现任何问题，不要犹豫，马上在issue中提交。你的关注是我前进的动力！",style: contentStyle,),

                    ],
                  ),
                ),

                ListTile(
                  title: Text("版本"),
                  subtitle: Text("当前版本 0.1.0"),
                ),
                ListTile(
                  title: Text("更新日志"),
                  subtitle: Text("暂无"),
                ),
                ListTile(
                  title: Text("源代码"),
                  subtitle: Text("https://github.com/shijiacheng/wanandroid_flutter"),
                  onTap: (){
                    RouteUtil.toWebView(context, "github.com/shijiacheng", "https://github.com/shijiacheng/wanandroid_flutter");
                  },
                ),
                ListTile(
                  title: Text("版权声明"),
                  subtitle: Text("个人用户，请勿用在商业用途"),
                )
              ],
            ),
          )
      ),
    );
  }

  TextStyle titleStyle = TextStyle(
      fontSize: 18,fontWeight: FontWeight.bold
  );
  TextStyle contentStyle = TextStyle(
      fontSize: 16,
  );
}