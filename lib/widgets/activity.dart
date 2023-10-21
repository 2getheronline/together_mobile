import 'package:flutter/material.dart';
import 'package:together_online/app_localizations.dart';
import 'package:together_online/models/mission.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/database.dart';
import 'package:together_online/widgets/activity_item.dart';
import 'package:together_online/models/action.dart' as ActionModel;

class Activity extends StatefulWidget {
  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  DateTime? prevMissionDate = DateTime.now();
  var _binding = DataBindingBase.getInstance();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff2f6fe),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 35,
          ),
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: _binding.activities.length,
            itemBuilder: (ctx, index) {
              var activity = _binding.activities[index];
              if (index > 0) prevMissionDate = _binding.activities[index - 1].created_at;
              return ActivityItem(
                action: [activity.action],
                title: activity.mission!.title,
                subtitle: activity.mission!.body,
                date: activity.created_at,
                index: index,
                printDate: shouldPrintDate(index, activity.created_at),
              );
            },
          ))
        ],
      ),
    );
  }

  bool shouldPrintDate(int index, DateTime? curMissionDate) {
    if (index == 0) return true;
    return curMissionDate!.difference(prevMissionDate!).inDays > 0;
  }
}

//class ActivityItem extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    // TODO: implement build
//    throw UnimplementedError();
//  }
//
//}
