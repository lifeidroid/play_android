import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/http/HttpRequest.dart';
import 'package:play_android/widget/T.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Api.dart';
import '../r.dart';

class Browser extends StatefulWidget {
  const Browser({Key key, this.url, this.title, this.id}) : super(key: key);

  final String url;
  final String title;
  final int id;

  @override
  State<StatefulWidget> createState() {
    return BrowserState(url, title, id);
  }
}

class BrowserState extends State<Browser> with TickerProviderStateMixin {
  final String url;
  String title;
  int id;
  WebViewController webViewController = null;

  //是否可以后退
  bool canGoBack = false;

  //是否可以前进
  bool canGoForward = false;

  //回到主页
  bool goHome = false;

  //是否正在加载
  bool loading = true;

  AnimationController controller;
  Animation<double> animation;

  BrowserState(this.url, this.title, this.id);

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(false);
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    animation = Tween(begin: 0.0, end: 2.0).animate(controller);
    //动画开始、结束、向前移动或向后移动时会调用StatusListener
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.reset(); //将动画重置到开始前的状态
        if (loading) {
          controller.forward();
        }
      }
    });
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xff4282f4),
            title: Text(
              title,
              style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(45)),
            ),
            centerTitle: true,
            leading: new InkWell(
              child: Padding(
                padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(55)),
                child: new Image(
                  image: AssetImage(R.assetsImgIcClose),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          body: Column(
            children: <Widget>[
              Expanded(
                child: WebView(
                  initialUrl: url,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController controller) {
                    webViewController = controller;
                  },
                  onPageFinished: (String value) {
                    if (goHome) {
                      if (url != value) {
                        webViewController.goBack();
                      } else {
                        goHome = false;
                      }
                    }
                    loading = false;
                    if (controller.isAnimating) {
                      controller.reset();
                    }
                    webViewController.getTitle().then((t) {
                      setState(() {
                        title = t;
                      });
                    });
                    webViewController.canGoBack().then((res) {
                      canGoBack = res;
                      setState(() {});
                    });
                    webViewController.canGoForward().then((res) {
                      canGoForward = res;
                      setState(() {});
                    });
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Color(0xfff7f7f7),
                ),
                height: ScreenUtil.getInstance().setWidth(145),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(
                              ScreenUtil.getInstance().setWidth(45)),
                          child: Image(
                            image: canGoBack
                                ? AssetImage(R.assetsImgIcBackB)
                                : AssetImage(R.assetsImgIcCloseB),
                          ),
                        ),
                        onTap: () {
                          webViewController.canGoBack().then((res) {
                            canGoBack = res;
                            if (res) {
                              webViewController.goBack();
                            } else {
                              Navigator.of(context).pop();
                            }
                          });
                        },
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(
                              ScreenUtil.getInstance().setWidth(45)),
                          child: Image(
                            image: canGoForward
                                ? AssetImage(R.assetsImgIcRightB)
                                : AssetImage(R.assetsImgIcRightG),
                          ),
                        ),
                        onTap: () {
                          webViewController.canGoForward().then((res) {
                            canGoBack = res;
                            if (res) {
                              webViewController.goForward();
                            }
                          });
                        },
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(
                              ScreenUtil.getInstance().setWidth(45)),
                          child: Image(
                            image: AssetImage(R.assetsImgIcMenuB),
                          ),
                        ),
                        onTap: () {
                          showBottomMenu();
                        },
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        child: Padding(
                            padding: EdgeInsets.all(
                                ScreenUtil.getInstance().setWidth(45)),
                            child: RotationTransition(
                              turns: animation,
                              child: Image(
                                image: AssetImage(R.assetsImgIcRefreshB),
                              ),
                            )),
                        onTap: () {
                          loading = true;
                          webViewController.reload();
                          controller.forward();
                        },
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: EdgeInsets.all(
                              ScreenUtil.getInstance().setWidth(45)),
                          child: Image(
                            image: canGoBack
                                ? AssetImage(R.assetsImgIcHomeB)
                                : AssetImage(R.assetsImgIcHomeG),
                          ),
                        ),
                        onTap: () {
                          if (canGoBack) {
                            goHome = true;
                            webViewController.goBack();
                          }
                        },
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              )
            ],
          )),
      onWillPop: _requestPop,
    );
  }

  ///弹出框
  void showBottomMenu() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return new Container(
          height: ScreenUtil.getInstance().setWidth(400),
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(65)),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            bottom: ScreenUtil.getInstance().setWidth(30)),
                        decoration: new BoxDecoration(
                          border: new Border.all(
                              color: Colors.transparent, width: 0),
                          // 边色与边宽度
                          color: Color(0xFFf5f5f5),
                          // 底色
                          shape: BoxShape.circle, // 默认值也是矩形
                        ),
                        width: ScreenUtil.getInstance().setWidth(145),
                        height: ScreenUtil.getInstance().setWidth(145),
                        child: Center(
                          child: Image(
                            image: AssetImage(R.assetsImgIcShareB),
                            width: ScreenUtil.getInstance().setWidth(75),
                            height: ScreenUtil.getInstance().setWidth(75),
                          ),
                        ),
                      ),
                      Text(
                        "分享到广场",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(35),
                            color: Color(0xff333333)),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil.getInstance().setWidth(30)),
                          decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.transparent, width: 0),
                            // 边色与边宽度
                            color: Color(0xFFf5f5f5),
                            // 底色
                            shape: BoxShape.circle, // 默认值也是矩形
                          ),
                          width: ScreenUtil.getInstance().setWidth(145),
                          height: ScreenUtil.getInstance().setWidth(145),
                          child: Center(
                            child: Image(
                              image: AssetImage(R.assetsImgIcBrowserB),
                              width: ScreenUtil.getInstance().setWidth(75),
                              height: ScreenUtil.getInstance().setWidth(75),
                            ),
                          ),
                        ),
                        onTap: () {
                          print("url:" + url);
                          launch(url);
//                          if (await canLaunch(url)) {
//                            launch(url);
//                          } else {
//                            throw 'Could not launch $url';
//                          }
                        },
                      ),
                      Text(
                        "浏览器打开",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(35),
                            color: Color(0xff333333)),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil.getInstance().setWidth(30)),
                          decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.transparent, width: 0),
                            // 边色与边宽度
                            color: Color(0xFFf5f5f5),
                            // 底色
                            shape: BoxShape.circle, // 默认值也是矩形
                          ),
                          width: ScreenUtil.getInstance().setWidth(145),
                          height: ScreenUtil.getInstance().setWidth(145),
                          child: Center(
                            child: Image(
                              image: AssetImage(R.assetsImgIcCollectB),
                              width: ScreenUtil.getInstance().setWidth(75),
                              height: ScreenUtil.getInstance().setWidth(75),
                            ),
                          ),
                        ),
                        onTap: () => {
                          HttpRequest.getInstance().post(
                              "${Api.COLLECT}${id}/json",
                              successCallBack: (data) {
                                T.showToast("已收藏");
                              },
                              errorCallBack: (code, msg) {},
                              context: context)
                        },
                      ),
                      Text(
                        "收藏",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(35),
                            color: Color(0xff333333)),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil.getInstance().setWidth(30)),
                          decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.transparent, width: 0),
                            // 边色与边宽度
                            color: Color(0xFFf5f5f5),
                            // 底色
                            shape: BoxShape.circle, // 默认值也是矩形
                          ),
                          width: ScreenUtil.getInstance().setWidth(145),
                          height: ScreenUtil.getInstance().setWidth(145),
                          child: Center(
                            child: Image(
                              image: AssetImage(R.assetsImgIcCopyLinkB),
                              width: ScreenUtil.getInstance().setWidth(75),
                              height: ScreenUtil.getInstance().setWidth(75),
                            ),
                          ),
                        ),
                        onTap: () {
                          webViewController.currentUrl().then((curl) {
                            ClipboardData data = new ClipboardData(text: url);
                            Clipboard.setData(data);
                            T.showToast("已复制");
                            Navigator.pop(context);
                          });
                        },
                      ),
                      Text(
                        "复制链接",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(35),
                            color: Color(0xff333333)),
                      )
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: <Widget>[
                      InkWell(
                        child: Container(
                          margin: EdgeInsets.only(
                              bottom: ScreenUtil.getInstance().setWidth(30)),
                          decoration: new BoxDecoration(
                            border: new Border.all(
                                color: Colors.transparent, width: 0),
                            // 边色与边宽度
                            color: Color(0xFFf5f5f5),
                            // 底色
                            shape: BoxShape.circle, // 默认值也是矩形
                          ),
                          width: ScreenUtil.getInstance().setWidth(145),
                          height: ScreenUtil.getInstance().setWidth(145),
                          child: Center(
                            child: Image(
                              image: AssetImage(R.assetsImgIcExitB),
                              width: ScreenUtil.getInstance().setWidth(75),
                              height: ScreenUtil.getInstance().setWidth(75),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        "退出",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(35),
                            color: Color(0xff333333)),
                      )
                    ],
                  )),
                ],
              )
            ],
          ),
        );
      },
    ).then((val) {
      print(val);
    });
  }
}
