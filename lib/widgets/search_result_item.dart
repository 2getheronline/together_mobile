import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:together_online/providers/global.dart';

class SearchResultItem extends StatelessWidget {
  final String? title;
  final String? image;
  final bool isMission;
  final Function? onTap;

  SearchResultItem({this.image, this.onTap, this.title, this.isMission = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: onTap as void Function()?,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: globalHeight * .025),
              child: Row(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: globalHeight * .012),
                    width: globalHeight * .135,
                    height: globalHeight * .09,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: FittedBox(
                        fit: BoxFit.cover,
                        child: isMission
                            ? CachedNetworkImage(
                                imageUrl: image!,
                              )
                            : Container(
                              padding: EdgeInsets.all(globalHeight * .035),
                              color: Color(0xfff5f8ff),
                              child: SvgPicture.asset(
                                  "assets/icons/search/library_search_icon.svg", ),
                            ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      title!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: globalHeight * .022,
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: globalHeight * .005),
                    child: Icon(Icons.navigate_next),
                  )
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }
}
