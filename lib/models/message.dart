
import 'package:json_annotation/json_annotation.dart';

part 'message.g.dart';


@JsonSerializable()
class Message {
  String? content;
  String? link;
  String? title;

  Message({this.content, this.link});

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
  Map<String, dynamic> toJson() => _$MessageToJson(this);
}