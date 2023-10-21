//library bottom_navy_bar;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:together_online/main.dart';
import 'package:together_online/providers/dataBinding.dart';

class BottomNavyBar extends StatelessWidget {
  final int selectedIndex;
  final double iconSize;
  final Color? backgroundColor;
  final bool showElevation;
  final Duration animationDuration;
  final List<BottomNavyBarItem> items;
  final ValueChanged<int> onItemSelected;
  var _binding = DataBindingBase.getInstance();

  BottomNavyBar(
      {Key? key,
      this.selectedIndex = 0,
      this.showElevation = true,
      this.iconSize = 24,
      this.backgroundColor,
      this.animationDuration = const Duration(milliseconds: 270),
      required this.items,
      required this.onItemSelected}) {
    assert(items != null);
    assert(items.length >= 2 && items.length <= 5);
    assert(onItemSelected != null);
  }

  Widget _buildItem(BottomNavyBarItem item, bool isSelected) {
    // Locale locale;
     
    return AnimatedContainer(
      width: isSelected ? 130 : 50,
      height: double.maxFinite,
      duration: animationDuration,
      //padding: EdgeInsets.only(left: 12),
      decoration: BoxDecoration(
        color: isSelected ? item.activeColor : backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: _binding.selectedLanguage.language == 'en'? const EdgeInsets.only(right: 8,) : EdgeInsets.only(left: 8,) ,
                  child: item.svgPicture == null
                      ? IconTheme(
                          data: IconThemeData(
                              size: iconSize,
                              color: isSelected
                                  ? const Color(
                                      0xff2a388f) //item.activeColor.withOpacity(1)
                                  : item.inactiveColor == null
                                      ? item.activeColor
                                      : item.inactiveColor),
                          child: item.icon!,
                        )
                      : isSelected ? item.svgPictureSelected : item.svgPicture,
                ),
                isSelected
                    ? DefaultTextStyle.merge(
                        style: TextStyle(
                            color: const Color(0xff2a388f), //item.activeColor,
                            fontWeight: FontWeight.bold),
                        child: item.title,
                      )
                    : SizedBox.shrink()
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = (backgroundColor == null)
        ? Theme.of(context).bottomAppBarColor
        : backgroundColor;

    return Container(
     // width: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffd9e3ff)),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        color: bgColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: Color.fromRGBO(31, 87, 169, 0.15),
        //     offset: Offset(0, 7),
        //     blurRadius: 21.0,
        //     spreadRadius: 10.0,
        //   ),
        // ]
      ),
      child: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.09,
          //height: 70,
          padding: EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.map((item) {
              var index = items.indexOf(item);
              return GestureDetector(
                onTap: () {
                  onItemSelected(index);
                },
                child: _buildItem(item, selectedIndex == index),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class BottomNavyBarItem {
  final SvgPicture? svgPicture;
  final SvgPicture? svgPictureSelected;
  final Icon? icon;
  final Text title;
  final Color activeColor =Color(0xfff0f4ff);
  final Color? inactiveColor;

  BottomNavyBarItem({
    this.icon,
    required this.title,
    this.inactiveColor,
    this.svgPicture,
    this.svgPictureSelected,
  }) {
    //assert(icon != null);
    assert(title != null);
  }
}
