import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/entity/home_article_entity.dart';
import 'package:play_android/entity/hot_key_entity.dart';
import 'package:play_android/http/HttpRequest.dart';
import 'package:play_android/widget/T.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../Config.dart';
import '../../r.dart';
import '../BrowserPage.dart';

///搜索页面
class SearchPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchPageState();
  }
}

class SearchPageState extends State<SearchPage> {
  var isSearch = false;

  //热门搜索
  List<String> hotSearch = [];

  //搜索历史
  List<String> searchHistory = [];

  //搜索字
  String searchKey = null;

  //当前页码
  int currentPage = 1; //第一页

  //搜索结果
  List<HomeArticleEntity> articleList = new List();

  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initHotSearch();
    initSearchHistory();
  }

  void initHotSearch() {
    HttpRequest.getInstance().get(Api.HOT_KEY, successCallBack: (data) {
      List responseJson = json.decode(data);
      List<HotKeyEntity> hotKeyList =
          responseJson.map((m) => new HotKeyEntity.fromJson(m)).toList();
      setState(() {
        hotSearch.clear();
        for (var i = 0; i < hotKeyList.length; i++) {
          hotSearch.add(hotKeyList[i].name);
        }
      });
    }, errorCallBack: (code, msg) {});
  }

  ///初始化历史搜索
  void initSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String history = prefs.getString(Config.SP_SEARCH_HISTORY);
    if (null != history && history.isNotEmpty) {
      setState(() {
        searchHistory = history.split(",");
      });
    }
  }

  ///添加新的历史搜索
  void addSearchHistory(String key) async {
    if (searchHistory.contains(key)) {
      searchHistory.remove(key);
    }
    searchHistory.add(key);
    String result = "";
    for (var i = 0; i < searchHistory.length; i++) {
      result += searchHistory[i];
      if (i + 1 != searchHistory.length) {
        result += ",";
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Config.SP_SEARCH_HISTORY, result);
  }

  ///清空历史搜索
  void clearHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(Config.SP_SEARCH_HISTORY);
    setState(() {
      searchHistory.clear();
    });
  }

  void doSearch() {
    var data;
    data = {'k': searchKey};
    HttpRequest.getInstance().post(Api.QUERY.replaceAll("0", "${currentPage}"),
        data: data, successCallBack: (data) {
      Map<String, dynamic> dataJson = json.decode(data);
      List responseJson = json.decode(json.encode(dataJson["datas"]));
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
          centerTitle: true,
          backgroundColor: Color(0xff4282f4),
          leading: new InkWell(
            child: new Icon(Icons.arrow_back),
            onTap: () {
              if (isSearch) {
                articleList.clear();
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
              cursorColor: Colors.white,
              decoration: InputDecoration.collapsed(
                  hintText: '用空格隔开多个关键词',
                  hintStyle: TextStyle(
                      color: Color(0xffa5c0f2),
                      fontSize: ScreenUtil.getInstance().setSp(40))),
              style: TextStyle(color: Colors.white),
              controller: controller,
              onChanged: (val) {
                searchKey = val;
              },
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
              onTap: () {
                setState(() {
                  if (null != searchKey && searchKey.isNotEmpty) {
                    searchClick();
                  } else {
                    T.showToast("请输入关键字");
                  }
                });
              },
            )
          ],
        ),
        body: WillPopScope(
          onWillPop: () {
            if (isSearch) {
              articleList.clear();
              setState(() {
                isSearch = false;
              });
            } else {
              Navigator.of(context).pop();
            }
          },
          child: isSearch ? getSearchAfter() : getSearchBefore(),
        ));
  }

  void searchClick() {
    currentPage = 1;
    isSearch = true;
    addSearchHistory(searchKey);
    articleList.clear();
    doSearch();
  }

  ///点击搜索按钮之前的页面
  Widget getSearchBefore() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(50)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:
                EdgeInsets.only(bottom: ScreenUtil.getInstance().setWidth(40)),
            child: Text(
              "热门搜索",
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(44),
                  color: Color(0xff4282f4)),
            ),
          ),
          Wrap(
            /**
             * 这里区分一下主轴和纵轴的概念：
             * 当水平方向的时候，其主轴就是水平，纵轴就是垂直。
             * 当垂直方向的时候，其主轴就是垂直，纵轴就是水平。
             *
             */
            direction: Axis.horizontal,
            //不设置默认为horizontal
            alignment: WrapAlignment.start,
            //沿主轴方向居中
            spacing: 10.0,
            //主轴（水平）方向间距
            runSpacing: 10.0,
            //纵轴（垂直）方向间距
            children: getChild(hotSearch),
          ),
          searchHistory.length == 0
              ? Container()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            bottom: ScreenUtil.getInstance().setWidth(40),
                            top: ScreenUtil.getInstance().setWidth(40)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "历史搜索",
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(44),
                                    color: Color(0xff4282f4)),
                              ),
                            ),
                            InkWell(
                              child: Text(
                                "清除",
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(36),
                                    color: Color(0xFF999999)),
                              ),
                              onTap: () {
                                clearHistory();
                              },
                            )
                          ],
                        )),
                    Wrap(
                      direction: Axis.horizontal,
                      //不设置默认为horizontal
                      alignment: WrapAlignment.start,
                      //沿主轴方向居中
                      spacing: 10.0,
                      //主轴（水平）方向间距
                      runSpacing: 10.0,
                      //纵轴（垂直）方向间距
                      children: getChild(searchHistory),
                    ),
                  ],
                )
        ],
      ),
    );
  }

  ///获取点击搜索按钮之后的页面
  Widget getSearchAfter() {
    return articleList.length == 0
        ? Center(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: AssetImage(R.assetsImgIcEmpty),
                width: ScreenUtil.getInstance().setWidth(200),
                height: ScreenUtil.getInstance().setWidth(200),
              ),
              Text(
                "什么都没有···",
                style: TextStyle(
                    color: Color(0xFF6e6e6e),
                    fontSize: ScreenUtil.getInstance().setSp(36)),
              )
            ],
          ))
        : EasyRefresh(
            child: ListView.builder(
                itemCount: articleList.length,
                itemBuilder: (context, index) {
                  return renderRow(index, context);
                }),
            onRefresh: () async {
              articleList.clear();
              currentPage = 1;
              doSearch();
            },
            onLoad: () async {
              currentPage++;
              doSearch();
            },
          );
  }

  //搜索结果列表的item
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
                          fontSize: ScreenUtil.getInstance().setSp(35),
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
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            article.title,
                            softWrap: false,
                            //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                            overflow: TextOverflow.ellipsis,
                            //文字超出屏幕之后的处理方式  TextOverflow.clip剪裁   TextOverflow.fade 渐隐  TextOverflow.ellipsis省略号
                            style: new TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(40),
                                color: Color(0xFF333333)),
                          ),
                          new Text(
                            article.desc,
                            softWrap: false,
                            maxLines: 3,
                            textAlign: TextAlign.start,
                            //文本对齐方式  居中
                            //是否自动换行 false文字不考虑容器大小  单行显示   超出；屏幕部分将默认截断处理
                            overflow: TextOverflow.ellipsis,
                            //文字超出屏幕之后的处理方式  TextOverflow.clip剪裁   TextOverflow.fade 渐隐  TextOverflow.ellipsis省略号
                            style: new TextStyle(
                                fontSize: ScreenUtil.getInstance().setSp(35),
                                color: Color(0xFF999999)),
                          ),
                        ],
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
                          fontSize: ScreenUtil.getInstance().setSp(35),
                          color: const Color(0xFF999999)),
                    ),
                    new Text(" • ",
                        style: new TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(35),
                            color: const Color(0xFF999999))),
                    new Expanded(
                      child: new Text(article.chapterName,
                          style: new TextStyle(
                              fontSize: ScreenUtil.getInstance().setSp(35),
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

  ///添加子项
  ///pEntity 父项
  ///index 子项在父项中的位置
  ///entity 子项
  List<Widget> getChild(List<String> datas) {
    List<Widget> children = [];
    for (var i = datas.length - 1; i >= 0; i--) {
      children.add(new InkWell(
        onTap: () =>
            {controller.text = datas[i], searchKey = datas[i], searchClick()},
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
              datas[i],
              textAlign: TextAlign.center,
              style: new TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(36),
                  color: const Color(0xFF999999)),
            )),
      ));
    }
    return children;
  }
}
