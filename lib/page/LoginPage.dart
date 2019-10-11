import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/page/LoginForm.dart';
import 'package:play_android/page/RegisterForm.dart';
import 'package:play_android/r.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new PageContent(),
    );
  }
}

class PageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage(R.assetsImgLoginBg),
        fit: BoxFit.cover,
      )),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Container(
            height: ScreenUtil.getInstance().setWidth(55),
            child: null,
          ),
          new Expanded(
              flex: 680,
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      width: ScreenUtil.getInstance().setWidth(1080),
                      alignment: Alignment.centerLeft,
                      height: ScreenUtil.getInstance().setWidth(122),
                      padding:
                          EdgeInsets.all(ScreenUtil.getInstance().setWidth(30)),
                      child: new Image(
                        image: AssetImage(R.assetsImgIcClose),
                      )),
                  new Image(
                    image: AssetImage(R.assetsImgLogo),
                    width: ScreenUtil.getInstance().setWidth(270),
                    height: ScreenUtil.getInstance().setWidth(270),
                  ),
                  new Container(
                    height: ScreenUtil.getInstance().setWidth(55),
                  ),
                  new Text(
                    "欢迎使用",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(60),
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  ),
                  new Container(
                    height: ScreenUtil.getInstance().setWidth(15),
                  ),
                  new Text(
                    "本App由lifeidroid独立开发",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(30),
                        color: Colors.white,
                        decoration: TextDecoration.none),
                  )
                ],
              )),
          new Expanded(
            child: new PageView.builder(
              itemBuilder: (BuildContext context, int index) {
                return index == 0 ? new LoginForm() : new RegisterForm();
              },
              itemCount: 2,
            ),
            flex: 1185,
          )
        ],
      ),
    );
  }
}
