import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../helper.dart';

class MyRaisedButton extends StatefulWidget {
  final BuildContext? context;
  final Function? callback;
  final Function? noContextCallback;
  final BoxDecoration? decoration;
  final String? title;
  final double margin;
  final double? height;
  final double? width;
  final double fontSize;
  final bool bold;
  final bool? isEnabled;
  final bool withShadow;

  MyRaisedButton(
      {this.context,
      this.title = '',
      this.margin = 68.0,
      this.decoration,
      this.callback,
      this.noContextCallback,
      this.bold = true,
      this.isEnabled = true,
      this.height = 50,
      this.width = double.infinity,
      this.withShadow = true,
      this.fontSize = 18});

  @override
  _MyRaisedButtonState createState() => _MyRaisedButtonState();
}

class _MyRaisedButtonState extends State<MyRaisedButton> {
  get fontSize => null;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: widget.margin),
      width: this.widget.width,
      height: this.widget.height,
      decoration: this.widget.decoration != null
          ? this.widget.decoration
          : BoxDecoration(
              borderRadius: BorderRadius.circular(70),
              color: widget.isEnabled! ? const Color(0xff3950DB) : Colors.grey,
              // LinearGradient(colors: [
              //   Color(0xff00aeef),
              //   Color(0xff2a388f),
              //   Color(0xff2a388f),
              // ], begin: Alignment.centerRight, end: Alignment.centerLeft),
              ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.circular(70),
            onTap: () {
              if (widget.noContextCallback == null)
                widget.callback!(context);
              else
                widget.noContextCallback!();
            },
            child: Center(
              child: Text(
                widget.title!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: this.widget.fontSize,
                  fontWeight: widget.bold ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            )),
      ),
    );
  }
}
