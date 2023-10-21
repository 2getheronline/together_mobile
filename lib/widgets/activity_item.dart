import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:together_online/models/action.dart' as ActionModel;
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/global.dart';

class ActivityItem extends StatelessWidget {
  final List<ActionModel.ActionModel?>? action;
  final String? title;
  final String? subtitle;
  final DateTime? date;
  final bool printDate;
  final int? index;
  var _binding = DataBindingBase.getInstance();

  ActivityItem({
    this.action,
    this.subtitle,
    this.title,
    this.date,
    this.printDate = true,
    this.index,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      //mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        printDate ? index != 0 ? Divider() : SizedBox() : SizedBox(),
        printDate
            ? Container(
                margin: EdgeInsets.only(left: 30),
                child: Text(
                  DateFormat.yMMMd(_binding.selectedLanguage.language == "he" ? "he_IL" : "en_US").format(date!),
                  style: TextStyle(
                      color: Color(0xff92939a),
                      fontWeight: FontWeight.bold,
                      fontSize: globalHeight * .018),
                ),
              )
            : SizedBox(),
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          leading: Container(
            //margin: EdgeInsets.symmetric(vertical: 10),
            child: CircleAvatar(
              radius: globalHeight * .035,
              //radius: globalHeight * .1,
              backgroundColor: Color(0xff2a388f),
              child: SvgPicture.network(action![0]!.icon!, color: Colors.white,),
            ),
          ),
          title: Text(
            title!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Html(data: subtitle!),
        ),
      ],
    );
  }

  Widget? returnIcon(ActionModel.ActionModel action) {
    if (action == ActionModel.Actions['COMMENT']) {
      return SvgPicture.asset(
          'assets/icons/social_media_icons/icons_history/comment.svg');
    }
    if (action == ActionModel.Actions['LIKE']) {
      return SvgPicture.asset(
          'assets/icons/social_media_icons/icons_history/like.svg');
    }
    if (action == ActionModel.Actions['DISLIKE']) {
      return SvgPicture.asset(
          'assets/icons/social_media_icons/icons_history/comment.svg'); //TODO: change icon!!! - i need to recive
    }
    if (action == ActionModel.Actions['REPORT']) {
      return SvgPicture.asset(
          'assets/icons/social_media_icons/icons_history/report.svg');
    }
    if (action == ActionModel.Actions['SHARE']) {
      return SvgPicture.asset(
          'assets/icons/social_media_icons/icons_history/share.svg');
    }
    return null;
  }
}
