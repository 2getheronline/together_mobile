import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:together_online/models/rank.dart';
import 'package:together_online/models/tag.dart';
import 'package:together_online/models/user.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/database.dart';

class Scores extends StatelessWidget {
  var _binding = DataBindingBase.getInstance();
  bool scoreType;
  Scores(this.scoreType);

  @override
  Widget build(BuildContext context) {
    List items = scoreType ? _binding.topUsers : _binding.topGroups;

    return Observer(
        builder: (_) => Container(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            //height: 400,
            color: Color(0xFFF2f6fe),
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext ctxt, int index) =>
                    UserItem(items[index]))));
  }
}

class UserItem extends StatelessWidget {
  var user;

  UserItem(this.user);

  @override
  Widget build(BuildContext context) => Column(children: [
        ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          leading: SizedBox(
              height: 40,
              width: 40,
              child: ClipOval(
                child: user is Group
                    ? Container(
                        color: Color(0xFFDDDFEA), child: Icon(Icons.group))
                    : (user.avatar == null
                        ? Image.asset('assets/icons/avatar.png')
                        : CachedNetworkImage(
                            imageUrl: user.avatar,
                            errorWidget: (_, s, c) =>
                                Image.asset('assets/icons/avatar.png'))),
              )),
          title: Text('${user.name}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset('assets/icons/diamond.svg'),
              SizedBox(
                width: 6,
              ),
              Text('${user.points.toString()}'),
            ],
          ),
        ),
        Divider()
      ]);
}
