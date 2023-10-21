import 'package:flutter/material.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/global.dart';
import 'dart:ui' as ui;
import '../../app_localizations.dart';

class NotificationsPage extends StatefulWidget {
  static const routeName = '/notificationsPage';
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool push = true, email = false;
  var _binding = DataBindingBase.getInstance();

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: Container(
            margin: EdgeInsets.only(
              top: 20,
              left: 25,
              right: 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.translate('notifications')!,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: globalHeight * .025,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                // NotificationItem(
                //   title: (AppLocalizations.of(context)!.translate('push notifications')),
                //   isSelected: push,
                //   onTap: () {
                //     setState(() {
                //       push = !push;

                //     });
                //   },
                // ),
                NotificationItem(
                  title: (AppLocalizations.of(context)!.translate('Email')),
                  isSelected: email,
                  onTap: () {
                    setState(() {
                      email = !email;
                    });
                  },
                ),
              ],
            ),
          ),
        ));
  }
}

class NotificationItem extends StatelessWidget {
  final String? title;
  final bool isSelected;
  final Function? onTap;

  NotificationItem({this.title, this.isSelected = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            onTap: onTap as void Function()?,
            trailing: Switch(value: isSelected, onChanged: (_) {}),
            title: Text(
              title!,
              style: TextStyle(
                fontSize: globalHeight * .02,
                fontWeight: FontWeight.bold,
                //color: isSelected ? Color(0xff2a388f) : null,
              ),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
