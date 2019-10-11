import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Container(
          height: ScreenUtil.getInstance().setHeight(110),
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Visibility(
              visible: true,
              child: IconButton(
                icon: Icon(Icons.arrow_right),
                tooltip: 'Increase volume by 10',
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
              tooltip: 'Increase volume by 10',
              disabledColor: Colors.lightBlue,
              onPressed: null,
            ),
          ],
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
              ),
              new Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(
                      top: ScreenUtil.getInstance().setWidth(85)),
                  height: ScreenUtil.getInstance().setWidth(120),
                  child: new RaisedButton(
                      onPressed: () {},
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
}
