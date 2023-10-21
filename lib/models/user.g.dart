// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      uid: json['uid'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      provider: json['provider'] as String?,
      birthdate: json['birthdate'] == null
          ? null
          : DateTime.parse(json['birthdate'] as String),
      points: json['points'] as int?,
      language: json['language'] as String?,
      address: json['address'] as String?,
      level: json['level'] == null
          ? null
          : Level.fromJson(json['level'] as Map<String, dynamic>),
    )
      ..id = json['id'] as int?
      ..avatar = json['avatar'] as String?
      ..hasYoutubeChannel = json['hasYoutubeChannel'] as bool?
      ..status = json['status'] as int?
      ..apiKey = json['apiKey'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'uid': instance.uid,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'avatar': instance.avatar,
      'provider': instance.provider,
      'language': instance.language,
      'birthdate': instance.birthdate?.toIso8601String(),
      'points': instance.points,
      'level': instance.level,
      'hasYoutubeChannel': instance.hasYoutubeChannel,
      'status': instance.status,
      'address': instance.address,
      'apiKey': instance.apiKey,
    };
