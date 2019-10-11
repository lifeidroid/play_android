import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/entity/home_article_entity.dart';
import 'package:play_android/http/HttpRequest.dart';

import '../../r.dart';

class GongzhListFragment extends StatefulWidget {
  int _Id;

  GongzhListFragment(this._Id);

  @override
  State<StatefulWidget> createState() {
    return GongzhListFragmentState(_Id);
  }
}

class GongzhListFragmentState extends State<GongzhListFragment>
    with AutomaticKeepAliveClientMixin {
  int _Id;
  int currentPage = 0; //第一页
  List<HomeArticleEntity> articleList = new List();

  GongzhListFragmentState(this._Id);

  @override
  void initState() {
    super.initState();
    loadArticleData();
  }

  //  加载文章
  loadArticleData() async {
    HttpRequest.get("wxarticle/list/$_Id/$currentPage/json", null, (data) {
      Map<String, dynamic> dataJson = json.decode(data);
      List responseJson = json.decode(json.encode(dataJson["datas"]));
      print(responseJson.runtimeType);
      List<HomeArticleEntity> cardbeanList =
          responseJson.map((m) => new HomeArticleEntity.fromJson(m)).toList();
      setState(() {
        articleList.addAll(cardbeanList);
      });
    }, (code, msg) {});
  }

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
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
    );
  }

  //列表的item
  renderRow(index, context) {
    var article = articleList[index];
    return new Container(
        color: Colors.white,
        child: new InkWell(
          onTap: () {},
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
                        new Image(
                          image: article.zan == 0
                              ? AssetImage(R.assetsImgZan0)
                              : AssetImage(R.assetsImgZan1),
                          width: ScreenUtil.getInstance().setWidth(66),
                          height: ScreenUtil.getInstance().setWidth(66),
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

  @override
  bool get wantKeepAlive => true;
}
