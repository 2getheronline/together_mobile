// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mission.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Mission _$MissionFromJson(Map<String, dynamic> json) => Mission(
      body: json['body'] as String?,
      image: json['image'] as String?,
      url: json['url'] as String?,
      endDate: json['deadlineDate'] == null
          ? null
          : DateTime.parse(json['deadlineDate'] as String),
      hasEndDate: json['hasEndDate'] as bool?,
      happy: json['happy'] as bool?,
      expectedTime: json['expectedTime'] as int?,
      points: json['points'] as int?,
      limit: json['limit'] as int?,
      current: json['current'] as int?,
      categories: json['categories'] as List<dynamic>?,
      proposedComments: (json['proposedComments'] as List<dynamic>?)
          ?.where((element) => element != null)
          ?.map((e) => e as String)
          .toList(),
      date: json['publishDate'] == null
          ? null
          : DateTime.parse(json['publishDate'] as String),
    )
      ..id = json['id'] as int?
      ..title = json['title'] as String?
      ..missionStatus =
          $enumDecodeNullable(_$MissionStatusEnumMap, json['missionStatus'])
      ..appVersion = json['appVersion'] as String?
      ..missionCompletedDate = json['missionCompletedDate'] == null
          ? null
          : DateTime.parse(json['missionCompletedDate'] as String)
      ..tags = (json['tags'] as List<dynamic>?)
          ?.map((e) => Group.fromJson(e as Map<String, dynamic>))
          .toList()
      ..actions = (json['actions'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : ActionModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..screenshot = json['screenshot'] as String?
      ..target = json['platform'] == null
          ? null
          : Target.fromJson(json['platform'] as Map<String, dynamic>)
      ..level = json['level'] as int?;

Map<String, dynamic> _$MissionToJson(Mission instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'body': instance.body,
      'missionStatus': _$MissionStatusEnumMap[instance.missionStatus],
      'image': instance.image,
      'url': instance.url,
      'appVersion': instance.appVersion,
      'publishDate': instance.date?.toIso8601String(),
      'deadlineDate': instance.endDate?.toIso8601String(),
      'missionCompletedDate': instance.missionCompletedDate?.toIso8601String(),
      'hasEndDate': instance.hasEndDate,
      'happy': instance.happy,
      'expectedTime': instance.expectedTime,
      'tags': instance.tags,
      'categories': instance.categories,
      'actions': instance.actions,
      'screenshot': instance.screenshot,
      'platform': instance.target,
      'proposedComments': instance.proposedComments,
      'limit': instance.limit,
      'current': instance.current,
      'level': instance.level,
      'points': instance.points,
    };

const _$MissionStatusEnumMap = {
  MissionStatus.NOT_ACCEPTED: 'NOT_ACCEPTED',
  MissionStatus.ACCEPTED: 'ACCEPTED',
  MissionStatus.COMPLETED: 'COMPLETED',
};
