import 'package:flutter/material.dart';
import 'package:together_online/providers/global.dart';

class MoreItem extends StatelessWidget {
  final String? title;
  final bool isBlue;
  final Function? onTap;

  MoreItem({this.title, this.isBlue = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            onTap: onTap as void Function()?,
            trailing: !isBlue? Icon(Icons.navigate_next) : null,
            title: Text(
              title!,
              style: TextStyle(
                fontSize: globalHeight * .02,
                fontWeight: isBlue? null : FontWeight.bold,
                color: isBlue ? Color(0xff2a388f) : null,
              ),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
