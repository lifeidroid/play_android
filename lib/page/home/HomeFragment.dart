import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:play_android/Api.dart';
import 'package:play_android/entity/banner_entity.dart';
import 'package:play_android/entity/home_article_entity.dart';
import 'package:play_android/http/HttpRequest.dart';
import 'package:play_android/page/home/SearchPage.dart';
import 'package:play_android/page/home/SquarePage.dart';
import 'package:play_android/r.dart';

import '../BrowserPage.dart';

class HomeFragment extends StatefulWidget {
  //滚动Banner图
  List<BannerEntity> bannerList = [];
  SwiperController _swiperController;

  @override
  State<StatefulWidget> createState() {
    return new HomeFragmentState();
  }
}

class HomeFragmentState extends State<HomeFragment>
    with AutomaticKeepAliveClientMixin {
  List<HomeArticleEntity> articleList = new List();
  int currentPage = 0; //第一页
  SwiperController _swiperController;
  List<BannerEntity> bannerList = [];

//  加载置顶文章
  loadTopData() async {
    HttpRequest.getInstance().get(Api.ARTICLE_TOP, successCallBack: (data) {
      List responseJson = json.decode(data);
      List<HomeArticleEntity> cardbeanList =
          responseJson.map((m) => new HomeArticleEntity.fromJson(m)).toList();
      articleList.addAll(cardbeanList);
      loadArticleData();
    }, errorCallBack: (code, msg) {});
  }

//  加载文章
  loadArticleData() async {
    HttpRequest.getInstance().get("${Api.ARTICLE_LIST}$currentPage/json",
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

//  获取首页banner
  void getBanner() async {
    HttpRequest.getInstance().post(Api.BANNER, successCallBack: (data) {
      print(data);
      List responseJson = json.decode(data);
      List<BannerEntity> cardbeanList =
          responseJson.map((m) => new BannerEntity.fromJson(m)).toList();
      setState(() {
        bannerList.clear();
        bannerList.addAll(cardbeanList);
      });
    }, errorCallBack: (code, msg) {});
  }

  @override
  void initState() {
    super.initState();
    getBanner();
    _swiperController = new SwiperController();
    _swiperController.startAutoplay();
    //加载第一页数据
    loadTopData();
  }

  @override
  void dispose() {
    _swiperController.stopAutoplay();
    _swiperController.dispose();
    super.dispose();
  }

  Widget _swiperBuilder(BuildContext context, int index) {
    return (Image.network(
      bannerList[index].imagePath,
      fit: BoxFit.fill,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
        backgroundColor: Color(0xff4282f4),
        centerTitle: true,
        actions: <Widget>[
          new InkWell(
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(55)),
              child: new Image(
                image: AssetImage(R.assetsImgIcSearch),
              ),
            ),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                return SearchPage();
              }));
            },
          ),
        ],
        leading: new InkWell(
          child: Padding(
            padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(55)),
            child: new Image(
              image: AssetImage(R.assetsImgIcArticle),
            ),
          ),
          onTap: () {
            Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
              return SquarePage();
            }));
          },
        ),
      ),
      body: EasyRefresh(
        child: ListView.builder(
            itemCount: articleList.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    height: ScreenUtil.getInstance().setWidth(600),
                    child: Swiper(
                      itemBuilder: _swiperBuilder,
                      itemCount: bannerList.length,
                      loop: false,
                      autoplay: false,
                      controller: _swiperController,
                      pagination: new SwiperPagination(
                          builder: DotSwiperPaginationBuilder(
                        color: Colors.black54,
                        activeColor: Colors.white,
                      )),
                      control: new SwiperControl(),
                      scrollDirection: Axis.horizontal,
                      onTap: (index) => {
                        Navigator.of(context)
                            .push(new MaterialPageRoute(builder: (_) {
                          return new Browser(
                              url: articleList[index].link,
                              title: articleList[index].title,
                              id: articleList[index].id);
                        }))
                      },
                    ));
              } else {
                return renderRow(index - 1, context);
              }
            }),
//      header: MaterialHeader(),
//      footer: MaterialFooter(),
        onRefresh: () async {
          articleList.clear();
          currentPage = 0;
          loadTopData();
        },
        onLoad: () async {
          currentPage++;
          loadArticleData();
        },
      ),
    );
  }

  List<Widget> getTags(HomeArticleEntity entity) {
    List<Widget> tags = [];
    for (int i = 0; i < entity.tags.length; i++) {
      tags.add(new Container(
          margin: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(15)),
          decoration: new BoxDecoration(
            border: new Border.all(color: Color(0xFF4282f4), width: 1),
            // 边色与边宽度
            color: Colors.transparent,
            borderRadius: new BorderRadius.circular((2.0)), // 圆角度
          ),
          child: new Text(
            entity.tags[i].name,
            style: new TextStyle(
                fontSize: ScreenUtil.getInstance().setSp(32),
                color: const Color(0xFF4282f4)),
          )));
    }
    return tags;
  }

  //列表的item
  renderRow(index, context) {
    var article = articleList[index];
    return new Container(
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
                    article.type == 1
                        ? new Text(
                            "置顶•",
                            style: new TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(32),
                                color: const Color(0xFFf86734)),
                          )
                        : new Container(),
                    article.fresh == true
                        ? new Text(
                            "新•",
                            style: new TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(32),
                                color: const Color(0xFF4282f4)),
                          )
                        : new Container(),
                    new Text(
                      article.author,
                      style: new TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(32),
                          color: const Color(0xFF6e6e6e)),
                    ),
                    new Expanded(
                        child: article.tags.length == 0
                            ? new Container()
                            : new Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: getTags(article),
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
                                width: ScreenUtil.getInstance().setWidth(330),
                                fit: BoxFit.fitWidth,
                                height: ScreenUtil.getInstance().setWidth(220)),
                            margin: EdgeInsets.only(
                                right: ScreenUtil.getInstance().setWidth(30)),
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

  @override
  bool get wantKeepAlive => true;
}
