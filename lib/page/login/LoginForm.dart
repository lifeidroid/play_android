import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:play_android/Api.dart';
import 'package:play_android/Config.dart';
import 'package:play_android/entity/login_entity.dart';
import 'package:play_android/event/LoginEvent.dart';
import 'package:play_android/http/HttpRequest.dart';
import 'package:play_android/widget/T.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';

class LoginForm extends StatefulWidget {
  PageController _pageController;

  LoginForm(this._pageController);

  @override
  State<StatefulWidget> createState() {
    return new LoginFormState(_pageController);
  }
}

class LoginFormState extends State<LoginForm>
    with AutomaticKeepAliveClientMixin {
  PageController _pageController;

  LoginFormState(this._pageController);

  String _name;
  String _pwd;

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          height: ScreenUtil.getInstance().setHeight(110),
        ),
        new GestureDetector(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: true,
                child: IconButton(
                  icon: Icon(Icons.arrow_right),
                  disabledColor: Color(int.parse("0x00000000")),
                  onPressed: null,
                ),
              ),
              new Text(
                "去注册",
                style: TextStyle(
                    color: Colors.lightBlue,
                    fontSize: ScreenUtil.getInstance().setSp(40),
                    decoration: TextDecoration.none),
              ),
              IconButton(
                icon: Icon(Icons.arrow_right),
                disabledColor: Colors.lightBlue,
                onPressed: null,
              ),
            ],
          ),
          onTap: () {
            _pageController.animateToPage(1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease);
          },
        ),
        new Container(
          margin: EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(110)),
          width: ScreenUtil.getInstance().setWidth(750),
          child: new Column(
            children: <Widget>[
              new TextField(
                decoration: InputDecoration(
                    filled: true,
                    hintText: "请输入用户名",
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.account_circle)),
                onChanged: (val) {
                  _name = val;
                },
              ),
              new Container(
                height: ScreenUtil.getInstance().setWidth(30),
              ),
              new TextField(
                decoration: InputDecoration(
                    filled: true,
                    hintText: "请输入密码",
                    fillColor: Colors.transparent,
                    prefixIcon: Icon(Icons.lock_open)),
                onChanged: (val) {
                  _pwd = val;
                },
              ),
              new Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      top: ScreenUtil.getInstance().setWidth(85)),
                  height: ScreenUtil.getInstance().setWidth(120),
                  child: new RaisedButton(
                      onPressed: () {
                        if (null == _name || _name.isEmpty) {
                          T.showToast("请输入用户名");
                          return;
                        }
                        if (null == _pwd || _pwd.isEmpty) {
                          T.showToast("请输入密码");
                        }
                        doLogin();
                      },
                      textColor: Colors.white,
                      child: new Text(
                        "登录",
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(40)),
                      ),
                      color: Colors.lightBlue,
                      shape: new StadiumBorder(
                          side: new BorderSide(
                        style: BorderStyle.solid,
                        color: Colors.transparent,
                      ))))
            ],
          ),
        ),
      ],
    );
  }

  void doLogin() {
    var data;
    data = {'username': _name, 'password': _pwd};
    HttpRequest.getInstance().post(Api.LOGIN, data: data,
        successCallBack: (data) {
      eventBus.fire(LoginEvent());
      T.showToast("登录成功！");
      saveInfo(data);
      Navigator.of(context).pop();
    }, errorCallBack: (code, msg) {});
  }

  void saveInfo(data) async {
    Map userMap = json.decode(data);
    LoginEntity entity = new LoginEntity.fromJson(userMap);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(Config.SP_USER_INFO, data);
    await prefs.setString(Config.SP_PWD, _pwd);
  }

  @override
  bool get wantKeepAlive => true;
}
