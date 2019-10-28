import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/entity/rank_entity.dart';
import 'package:play_android/http/HttpRequest.dart';

import '../../Api.dart';

///积分排行榜
class RankPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RankPageState();
  }
}

class RankPageState extends State<RankPage> {
  List<RankEntity> rankList = [];
  int currentPage = 1;

  //  加载文章
  loadArticleData() async {
    HttpRequest.getInstance().get("${Api.COIN_RANK}$currentPage/json",
        successCallBack: (data) {
      Map<String, dynamic> dataJson = json.decode(data);
      List responseJson = json.decode(json.encode(dataJson["datas"]));
      List<RankEntity> cardbeanList =
          responseJson.map((m) => new RankEntity.fromJson(m)).toList();
      setState(() {
        rankList.addAll(cardbeanList);
      });
    }, errorCallBack: (code, msg) {});
  }

  @override
  void initState() {
    super.initState();
    loadArticleData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("积分排行榜"),
        backgroundColor: Color(0xff4282f4),
      ),
      body: EasyRefresh(
        child: ListView.builder(
            itemCount: rankList.length,
            itemBuilder: (context, index) {
              return renderRow(index, context);
            }),
        onRefresh: () async {
          rankList.clear();
          currentPage = 1;
          loadArticleData();
        },
        onLoad: () async {
          currentPage++;
          loadArticleData();
        },
      ),
    );
  }

  //列表的item
  renderRow(index, context) {
    var rankItem = rankList[index];
    double progress = 1.0*rankItem.coinCount/rankList[0].coinCount;
    print("进度：${rankList[0].coinCount}");
    return new Container(
        child: new Stack(
      children: <Widget>[
        Container(
          height: ScreenUtil.getInstance().setWidth(185),
          child: LinearProgressIndicator(
            value: progress,
            valueColor: new AlwaysStoppedAnimation<Color>(Color(0xffecf3fe)),
            backgroundColor: Colors.white,
          ),
        ),
        Row(
          children: <Widget>[

          ],
        )
      ],
    ));
  }
}
