// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      auth: json['auth'] == null
          ? null
          : User.fromJson(json['auth'] as Map<String, dynamic>),
    )
      ..token = json['token'] as String?
      ..groupId = json['groupId'] as String?
      ..groupPassword = json['groupPassword'] as String?
      ..name = json['name'] as String?;

Map<String, dynamic> _$SessionToJson(Session instance) {
  final val = <String, dynamic>{
    'token': instance.token,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('groupId', instance.groupId);
  writeNotNull('groupPassword', instance.groupPassword);
  writeNotNull('name', instance.name);
  writeNotNull('auth', instance.auth);
  return val;
}
