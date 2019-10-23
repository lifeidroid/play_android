import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/page/System/SystemChildFragment.dart';
import 'package:play_android/page/System/SystemNaviFragment.dart';

class SystemFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SystemFragmentState();
  }
}

class SystemFragmentState extends State<SystemFragment>
    with SingleTickerProviderStateMixin {
  TabController mTabController;
  var tabs = <Tab>[];
  int index = 0;
  var _pageController = new PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    tabs = <Tab>[
      Tab(
        text: "体系",
      ),
      Tab(
        text: "导航",
      ),
    ];

    //initialIndex初始选中第几个
    mTabController = TabController(initialIndex: 0, length: tabs.length, vsync: this);
    mTabController.addListener(() {//TabBar的监听
      if (mTabController.indexIsChanging) {//判断TabBar是否切换
        _pageController.animateToPage(mTabController.index,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      }
    });
  }

  void _pageChange(int i) {
    setState(() {
      if (index != i) {
        index = i;
        mTabController.animateTo(index);//切换Tabbar
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff4282f4),
        centerTitle: true,
        title: TabBar(
          controller: mTabController,//可以和TabBarView使用同一个TabController
          tabs: tabs,
          isScrollable: true,
          indicatorColor: Colors.transparent,
          indicatorWeight: 1,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.only(bottom: 10.0),
          labelPadding: EdgeInsets.only(left: 20),
          labelColor: Colors.white,
          labelStyle: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(45),
          ),
          unselectedLabelColor: Color(0x90ffffff),
          unselectedLabelStyle: TextStyle(
            fontSize: ScreenUtil.getInstance().setSp(45),
          ),
        ),
      ),
      body:  new PageView.builder(
        onPageChanged: _pageChange,
        controller: _pageController,
        itemBuilder: (BuildContext context, int index) {
          switch (index) {
            case 0:
              {
                return new SystemChildFragment();
              }
              break;
            case 1:
              {
                return new SystemNaviFragment();
              }
              break;
          }
          return null;
        },
        itemCount: 2,
      ),
    );
  }
}
