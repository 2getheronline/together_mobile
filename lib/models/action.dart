import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:together_online/models/target.dart';
part 'action.g.dart';

final Actions = {
  'COMMENT': ActionModel.fromAction({  'name': 'comment', 'icon': 'assets/icons/actions/comment.svg' }),
  'REPORT': ActionModel.fromAction({  'name': 'report', 'icon': 'assets/icons/actions/report.svg' }),
  'LIKE': ActionModel.fromAction({ 'name': 'like', 'icon': 'assets/icons/actions/like.svg' }),
  'DISLIKE': ActionModel.fromAction({  'name': 'dislike', 'icon': 'assets/icons/actions/dislike.svg' }),
  'RETWEET': ActionModel.fromAction({  'name': 'retweet', 'icon': 'assets/icons/actions/retweet.svg' }),
  'RATE': ActionModel.fromAction({  'name': 'rate', 'icon': 'assets/icons/actions/rate.svg' }),
  'SHARE': ActionModel.fromAction({  'name': 'share', 'icon': 'assets/icons/actions/share.svg' }),
};

final actionsMap = {
  "comment": Actions['COMMENT'],
  "report": Actions['REPORT'],
  "like": Actions['LIKE'],
  "dislike": Actions['DISLIKE'],
  "retweet": Actions['RETWEET'],
  "rate": Actions['RATE'],
  "share": Actions['SHARE'],
};
@JsonSerializable()
class ActionModel {
  int? id;
  String? name;

  String? icon;

  @JsonKey(defaultValue: false)
  bool done = false;

  ActionModel({this.id, this.name, this.icon});

  ActionModel.fromAction(action) {
    name = action['name'];
    icon = action['icon'];
  }
  
  Widget get iconSvg {
    return SvgPicture.asset("assets/icons/actions/" + name! +".svg");
  }

  factory ActionModel.fromJson(Map<String, dynamic> json) => _$ActionModelFromJson(json);
  Map<String, dynamic> toJson() => _$ActionModelToJson(this);

  @override
  bool operator ==(Object other) {
    return other is ActionModel && this.name == (other as ActionModel).name;
  }
  @override
  int get hashCode => id.hashCode;

  String get pretty => "${name![0].toUpperCase()}${name!.substring(1)}";
}