import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:together_online/helper.dart';

class FlatButton extends StatelessWidget {
  BuildContext? context;
  String? style;
  Function? onPressed;
  Function? noContextCallback;
  BoxDecoration? decoration;
  String? title;
  double margin;
  double? height;
  double? fontSize;
  bool bold;
  bool isEnabled;
  Widget? child;

  FlatButton({
    this.context,
    this.title = '',
    this.margin = 68.0,
    this.decoration,
    this.onPressed,
    this.noContextCallback,
    this.bold = true,
    this.isEnabled = true,
    this.height,
    this.fontSize,
    this.child
  }) {
    // if(this.height == null)
    // this.height = Helper.normalizePixel(this.context!, 20);
    // if(this.fontSize == null)
    // this.fontSize = Helper.normalizePixel(this.context!, 14);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return InkWell(
        child: child ?? Text(
          title!, // TODO: Change Fount
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontStyle.normal as FontWeight?,
            color: Color.fromRGBO(42, 56, 143, 1),
            fontSize: this.fontSize,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          onPressed?.call(context);
        });
  }
}
