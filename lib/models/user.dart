import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:together_online/models/level.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user.g.dart';

@JsonSerializable()
class User {
  int? id;
  String? uid;
  String? name;
  String? email;
  String? phone;
  String? avatar;
  String? provider;
  String? language;
  DateTime? birthdate;
  int? points;
  Level? level;
  bool? hasYoutubeChannel = false;
  int? status;
  String? address;
  String? apiKey;

  User({
    this.uid,
    this.name,
    this.email,
    this.phone,
    this.provider,
    this.birthdate,
    this.points,
    this.language,
    this.address,
    this.level
  });

  bool get blocked => status == 1;

  ImageProvider getAvatar() => (avatar == null || avatar!.isEmpty ?
          AssetImage('assets/icons/avatar.png') :
          CachedNetworkImageProvider(avatar!)) as ImageProvider<Object>;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}