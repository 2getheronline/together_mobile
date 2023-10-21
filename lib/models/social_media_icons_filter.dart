import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon {
  String? iconEnabled;
  String? iconDisabled;
  bool isSelected;
  Widget getIcon() {
    return SvgPicture.asset(isSelected ? iconEnabled! : iconDisabled!);
  }

  void setIsSelected() {
    isSelected = !isSelected;
  }



  SvgIcon({this.iconEnabled, this.iconDisabled, this.isSelected = true});
}

List<SvgIcon> socialMediaIconsFilter = [
  SvgIcon(
    iconDisabled:
        'assets/icons/social_media_icons/filter_social_media/facebook_filter.svg',
    iconEnabled:
        'assets/icons/social_media_icons/filter_social_media/facebook_filter_selected.svg',
  ),
  SvgIcon(
    iconDisabled:
        'assets/icons/social_media_icons/filter_social_media/instagram_filter.svg',
    iconEnabled:
        'assets/icons/social_media_icons/filter_social_media/instagram_filter_selected.svg',
  ),
  SvgIcon(
    iconEnabled:
        'assets/icons/social_media_icons/filter_social_media/twitter_filter_selected.svg',
    iconDisabled:
        'assets/icons/social_media_icons/filter_social_media/twitter_filter.svg',
  ),
  SvgIcon(
    iconDisabled:
        'assets/icons/social_media_icons/filter_social_media/youtube_filter.svg',
    iconEnabled:
        'assets/icons/social_media_icons/filter_social_media/youtube_filter_selected.svg',
  ),
];
