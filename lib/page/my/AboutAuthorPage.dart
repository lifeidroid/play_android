import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/r.dart';
import 'package:play_android/widget/T.dart';

import '../BrowserPage.dart';

class AboutAuthorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AboutAuthorPageState();
  }
}

class AboutAuthorPageState extends State<AboutAuthorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        padding: EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(130)),
        height: ScreenUtil.getInstance().height,
        decoration: new BoxDecoration(
          image: new DecorationImage(
            image: AssetImage(R.assetsImgAuthor),
            fit: BoxFit.fill,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
          child: new Column(
            children: <Widget>[
              Container(
                height: ScreenUtil.getInstance().setWidth(175),
                alignment: Alignment.topLeft,
                child: Row(
                  children: <Widget>[
                    new InkWell(
                      child: Padding(
                        padding: EdgeInsets.all(
                            ScreenUtil.getInstance().setWidth(55)),
                        child: new Image(
                          image: AssetImage(R.assetsImgIcClose),
                        ),
                      ),
                      onTap: (){
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Text(
                        "关于作者",
                        textAlign: TextAlign.center, //文本对齐方式  居中
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(50),
                            color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsets.all(ScreenUtil.getInstance().setWidth(55)),
                      child: new Text("    "),
                    ),
                  ],
                ),
              ),
              new ClipOval(
                child: new Image(
                  image: AssetImage(R.assetsImgAuthor),
                  width: ScreenUtil.getInstance().setWidth(220),
                  height: ScreenUtil.getInstance().setWidth(220),
                ),
              ),
              new Padding(
                padding:
                    EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(80)),
                child: new Text(
                  "lifeidroid",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(60),
                      color: Colors.white),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(
                    top: ScreenUtil.getInstance().setWidth(80),
                    bottom: ScreenUtil.getInstance().setWidth(200)),
                child: new Text(
                  "你若不想做, 总能找到借口; 你若想做, 总会找到方法",
                  style: TextStyle(
                      fontSize: ScreenUtil.getInstance().setSp(35),
                      color: Colors.white),
                ),
              ),
              new InkWell(
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil.getInstance().setWidth(45),
                          top: ScreenUtil.getInstance().setWidth(45),
                          bottom: ScreenUtil.getInstance().setWidth(45),
                          right: ScreenUtil.getInstance().setWidth(35)),
                      child: new Image(
                        image: AssetImage(R.assetsImgIcGithub),
                        width: ScreenUtil.getInstance().setWidth(60),
                        height: ScreenUtil.getInstance().setWidth(60),
                      ),
                    ),
                    new Expanded(
                        child: new Text(
                      "Github",
                      style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(40),
                          decoration: TextDecoration.none, //
                          color: Colors.white),
                    )),
                    Padding(
                      padding: EdgeInsets.only(
                          right: ScreenUtil.getInstance().setWidth(45)),
                      child: new Text(
                        "https://github.com/lifeidroid",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(36),
                            decoration: TextDecoration.none, //
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (_) {
                    return new Browser(
                      url: "https://github.com/lifeidroid/",
                      title: "lifeidroid",
                      id: 9705,
                    );
                  }));
                },
              ),
              new InkWell(
                child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(
                      padding: EdgeInsets.only(
                          left: ScreenUtil.getInstance().setWidth(45),
                          top: ScreenUtil.getInstance().setWidth(45),
                          bottom: ScreenUtil.getInstance().setWidth(45),
                          right: ScreenUtil.getInstance().setWidth(35)),
                      child: new Image(
                        image: AssetImage(R.assetsImgIcAboutW),
                        width: ScreenUtil.getInstance().setWidth(60),
                        height: ScreenUtil.getInstance().setWidth(60),
                      ),
                    ),
                    new Expanded(
                        child: new Text(
                      "QQ",
                      style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(40),
                          decoration: TextDecoration.none, //
                          color: Colors.white),
                    )),
                    Padding(
                      padding: EdgeInsets.only(
                          right: ScreenUtil.getInstance().setWidth(45)),
                      child: new Text(
                        "991579741",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(36),
                            decoration: TextDecoration.none, //
                            color: Colors.white),
                      ),
                    )
                  ],
                ),
                onTap: () {
                  ClipboardData data = new ClipboardData(text: "991579741");
                  Clipboard.setData(data);
                  T.showToast("QQ已复制");
                },
              )
            ],
          ),
        ),
//          color: Color(0xFF4282f4),
      ),
    );
  }
}
