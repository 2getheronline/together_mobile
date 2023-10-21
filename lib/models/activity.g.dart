// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      id: json['id'] as int?,
      missionId: json['missionId'] as int?,
      actionId: json['actionId'] as int?,
    )
      ..mission = json['mission'] == null
          ? null
          : Mission.fromJson(json['mission'] as Map<String, dynamic>)
      ..action = json['action'] == null
          ? null
          : ActionModel.fromJson(json['action'] as Map<String, dynamic>)
      ..created_at = json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String);

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'id': instance.id,
      'missionId': instance.missionId,
      'actionId': instance.actionId,
      'mission': instance.mission,
      'action': instance.action,
      'created_at': instance.created_at?.toIso8601String(),
    };
