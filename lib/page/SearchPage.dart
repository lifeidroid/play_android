import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///搜索页面
class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  var isSearch = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff4282f4),
          leading: new InkWell(
            child: new Icon(Icons.arrow_back),
            onTap: () {
              if (isSearch) {
                setState(() {
                  isSearch = false;
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          title: Container(
            padding: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            height: ScreenUtil.getInstance().setWidth(100),
            decoration: new BoxDecoration(
                color: Color(0xff3e79e4),
                borderRadius: new BorderRadius.circular(
                    ScreenUtil.getInstance().setWidth(40))),
            child: new TextFormField(
              decoration: InputDecoration.collapsed(
                  hintText: '用空格隔开多个关键词',
                  hintStyle: TextStyle(color: Color(0xffa5c0f2))),
              style: TextStyle(color: Colors.white),
            ),
          ),
          actions: <Widget>[
            new InkWell(
              child: Padding(
                padding: EdgeInsets.only(
                    right: ScreenUtil.getInstance().setWidth(50)),
                child: Center(
                  child: Text("搜索"),
                ),
              ),
              onTap: (){
                setState(() {
                  isSearch = true;
                });
              },
            )
          ],
        ),
        body: isSearch ? Text("搜索结果") : Text("搜索前"));
  }
}
