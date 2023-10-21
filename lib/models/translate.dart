
import 'package:json_annotation/json_annotation.dart';


@JsonSerializable()
class Translate {
  Map<String, dynamic>? localizedStrings;

  Translate();

  factory Translate.fromJson(Map<String, dynamic>? json) => Translate()..localizedStrings = json;
  Map<String, dynamic>? toJson() => localizedStrings;
}