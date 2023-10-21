import 'package:json_annotation/json_annotation.dart';
part 'level.g.dart';
@JsonSerializable()
class Level{
  int? id;
  String? name;
  String? icon;

  Level({this.id, this.name, this.icon});

  factory Level.fromJson(Map<String, dynamic> json) => _$LevelFromJson(json);
  Map<String, dynamic> toJson() => _$LevelToJson(this);
}