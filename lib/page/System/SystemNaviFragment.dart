import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/entity/system_navi_entity.dart';
import 'package:play_android/http/HttpRequest.dart';

import '../../Api.dart';
import '../BrowserPage.dart';

class SystemNaviFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SystemNaviFragmentState();
  }
}

class SystemNaviFragmentState extends State<SystemNaviFragment>
    with AutomaticKeepAliveClientMixin {
  List<SystemNaviEntity> dataList = [];

  @override
  void initState() {
    getData();
    super.initState();
  }

//  获取首页banner
  void getData() async {
    HttpRequest.getInstance().get(Api.NAVI, successCallBack: (data) {
      List responseJson = json.decode(data);
      setState(() {
        dataList =
            responseJson.map((m) => new SystemNaviEntity.fromJson(m)).toList();
      });
    }, errorCallBack: (code, msg) {});
  }

  List<Widget> getChildren() {
    List<Widget> children = [];
    for (int i = 0; i < dataList.length; i++) {
      children.add(new Row(
        children: <Widget>[
          new Text(
            dataList[i].name,
            style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(40)),
          )
        ],
      ));
      for (int j = 0; j < dataList[i].articles.length; j++) {
        children.add(new GestureDetector(
          onTap: () => {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return new Browser(
                url: dataList[i].articles[j].link,
                title: dataList[i].articles[j].title,
                id: dataList[i].articles[j].id,
              );
            }))
          },
          child: new Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenUtil.getInstance().setWidth(50),
                  ScreenUtil.getInstance().setWidth(20),
                  ScreenUtil.getInstance().setWidth(50),
                  ScreenUtil.getInstance().setWidth(20)),
              decoration: new BoxDecoration(
                border: new Border.all(color: Colors.transparent, width: 1),
                // 边色与边宽度
                color: Color(0xFFf5f5f5),
                borderRadius: new BorderRadius.circular(
                    (ScreenUtil.getInstance().setWidth(50))), // 圆角度
              ),
              child: new Text(
                dataList[i].articles[j].title,
                textAlign: TextAlign.center,
                style: new TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(36),
                    color: const Color(0xFF999999)),
              )),
        ));
      }
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(45)),
      child: Wrap(
        /**
         * 这里区分一下主轴和纵轴的概念：
         * 当水平方向的时候，其主轴就是水平，纵轴就是垂直。
         * 当垂直方向的时候，其主轴就是垂直，纵轴就是水平。
         */
        direction: Axis.horizontal,
        //不设置默认为horizontal
        alignment: WrapAlignment.start,
        //沿主轴方向居中
        spacing: 10.0,
        //主轴（水平）方向间距
        runSpacing: 10.0,
        //纵轴（垂直）方向间距
        children: getChildren(),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
