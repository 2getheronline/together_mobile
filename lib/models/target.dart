import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:together_online/app_localizations.dart';
import 'package:together_online/models/action.dart';

part 'target.g.dart';

@JsonSerializable()
class Target {
  int? id;
  String? name;
  String? pretty;
  String? filterIconEnabled;
  String? filterIconDisabled;

  @JsonKey(name: 'logo')
  String? icon;
  @JsonKey(defaultValue: true)
  bool? filterIsEnabled = true;

  List<ActionModel>? availableActions;
  Target(
      {this.id,
      this.name,
      this.pretty,
      this.filterIconEnabled,
      this.filterIconDisabled,
      this.icon,
      this.filterIsEnabled,
      this.availableActions});

  @override
  bool operator ==(Object other) => other is Target && other.name == name;

  Target.fromTarget(target) {
    name = target['name'];
    pretty = target['pretty'];
    icon = target['icon'];
    filterIconEnabled = target['filterIconEnabled'];
    filterIconDisabled = target['filterIconDisabled'];
    availableActions = target['availableActions'];
  }

  String? getName(BuildContext context) {
    return AppLocalizations.of(context)!.translate(name);
  }

  String? getPretty(BuildContext context) {
    String? prettyText = AppLocalizations.of(context)!.translate(name);
    return "${prettyText?[0].toUpperCase()}${prettyText?.substring(1).toLowerCase()}";
  }

  Widget get iconSvg {
    return SvgPicture.asset(icon!);
  }

  bool? filterEnableDisable() {
    filterIsEnabled = !filterIsEnabled!;
    return filterIsEnabled;
  }

  Widget filterIcon() {
    //return SvgPicture.asset(filterIsEnabled ? filterIconEnabled : filterIconDisabled);
    return SvgPicture.asset(
        "assets/icons/social_media_icons/filter_social_media/${name}_filter${filterIsEnabled != null && filterIsEnabled! ? '_selected' : ''}.svg");
  }

  factory Target.fromJson(Map<String, dynamic> json) => _$TargetFromJson(json);
  Map<String, dynamic> toJson() => _$TargetToJson(this);

  @override
  int get hashCode => super.hashCode;
}
