import 'package:json_annotation/json_annotation.dart';
part 'category.g.dart';
@JsonSerializable()
class Category {
  String? name;
  bool? filterIsEnabled = true;

  Category([category]) {
    name = category['name'];
  }


  bool? filterEnableDisable() {
    filterIsEnabled = !filterIsEnabled!;
    return filterIsEnabled;
  }
  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}