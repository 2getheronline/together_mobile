
import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';


@JsonSerializable()
class Group {
  String? name;
  String? description;
  String? points;

  Group({this.name, this.description, this.points});

  factory Group.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);
  Map<String, dynamic> toJson() => _$TagToJson(this);
}