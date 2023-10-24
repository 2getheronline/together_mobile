import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:together_online/pages/home.dart';
import 'package:together_online/pages/missions/missions.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/database.dart';
import 'package:together_online/providers/localstorage.dart';
import 'package:together_online/providers/server.dart';
import 'dart:ui' as ui;

import '../app_localizations.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _binding = DataBindingBase.getInstance();
  final server = Server.getInstance();
  TextEditingController? nameController;
  TextEditingController? emailController;

  Map<String, bool> missionPreferences = {
    'facebook': true,
    'google': true,
    'twitter': true,
    'instagram': true,
    'youtube': true,
  };

  bool logOff = false;

  @override
  void initState() {
    getMissionPreferences();
    super.initState();
    nameController = TextEditingController(text: _binding.session!.auth!.name);
    emailController = TextEditingController(text: _binding.session!.auth!.email);
  }

  getMissionPreferences() async {
    Map<String, bool> pref = await LocalStorageProvider.getMissionPreferences();
    if (pref.values.length == 0) {
      for (String k in missionPreferences.keys) {
        await updateMissionPreferences(k, true);
      }
      return;
    } else {
      setState(() {
        missionPreferences = pref;
      });
    }
  }

  updateMissionPreferences(String target, bool val) async {
    LocalStorageProvider.setMissionPreferences(target, val);
    getMissionPreferences();
  }

  @override
  void dispose() {
    if (!logOff) reloadMissions();
    super.dispose();
  }

  void changeName() async {
    _binding.session!.auth!.name = nameController!.text;
    server!.editUser();
//    bool res = await Database.changeUserName(nameController.value.text);
//
//    if (!res) {
//      print('Name not updated');
//    }
    return;
  }

  void changeEmail() async {

    Map<String, dynamic> res = await Auth.changeUserEmail(emailController!.value.text);

    if (res['success']) {
      print('Email sent successfully');
    } else {
     print('Email update error ${res['error']}');
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: LayoutBuilder(
      builder: (ctx, constrains) {
        return Container(
          color: Color(0xFFF2f6fe),
          //height: constrains.maxHeight,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: nameController,
                    style: TextStyle(fontSize: 20),
                    onEditingComplete: changeName,
                    decoration: InputDecoration(
                      labelText: (AppLocalizations.of(context)!.translate('Name')),
                      labelStyle: TextStyle(color: Colors.grey),
                      suffix:
                          SvgPicture.asset('assets/icons/edit_outlined.svg'),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: emailController,
                    style: TextStyle(fontSize: 20),
                    onEditingComplete: changeEmail,
                    decoration: InputDecoration(
                        labelText: (AppLocalizations.of(context)!.translate('Email Address')),
                        labelStyle: TextStyle(color: Colors.grey),
                        suffix:
                            SvgPicture.asset('assets/icons/edit_outlined.svg')),
                  ),
                  SizedBox(
                    height: 40,
                  ),

                  Divider(),
                  ListTile(
                    onTap: () async {
                      logOff = true;
                      await Auth.signOut();
                      Navigator.of(context).popAndPushNamed('home');
                    },
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                    title: Text(AppLocalizations.of(context)!.translate('Log out')!, style: TextStyle(color: Color(0xff2a388f))),
                    leading: Icon(Icons.power_settings_new, color: Color(0xff2a388f),)
                  ),

                  Divider(),
                  ListTile(
                      onTap: () => Auth.deleteUser(context),
                      contentPadding: EdgeInsets.symmetric(vertical: 10),
                      title: Text(AppLocalizations.of(context)!.translate('Delete User')!, style: TextStyle(color: Colors.red)),
                      leading: Icon(Icons.delete, color:  Colors.red)
                  ),

                  // TextFormField(
                  //   initialValue: 'Password?..',
                  //   style: TextStyle(fontSize: 20),

                  //   decoration: InputDecoration(
                  //       labelText: 'Password',
                  //       labelStyle: TextStyle(color: Colors.grey),
                  //       suffix: SvgPicture.asset('assets/icons/edit_outlined.svg')
                  //   ),
                  // ),
                  // SizedBox(height: 30,),
                ],
              ),
            ),
          ),
        );
      },
    ));
  }
}
