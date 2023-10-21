import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularSocialMediaButton extends StatelessWidget {
  final Color selectedColor;
  final Color notSelectedColor;
  final String? socialMediaIcon;
  final bool isSelected;
  final Function? onTap;

  CircularSocialMediaButton({
    this.isSelected = false,
    this.notSelectedColor = Colors.grey,
    this.onTap,
    this.selectedColor = const Color.fromRGBO(42, 56, 143, 1),
    this.socialMediaIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      // padding: EdgeInsets.all(6),
      child: LayoutBuilder(
        builder: (ctx, constrains) {
          return Container(
            height: constrains.maxHeight,
            width: constrains.maxHeight / 1.4,
            child: Stack(
              children: <Widget>[
                Container(

                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue),
                  ),
                  padding: EdgeInsets.all(15),
                  child: socialMediaIcon == null
                      ? null
                      : SvgPicture.asset(socialMediaIcon!),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
