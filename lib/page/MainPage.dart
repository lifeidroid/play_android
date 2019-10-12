import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/page/project/ProjectFragment.dart';
import 'package:play_android/r.dart';

import 'System/SystemFragment.dart';
import 'gongzhonghao/GongzhFragment.dart';
import 'home/HomeFragment.dart';
import 'my/MyFragment.dart';

//主页面
class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new ApplicationPage(),
    );
  }
}

class ApplicationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ApplicationPageState();
  }
}

class _ApplicationPageState extends State<ApplicationPage> {
  int index = 0;
  var _pageController = new PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new PageView.builder(
        onPageChanged: _pageChange,
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              {
                return new HomeFragment();
              }
              break;
            case 1:
              {
                return new SystemFragment();
              }
              break;
            case 2:
              {
                return new GongzhFragment();
              }
              break;
            case 3:
              {
                return new ProjectFragment();
              }
              break;
            case 4:
              {
                return new MyFragment();
              }
              break;
          }
          return null;
        },
        itemCount: 5,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          new BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: index == 0
                  ? new Image(
                      image: AssetImage(R.assetsImgIcHomeSelected),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85))
                  : new Image(
                      image: AssetImage(R.assetsImgIcHomeNormal),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85)),
              title: new Text("首页",
                  style: new TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil.getInstance().setSp(26)))),
          new BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: index == 1
                  ? new Image(
                      image: AssetImage(R.assetsImgIcBookSelected),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85))
                  : new Image(
                      image: AssetImage(R.assetsImgIcBookNormal),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85)),
              title: new Text("体系",
                  style: new TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil.getInstance().setSp(26)))),
          new BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: index == 2
                  ? new Image(
                      image: AssetImage(R.assetsImgIcWechatSelected),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85))
                  : new Image(
                      image: AssetImage(R.assetsImgIcWechatNormal),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85)),
              title: new Text("公众号",
                  style: new TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil.getInstance().setSp(26)))),
          new BottomNavigationBarItem(
              backgroundColor: Colors.white,
              icon: index == 3
                  ? new Image(
                      image: AssetImage(R.assetsImgIcProjectSelected),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85))
                  : new Image(
                      image: AssetImage(R.assetsImgIcProjectNormal),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85)),
              title: new Text("项目",
                  style: new TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil.getInstance().setSp(26)))),
          new BottomNavigationBarItem(
              icon: index == 4
                  ? new Image(
                      image: AssetImage(R.assetsImgIcMineSelected),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85))
                  : new Image(
                      image: AssetImage(R.assetsImgIcMineNormal),
                      width: ScreenUtil.getInstance().setWidth(85),
                      height: ScreenUtil.getInstance().setWidth(85)),
              title: new Text("我的",
                  style: new TextStyle(
                      color: Colors.black54,
                      fontSize: ScreenUtil.getInstance().setSp(26)))),
        ],
        currentIndex: index,
        onTap: onTap,
      ),
    );
  }

  // bottomnaviagtionbar 和 pageview 的联动
  void onTap(int index) {
    // 过pageview的pagecontroller的animateToPage方法可以跳转
    _pageController.animateToPage(index,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }

  void _pageChange(int i) {
    setState(() {
      if (index != i) {
        index = i;
      }
    });
  }
}
