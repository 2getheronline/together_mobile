// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Target _$TargetFromJson(Map<String, dynamic> json) => Target(
      id: json['id'] as int?,
      name: json['name'] as String?,
      pretty: json['pretty'] as String?,
      filterIconEnabled: json['filterIconEnabled'] as String?,
      filterIconDisabled: json['filterIconDisabled'] as String?,
      icon: json['logo'] as String?,
      filterIsEnabled: json['filterIsEnabled'] as bool? ?? true,
      availableActions: (json['availableActions'] as List<dynamic>?)
          ?.map((e) => ActionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TargetToJson(Target instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'pretty': instance.pretty,
      'filterIconEnabled': instance.filterIconEnabled,
      'filterIconDisabled': instance.filterIconDisabled,
      'logo': instance.icon,
      'filterIsEnabled': instance.filterIsEnabled,
      'availableActions': instance.availableActions,
    };
