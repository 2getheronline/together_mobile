import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:together_online/widgets/myFlatButton.dart';

class RaisedButton extends StatelessWidget {
  Widget child;
  RoundedRectangleBorder shape;
  Color color;
  double elevation;
  EdgeInsets padding;
  Function? onPressed;

  RaisedButton({
    this.child = const Text(''),
    this.shape = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
    ),
    this.color = Colors.white,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.all(0.0),
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      elevation: elevation,
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        onTap: () {
          onPressed?.call();
        },
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

class MyButton extends StatelessWidget {
  BuildContext? context;
  String? style;
  Function? callback;
  Function? noContextCallback;
  BoxDecoration? decoration;
  String title;
  double margin;
  bool bold;
  bool isEnabled;

  MyButton({
    this.context,
    this.style,
    this.title = '',
    this.margin = 68.0,
    this.decoration,
    this.callback,
    this.noContextCallback,
    this.bold = true,
    this.isEnabled = true,
  });

  Widget buildRaisedButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      width: double.infinity,
      height: 50,
      decoration: this.decoration != null
          ? this.decoration
          : BoxDecoration(
              boxShadow: [
                  BoxShadow(
                      blurRadius: 19,
                      spreadRadius: 0,
                      color: Color(0x3a1f57a9),
                      offset: Offset(0, 11)),
                ],
              borderRadius: BorderRadius.circular(30),
              color: Colors.grey,
              gradient: isEnabled? LinearGradient(
                  begin: Alignment(0, 0.4999999999999997),
                  end: Alignment(2.04193115234375, 0.4999999999999997),
                  colors: [const Color(0xff2a388f), const Color(0xff00aeef)]) : null
              // LinearGradient(colors: [
              //   Color(0xff00aeef),
              //   Color(0xff2a388f),
              //   Color(0xff2a388f),
              // ], begin: Alignment.centerRight, end: Alignment.centerLeft),
              ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.circular(30),
            onTap: () {
              if (noContextCallback == null) callback!(context);
              else noContextCallback!();
            },
            child: Center(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            )),
      ),
    );
  }

  buildFlatButton() {
    return FlatButton(
        child: Text(
          title, // TODO: Change Fount
          style: TextStyle(
            fontWeight: bold? FontWeight.bold : FontStyle.normal as FontWeight?,
            color: Color.fromRGBO(42, 56, 143, 1),
            fontSize: 20,
          ),
        ),
        onPressed: () {
          callback!(context);
        });
  }

  @override
  Widget build(BuildContext context) {
    return style == 'raised' ? buildRaisedButton() : buildFlatButton();
  }
}
