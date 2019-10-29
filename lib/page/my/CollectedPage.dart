import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/entity/collect_entity.dart';
import 'package:play_android/http/HttpRequest.dart';

import '../../Api.dart';
import '../../r.dart';
import '../BrowserPage.dart';

//收藏列表
class CollectedPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CollectedPageState();
  }
}

class CollectedPageState extends State<CollectedPage> {
  int currentPage = 1; //第一页
  List<CollectEntity> articleList = new List();

  @override
  void initState() {
    super.initState();
    loadArticleData();
  }

  //  加载文章
  loadArticleData() async {
    HttpRequest.getInstance().get("${Api.COLLECT_LIST}$currentPage/json",
        successCallBack: (data) {
      Map<String, dynamic> dataJson = json.decode(data);
      List responseJson = json.decode(json.encode(dataJson["datas"]));
      List<CollectEntity> cardbeanList =
          responseJson.map((m) => new CollectEntity.fromJson(m)).toList();
      setState(() {
        articleList.addAll(cardbeanList);
      });
    }, errorCallBack: (code, msg) {},context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4282f4),
        title: Text(
          "我的收藏",
          style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(45)),
        ),
        centerTitle: true,
      ),
      body: EasyRefresh(
        child: ListView.builder(
            itemCount: articleList.length,
            itemBuilder: (context, index) {
              return renderRow(index, context);
            }),
//      header: MaterialHeader(),
//      footer: MaterialFooter(),
        onRefresh: () async {
          articleList.clear();
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
    var article = articleList[index];
    return new Container(
        color: Colors.white,
        child: new InkWell(
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return new Browser(
                url: article.link,
                title: article.title,
                id: article.id,
              );
            }));
          },
          child: new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.all(ScreenUtil.getInstance().setWidth(45)),
                child: new Column(
                  children: <Widget>[
                    new Row(
                      children: <Widget>[
                        new Expanded(
                            child: new Text(
                          article.author,
                          style: new TextStyle(
                              fontSize: ScreenUtil.getInstance().setSp(32),
                              color: const Color(0xFF6e6e6e)),
                        )),
                        new Text(
                          article.niceDate,
                          style: new TextStyle(
                              fontSize: ScreenUtil.getInstance().setSp(32),
                              color: const Color(0xFF999999)),
                        )
                      ],
                    ),
                    new Divider(
                      height: ScreenUtil.getInstance().setWidth(30),
                      color: Colors.transparent,
                    ),
                    new Row(
                      children: <Widget>[
                        article.envelopePic != ""
                            ? new Container(
                                child: new Image(
                                    image: NetworkImage(article.envelopePic),
                                    width:
                                        ScreenUtil.getInstance().setWidth(330),
                                    fit: BoxFit.fitWidth,
                                    height:
                                        ScreenUtil.getInstance().setWidth(220)),
                                margin: EdgeInsets.only(
                                    right:
                                        ScreenUtil.getInstance().setWidth(30)),
                              )
                            : new Container(),
                        new Expanded(
                          child: new Text(
                            article.title,
                            maxLines: 2,
                            softWrap: false,
                            //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                            overflow: TextOverflow.ellipsis,
                            style: new TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(40),
                                color: Color(0xFF333333)),
                          ),
                        ),
                      ],
                    ),
                    new Divider(
                      height: ScreenUtil.getInstance().setWidth(30),
                      color: Colors.transparent,
                    ),
                    new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Text(article.chapterName,
                              style: new TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(32),
                                  color: const Color(0xFF999999))),
                        ),
                        new GestureDetector(
                          onTap: () => {
                            HttpRequest.getInstance().post(
                                "${Api.UN_COLLECT_ORIGIN_ID}${article.originId}/json",
                                successCallBack: (data) {
                              setState(() {
                                articleList.removeAt(index);
                              });
                            }, errorCallBack: (code, msg) {})
                          },
                          child: new Image(
                            image: AssetImage(R.assetsImgZan1),
                            width: ScreenUtil.getInstance().setWidth(66),
                            height: ScreenUtil.getInstance().setWidth(66),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              //分割线
              new Divider(height: 1)
            ],
          ),
        ));
  }
}
