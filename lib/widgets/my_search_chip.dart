import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:together_online/providers/global.dart';

class MySearchChip extends StatelessWidget {
  final bool? isSelected;
  final String? text;
  final Color selectedBorderColor;
  final Color selectedBackgroundColor;
  final Color selectedTextColor;
  final Color unselectedBorderColor;
  final Color unselectedBackgroundColor;
  final Color unselectedTextColor;
  final Function onTap;
  bool hasIcon;
  SvgPicture? selectedIcon;
  SvgPicture? icon;
  bool selectedCheck;
  //final double fontSize;

  MySearchChip({
    required this.isSelected,
    required this.onTap,
    this.selectedBackgroundColor = Colors.white,
    this.selectedBorderColor = Colors.indigo,
    this.selectedTextColor = Colors.indigo,
    this.text,
    this.hasIcon = false,
    this.unselectedBackgroundColor = Colors.white,
    this.unselectedBorderColor = const Color(0xFFE1E1E2),
    this.unselectedTextColor = const Color(0xFF65656D),
    this.icon,
    this.selectedIcon,
    this.selectedCheck = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        //padding: EdgeInsets.symmetric(vertical: 0, horizontal: 6),
        child: Stack(
          children: <Widget>[
            
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(
                    width: 1,
                    color: isSelected!
                        ? selectedBorderColor
                        : unselectedBorderColor,
                  ),),
              padding: EdgeInsets.symmetric(vertical: 7, horizontal: 18),
              margin: selectedCheck? EdgeInsets.only(top: 6) : EdgeInsets.only(top: 0),
              child: !hasIcon
                  ? Text(
                      text!,
                      style: TextStyle(
                        fontSize: globalHeight * .016,
                        fontWeight: FontWeight.bold,
                        color: isSelected!
                            ? selectedTextColor
                            : unselectedTextColor,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        icon!,
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          text!,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isSelected!
                                ? selectedTextColor
                                : unselectedTextColor,
                          ),
                        ),
                      ],
                    ),
            ),
            selectedCheck
                ? isSelected!
                    ? Positioned(
                      top: 0,
                        right: 0,
                        child: SvgPicture.asset('assets/icons/selected.svg'),
                      )
                    : SizedBox()
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
