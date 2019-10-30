import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/entity/home_article_entity.dart';
import 'package:play_android/http/HttpRequest.dart';

import '../../Api.dart';
import '../../r.dart';
import '../BrowserPage.dart';

///广场页面
class SquarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SquarePageState();
  }
}

class SquarePageState extends State<SquarePage> {
  int currentPage = 0; //第一页
  List<HomeArticleEntity> articleList = new List();

  @override
  void initState() {
    super.initState();
    loadArticleData();
  }

  //  加载文章
  loadArticleData() async {
    HttpRequest.getInstance().get("${Api.USER_ARTICLE_LIST}$currentPage/json",
        successCallBack: (data) {
      Map<String, dynamic> dataJson = json.decode(data);
      List responseJson = json.decode(json.encode(dataJson["datas"]));
      print(responseJson.runtimeType);
      List<HomeArticleEntity> cardbeanList =
          responseJson.map((m) => new HomeArticleEntity.fromJson(m)).toList();
      setState(() {
        articleList.addAll(cardbeanList);
      });
    }, errorCallBack: (code, msg) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("广场"),
          centerTitle: true,
          backgroundColor: Color(0xff4282f4),
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
            currentPage = 0;
            loadArticleData();
          },
          onLoad: () async {
            currentPage++;
            loadArticleData();
          },
        ));
  }

  //列表的item
  renderRow(index, context) {
    var article = articleList[index];
    return new Container(
        child: new InkWell(
      onTap: () => {
        Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
          return new Browser(
            url: article.link,
            title: article.title,
            id: article.id,
          );
        }))
      },
      child: new Column(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.all(ScreenUtil.getInstance().setWidth(45)),
            child: new Column(
              children: <Widget>[
                new Row(
                  children: <Widget>[
                    article.fresh == true
                        ? new Text(
                            "新 ",
                            style: new TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(35),
                                color: const Color(0xFF4282f4)),
                          )
                        : new Container(),
                    new Expanded(
                      child: new Text(
                        article.author.isEmpty
                            ? article.shareUser
                            : article.author,
                        style: new TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(35),
                            color: const Color(0xFF6e6e6e)),
                      ),
                    ),
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
                    new Expanded(
                      child: new Text(
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: new TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(40),
                            color: Color(0xFF333333)),
                      ),
                    )
                  ],
                ),
                new Divider(
                  height: ScreenUtil.getInstance().setWidth(30),
                  color: Colors.transparent,
                ),
                new Row(
                  children: <Widget>[
                    new Text(
                      article.superChapterName,
                      style: new TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(32),
                          color: const Color(0xFF999999)),
                    ),
                    new Text(" • ",
                        style: new TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(32),
                            color: const Color(0xFF999999))),
                    new Expanded(
                      child: new Text(article.chapterName,
                          style: new TextStyle(
                              fontSize: ScreenUtil.getInstance().setSp(32),
                              color: const Color(0xFF999999))),
                    ),
                    new GestureDetector(
                      onTap: () => {
                        HttpRequest.getInstance().post(
                            article.collect == false
                                ? "${Api.COLLECT}${article.id}/json"
                                : "${Api.UN_COLLECT_ORIGIN_ID}${article.id}/json",
                            successCallBack: (data) {
                          setState(() {
                            article.collect = !article.collect;
                          });
                        }, errorCallBack: (code, msg) {}, context: context)
                      },
                      child: new Image(
                        image: article.collect == false
                            ? AssetImage(R.assetsImgZan0)
                            : AssetImage(R.assetsImgZan1),
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
