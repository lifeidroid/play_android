import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/entity/system_entity.dart';

import 'SystemListFragment.dart';

//体系-》体系-》详情
class SystemDetailPage extends StatefulWidget {
  SystemEntity entity;
  int current;

  SystemDetailPage(this.entity,this.current);

  @override
  State<StatefulWidget> createState() {
    return SystemDetailPageState(entity,current);
  }
}

class SystemDetailPageState extends State<SystemDetailPage>
    with SingleTickerProviderStateMixin {
  SystemEntity entity;
  var tabs = <Tab>[];
  TabController mTabController;
  int index = 0;
  var mPageController = new PageController(initialPage: 0);
  var isPageCanChanged = true;

  SystemDetailPageState(this.entity,this.index);

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < entity.children.length; i++) {
      tabs.add(Tab(text: entity.children[i].name));
    }
    //initialIndex初始选中第几个
    mTabController =
        TabController(initialIndex: index, length: tabs.length, vsync: this);
    mTabController.addListener(() {
      if (mTabController.indexIsChanging) {
        //判断TabBar是否切换
        onPageChange(mTabController.index, p: mPageController);
      }
    });
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      //判断是哪一个切换
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease); //等待pageview切换完毕,再释放pageivew监听
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index); //切换Tabbar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: TabBar(
          controller: mTabController,
          //可以和TabBarView使用同一个TabController
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
      body: new PageView.builder(
        onPageChanged: (index) {
          if (isPageCanChanged) {
            //由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,所以定义一个flag,控制pageview的回调
            onPageChange(index);
          }
        },
        controller: mPageController,
        itemBuilder: (BuildContext context, int index) {
          return new SystemListFragment(entity.children[index].id);
        },
        itemCount: entity.children.length,
      ),
    );
  }
}
