import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:play_android/Config.dart';
import 'package:play_android/entity/coin_info_entity.dart';
import 'package:play_android/entity/login_entity.dart';
import 'package:play_android/event/LoginEvent.dart';
import 'package:play_android/http/HttpRequest.dart';
import 'package:play_android/page/login/LoginPage.dart';
import 'package:play_android/page/my/CollectedPage.dart';
import 'package:play_android/r.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Api.dart';
import '../../main.dart';

class MyFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyFragmentState();
  }
}

class MyFragmentState extends State<MyFragment>
    with AutomaticKeepAliveClientMixin {
  String headPath = null;

  void goLogin() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          return new Scaffold(
            body: new LoginPage(),
          );
        },
      ),
    );
  }

  LoginEntity userEntity;
  CoinInfoEntity coinInfoEntity;

//获取本地用户信息
  getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String info = prefs.getString(Config.SP_USER_INFO);
    if (null != info && info.isNotEmpty) {
      Map userMap = json.decode(info);
      setState(() {
        userEntity = new LoginEntity.fromJson(userMap);
      });
    }
    if (prefs.containsKey(Config.SP_HEAD_PATH)) {
      String temp = prefs.getString(Config.SP_HEAD_PATH);
      setState(() {
        headPath = temp;
      });
    }
  }

//  获取积分
  getCoinCount() {
    HttpRequest.getInstance().get(Api.COIN_USERINFO, successCallBack: (data) {
      Map userMap = json.decode(data);
      setState(() {
        coinInfoEntity = CoinInfoEntity.fromJson(userMap);
      });
    }, errorCallBack: (code, msg) {});
  }

  @override
  void initState() {
    super.initState();
    eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        getUserInfo();
      });
    });
    if (null == userEntity) {
      getUserInfo();
    }
    if (null == coinInfoEntity) {
      getCoinCount();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: new Column(
        children: <Widget>[
          new Container(
            decoration: headPath == null
                ? BoxDecoration(
                    color: Color(0xff4282f4),
                  )
                : new BoxDecoration(
                    image: new DecorationImage(
                      image: FileImage(File(headPath)),
                      fit: BoxFit.fill,
                    ),
                  ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
              child: new Column(
                children: <Widget>[
                  new GestureDetector(
                    child: new ClipOval(
                      child: new Image(
                        image: null == headPath
                            ? AssetImage(R.assetsImgImgUserHead)
                            : FileImage(new File(headPath)),
                        width: ScreenUtil.getInstance().setWidth(220),
                        height: ScreenUtil.getInstance().setWidth(220),
                      ),
                    ),
                    onTap: () async {
                      if (null != userEntity) {
                        var image = await ImagePicker.pickImage(
                            source: ImageSource.gallery);
                        File croppedFile = await ImageCropper.cropImage(
                            sourcePath: image.path,
                            aspectRatioPresets: [
                              CropAspectRatioPreset.square,
                            ],
                            androidUiSettings: AndroidUiSettings(
                                toolbarTitle: '裁剪',
                                toolbarColor: Color(0xff4282f4),
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.square,
                                hideBottomControls: true,
                                lockAspectRatio: true),
                            iosUiSettings: IOSUiSettings(
                              minimumAspectRatio: 1.0,
                            ));
                        if (null != croppedFile) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString(
                              Config.SP_HEAD_PATH, croppedFile.path);
                          setState(() {
                            headPath = croppedFile.path;
                          });
                        }
                      } else {
                        goLogin();
                      }
                    },
                  ),
                  new Container(
                    height: ScreenUtil.getInstance().setWidth(30),
                  ),
                  new Text(
                    null == userEntity ? "去登陆" : userEntity.nickname,
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(60),
                        color: Colors.white),
                  ),
                  new Container(
                    height: ScreenUtil.getInstance().setWidth(20),
                  ),
                  new Text(
                    null == userEntity ? "ID:---" : "ID:${userEntity.id}",
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(35),
                        color: Colors.white),
                  ),
                  new Container(
                    height: ScreenUtil.getInstance().setWidth(20),
                  ),
                  new Text(
                    null == coinInfoEntity
                        ? "等级:---   排名：--"
                        : "等级:1   排名：${coinInfoEntity.rank}",
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
            ),
            height: ScreenUtil.getInstance().setWidth(700),
            width: ScreenUtil.getInstance().setWidth(1080),
//          color: Color(0xFF4282f4),
          ),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
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
                      new Text(
                        null == coinInfoEntity
                            ? ""
                            : "${coinInfoEntity.coinCount}",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(40),
                            color: Colors.black38),
                      ),
                      new Padding(
                        padding: EdgeInsets.only(
                            right: ScreenUtil.getInstance().setWidth(45)),
                        child: IconButton(
                            icon: Image(
                          image: AssetImage(R.assetsImgImgRight),
                          width: ScreenUtil.getInstance().setWidth(55),
                          height: ScreenUtil.getInstance().setWidth(55),
                        )),
                      )
                    ],
                  ),
                  new GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (_) {
                        return new CollectedPage();
                      }));
                    },
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
                          padding: EdgeInsets.only(
                              right: ScreenUtil.getInstance().setWidth(45)),
                          child: IconButton(
                              icon: Image(
                            image: AssetImage(R.assetsImgImgRight),
                            width: ScreenUtil.getInstance().setWidth(55),
                            height: ScreenUtil.getInstance().setWidth(55),
                          )),
                        )
                      ],
                    ),
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
                        padding: EdgeInsets.only(
                            right: ScreenUtil.getInstance().setWidth(45)),
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
                        padding: EdgeInsets.only(
                            right: ScreenUtil.getInstance().setWidth(45)),
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
                        padding: EdgeInsets.only(
                            right: ScreenUtil.getInstance().setWidth(45)),
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
              )),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
