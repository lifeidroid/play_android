import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/page/MainPage.dart';
import 'package:play_android/r.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashView(),
    );
  }
}

class SplashView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new SplashViewState();
  }

}

class SplashViewState extends State<SplashView> {
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
    countdown();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 1080, height: 1920)..init(context);
    return new Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue,
      ),
      child: new Image(image: AssetImage(R.assetsImgIcLauncherForeground)),
    );
  }
}
