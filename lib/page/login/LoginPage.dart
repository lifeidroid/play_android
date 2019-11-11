import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/page/login/LoginForm.dart';
import 'package:play_android/page/login/RegisterForm.dart';
import 'package:play_android/r.dart';

class LoginPage extends StatelessWidget {
  var _pageController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        Container(
//          decoration: BoxDecoration(
//              color:Color(0xff4282f4)),
          child:FlareActor(
            "assets/flrs/loginbg.flr",
            animation: "wave",
            fit: BoxFit.fill,
          ),
        ),
        new Column(
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
                      child: new GestureDetector(
                        child: new Image(
                          image: AssetImage(R.assetsImgIcClose),
                        ),
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
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
                  return index == 0
                      ? new LoginForm(_pageController)
                      : new RegisterForm(_pageController);
                },
                itemCount: 2,
                controller: _pageController,
              ),
              flex: 1185,
            )
          ],
        ),
      ],
    );
  }
}
