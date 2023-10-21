// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActionModel _$ActionModelFromJson(Map<String, dynamic> json) => ActionModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      icon: json['icon'] as String?,
    )..done = json['done'] as bool? ?? false;

Map<String, dynamic> _$ActionModelToJson(ActionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'done': instance.done,
    };
