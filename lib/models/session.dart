import 'package:together_online/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'session.g.dart';

@JsonSerializable()
class Session{
  String? token;

  @JsonKey(includeIfNull: false)
  String? groupId;

  @JsonKey(includeIfNull: false)
  String? groupPassword;

  @JsonKey(includeIfNull: false)
  String? name;

  @JsonKey(includeIfNull: false)
  User? auth;

  Session.init({this.token, this.groupPassword, this.groupId, this.name});
  Session({this.auth});
  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      auth: User.fromJson(json),
    );
  }
  Map<String, dynamic> toJson() => _$SessionToJson(this);
}