import 'dart:async';
import 'dart:convert';

import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/Api.dart';
import 'package:play_android/Config.dart';
import 'package:play_android/page/MainPage.dart';
import 'package:play_android/r.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'entity/login_entity.dart';
import 'http/HttpRequest.dart';

EventBus eventBus = EventBus();

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashView(),
    );
  }
}

class SplashView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SplashViewState();
  }
}

class SplashViewState extends State<SplashView> {
  //获取本地用户信息
  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString(Config.SP_USER_INFO);
    if (null != info && info.isNotEmpty) {
      Map userMap = json.decode(info);
      LoginEntity userEntity = new LoginEntity.fromJson(userMap);
      String _name = userEntity.username;
      String _pwd = prefs.getString(Config.SP_PWD);
      if (null != _pwd && _pwd.isNotEmpty) {
        doLogin(_name, _pwd);
      }
    }
  }

//  登录
  doLogin(String _name, String _pwd) {
    var data;
    data = {'username': _name, 'password': _pwd};
    HttpRequest.getInstance().post(Api.LOGIN, data: data,
        successCallBack: (data) {
      saveInfo(data);
      Navigator.of(context).pop();
    }, errorCallBack: (code, msg) {});
  }

//  保存用户信息
  void saveInfo(data) async {
    Map userMap = json.decode(data);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Config.SP_USER_INFO, data);
  }

  void countdown() {
    Timer timer = new Timer(new Duration(seconds: 3), () {
//      Navigator.of(context).push(
//        new MaterialPageRoute(
//          builder: (context) {
//            return new Scaffold(
//              body: new MainPage(),
//            );
//          },
//        ),
//      );

      Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(builder: (context) => new MainPage()),
        (route) => route == null,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
    countdown();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return new Scaffold(
        body: new Container(
            width: ScreenUtil.screenWidth,
            height: ScreenUtil.screenHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.lightBlue,
            ),
            child: new Image(
              image: AssetImage(R.assetsImgLogo),
              width: ScreenUtil.getInstance().setWidth(350),
              height: ScreenUtil.getInstance().setWidth(350),
            )));
  }
}
