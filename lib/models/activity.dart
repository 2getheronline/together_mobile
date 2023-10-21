import 'package:json_annotation/json_annotation.dart';
import 'package:together_online/models/action.dart';
import 'package:together_online/models/mission.dart';
part 'activity.g.dart';

@JsonSerializable()
class Activity{
  int? id;
  int? missionId;
  int? actionId;

  Mission? mission;
  ActionModel? action;

  DateTime? created_at;

  Activity({this.id, this.missionId, this.actionId});

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}