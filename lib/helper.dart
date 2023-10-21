import 'package:flutter/cupertino.dart';
import 'dart:ui';

class Helper{
  static double normalizePixel(BuildContext context, int px){
    return (px*(MediaQuery.of(context).size.height) /640);
  }
}

Color black = Color(0xff313136);
Color grey = Color(0xff3e4a59);
Color tabSelectColor = Color(0xff216dee);
Color pinCodeBorder = Color(0xffaebccf);
Color shadow = Color(0x0b000000);
