import 'package:flutter/material.dart';

/*
 * 常用图片按钮
 */
class SimpleImageButton extends StatefulWidget {
  //正常图片
  final String normalImage;
  //按下图片
  final String pressedImage;
  //点击事件
  final Function onPressed;
  //按钮宽度
  final double width;
  //按钮高度
  final double height;
  //按钮文字
  final String title;
  //正常颜色
  final Color normalTextColor;
  //选中颜色
  final Color pressedTextColor;
  //文字大小
  final double fontSize;

  const SimpleImageButton({
    Key key,
    @required this.normalImage,
    @required this.pressedImage,
    @required this.onPressed,
    @required this.width,
    @required this.height,
    @required this.normalTextColor,
    @required this.pressedTextColor,
    @required this.fontSize,
    this.title,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SimpleImageButtonState();
  }
}

class _SimpleImageButtonState extends State<SimpleImageButton> {
  @override
  Widget build(BuildContext context) {
    return ImageButton(
      normalImage: widget.normalImage,
      pressedImage: widget.pressedImage,
      title: widget.title == null ? '' : widget.title,
      //文本是否为空
      normalStyle: TextStyle(
          color: widget.normalTextColor,
          fontSize: widget.fontSize,
          decoration: TextDecoration.none),
      pressedStyle: TextStyle(
          color: widget.pressedTextColor,
          fontSize: widget.fontSize,
          decoration: TextDecoration.none),
      onPressed: widget.onPressed,
      width: widget.width,
      height: widget.height,
    );
  }
}

/*
 * 图片 按钮
 */
class ImageButton extends StatefulWidget {
  //常规状态
  final String normalImage;

  //按下状态
  final String pressedImage;

  //按钮文本
  final String title;

  //常规文本TextStyle
  final TextStyle normalStyle;

  //按下文本TextStyle
  final TextStyle pressedStyle;

  //按下回调
  final Function onPressed;

  //文本与图片之间的距离
  final double padding;

  final double width;

  final double height;

  ImageButton({
    Key key,
    @required this.normalImage,
    @required this.pressedImage,
    @required this.onPressed,
    @required this.width,
    @required this.height,
    this.title,
    this.normalStyle,
    this.pressedStyle,
    this.padding,
  }) : super(key: key);

  @override
  _ImageButtonState createState() {
    return _ImageButtonState();
  }
}

class _ImageButtonState extends State<ImageButton> {
  var isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: new Container(
        width: widget.width,
        height: widget.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                isPressed ? widget.pressedImage : widget.normalImage),
            fit: BoxFit.cover,
          ),
        ),
        child: widget.title.isNotEmpty //文本是否为空
            ? Text(
                widget.title,
                style: isPressed ? widget.pressedStyle : widget.normalStyle,
              )
            : Container(),
      ),
      onTap: widget.onPressed,
      onTapDown: (d) {
        //按下，更改状态
        setState(() {
          isPressed = true;
        });
      },
      onTapCancel: () {
        //取消，更改状态
        setState(() {
          isPressed = false;
        });
      },
      onTapUp: (d) {
        //抬起，更改按下状态
        setState(() {
          isPressed = false;
        });
      },
    );
  }
}
