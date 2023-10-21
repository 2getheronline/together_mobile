
import 'package:json_annotation/json_annotation.dart';

part 'language.g.dart';


@JsonSerializable()
class Language {
  int? id;
  String? language;
  String? name;

  Language({this.language, this.name});

  factory Language.fromJson(Map<String, dynamic> json) => _$LanguageFromJson(json);
  Map<String, dynamic> toJson() => _$LanguageToJson(this);

  @override
  bool operator ==(Object other) => language == (other as Language).language;

}