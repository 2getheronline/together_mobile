// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category()
  ..name = json['name'] as String?
  ..filterIsEnabled = json['filterIsEnabled'] as bool?;

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'name': instance.name,
      'filterIsEnabled': instance.filterIsEnabled,
    };
