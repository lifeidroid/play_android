import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/r.dart';

class MyFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyFragmentState();
  }
}

class MyFragmentState extends State<MyFragment> {
  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Container(
          child: new Column(
            children: <Widget>[
              new ClipOval(
                child: new Image(
                  image: AssetImage(R.assetsImgImgUserHead),
                  width: ScreenUtil.getInstance().setWidth(220),
                  height: ScreenUtil.getInstance().setWidth(220),
                ),
              ),
              new Container(
                height: ScreenUtil.getInstance().setWidth(30),
              ),
              new Text(
                "去登陆",
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(60),
                    color: Colors.white),
              ),
              new Container(
                height: ScreenUtil.getInstance().setWidth(20),
              ),
              new Text(
                "ID:---",
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(35),
                    color: Colors.white),
              ),
              new Container(
                height: ScreenUtil.getInstance().setWidth(20),
              ),
              new Text(
                "等级:---   排名：--",
                style: TextStyle(
                    fontSize: ScreenUtil.getInstance().setSp(35),
                    color: Colors.white),
              ),
              new Container(
                height: ScreenUtil.getInstance().setWidth(50),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          height: ScreenUtil.getInstance().setWidth(700),
          width: ScreenUtil.getInstance().setWidth(1080),
          color: Color(0xFF4282f4),
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil.getInstance().setWidth(45),
                  top: ScreenUtil.getInstance().setWidth(45),
                  bottom: ScreenUtil.getInstance().setWidth(45),
                  right: ScreenUtil.getInstance().setWidth(35)),
              child: new Image(
                image: AssetImage(R.assetsImgImgStar),
                width: ScreenUtil.getInstance().setWidth(60),
                height: ScreenUtil.getInstance().setWidth(60),
              ),
            ),
            new Expanded(
                child: new Text(
              "我的积分",
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(40),
                  color: Colors.black54),
            )),
            new Padding(
              padding:
                  EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(45)),
              child: IconButton(
                  icon: Image(
                image: AssetImage(R.assetsImgImgRight),
                width: ScreenUtil.getInstance().setWidth(55),
                height: ScreenUtil.getInstance().setWidth(55),
              )),
            )
          ],
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil.getInstance().setWidth(45),
                  top: ScreenUtil.getInstance().setWidth(45),
                  bottom: ScreenUtil.getInstance().setWidth(45),
                  right: ScreenUtil.getInstance().setWidth(35)),
              child: new Image(
                image: AssetImage(R.assetsImgImgHeart),
                width: ScreenUtil.getInstance().setWidth(60),
                height: ScreenUtil.getInstance().setWidth(60),
              ),
            ),
            new Expanded(
                child: new Text(
              "我的收藏",
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(40),
                  color: Colors.black54),
            )),
            new Padding(
              padding:
                  EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(45)),
              child: IconButton(
                  icon: Image(
                image: AssetImage(R.assetsImgImgRight),
                width: ScreenUtil.getInstance().setWidth(55),
                height: ScreenUtil.getInstance().setWidth(55),
              )),
            )
          ],
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil.getInstance().setWidth(45),
                  top: ScreenUtil.getInstance().setWidth(45),
                  bottom: ScreenUtil.getInstance().setWidth(45),
                  right: ScreenUtil.getInstance().setWidth(35)),
              child: new Image(
                image: AssetImage(R.assetsImgImgBook),
                width: ScreenUtil.getInstance().setWidth(60),
                height: ScreenUtil.getInstance().setWidth(60),
              ),
            ),
            new Expanded(
                child: new Text(
              "稍后阅读",
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(40),
                  color: Colors.black54),
            )),
            new Padding(
              padding:
                  EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(45)),
              child: IconButton(
                  icon: Image(
                image: AssetImage(R.assetsImgImgRight),
                width: ScreenUtil.getInstance().setWidth(55),
                height: ScreenUtil.getInstance().setWidth(55),
              )),
            )
          ],
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil.getInstance().setWidth(45),
                  top: ScreenUtil.getInstance().setWidth(45),
                  bottom: ScreenUtil.getInstance().setWidth(45),
                  right: ScreenUtil.getInstance().setWidth(35)),
              child: new Image(
                image: AssetImage(R.assetsImgImgGithub),
                width: ScreenUtil.getInstance().setWidth(60),
                height: ScreenUtil.getInstance().setWidth(60),
              ),
            ),
            new Expanded(
                child: new Text(
              "开源项目",
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(40),
                  color: Colors.black54),
            )),
            new Padding(
              padding:
                  EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(45)),
              child: IconButton(
                  icon: Image(
                image: AssetImage(R.assetsImgImgRight),
                width: ScreenUtil.getInstance().setWidth(55),
                height: ScreenUtil.getInstance().setWidth(55),
              )),
            )
          ],
        ),
        new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.only(
                  left: ScreenUtil.getInstance().setWidth(45),
                  top: ScreenUtil.getInstance().setWidth(45),
                  bottom: ScreenUtil.getInstance().setWidth(45),
                  right: ScreenUtil.getInstance().setWidth(35)),
              child: new Image(
                image: AssetImage(R.assetsImgImgSetting),
                width: ScreenUtil.getInstance().setWidth(60),
                height: ScreenUtil.getInstance().setWidth(60),
              ),
            ),
            new Expanded(
                child: new Text(
              "系统设置",
              style: TextStyle(
                  fontSize: ScreenUtil.getInstance().setSp(40),
                  color: Colors.black54),
            )),
            new Padding(
              padding:
                  EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(45)),
              child: IconButton(
                  icon: Image(
                image: AssetImage(R.assetsImgImgRight),
                width: ScreenUtil.getInstance().setWidth(55),
                height: ScreenUtil.getInstance().setWidth(55),
              )),
            )
          ],
        ),
      ],
    );
  }
}
