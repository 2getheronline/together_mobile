import 'package:flutter/material.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/widgets/raised_button.dart';

import '../../app_localizations.dart';
import 'dart:ui' as ui;

class SecurityPage extends StatefulWidget {
  static const routeName = '/securityPage';
  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final _formKey = GlobalKey<FormState>();
  var _binding = DataBindingBase.getInstance();

  String? newPass;
  String? newPassDup;

  changePassword() {
    _formKey.currentState!.save();

    if (newPass != newPassDup) {
      showAlert(context, 'Opsie!', "Your new password doesn't match. ", () {Navigator.of(context).pop();});
    } else {
      Auth.updatePassword('', newPass!);
    }
  }

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                AppLocalizations.of(context)!.translate('security')!,//Security
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: globalHeight * .025,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: (AppLocalizations.of(context)!.translate("Old password")),
                    hintStyle: TextStyle(
                      fontSize: globalHeight * .022,
                      color: Color(0xff313136).withOpacity(.55),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: TextFormField(
                  onSaved: (_) => newPass = _,
                  decoration: InputDecoration(
                    hintText: (AppLocalizations.of(context)!.translate("New password")),
                    hintStyle: TextStyle(
                      fontSize: globalHeight * .022,
                      color: Color(0xff313136).withOpacity(.55),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: TextFormField(
                  onSaved: (_) => newPassDup = _,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!
                              .translate("Confirm password")!,
                    hintStyle: TextStyle(
                      fontSize: globalHeight * .022,
                      color: Color(0xff313136).withOpacity(.55),
                    ),
                  ),
                ),
              ),
              Row(
                // To center the button
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 85),
                    child: RaisedButton(
                      elevation: 0,
                      padding:
                          EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35)),
                      color: Color(0xff2a388f),
                      onPressed: changePassword,
                      child: Text(
                        AppLocalizations.of(context)!.translate("send")!.toUpperCase(),
                        style: TextStyle(
                            color: Colors.white, fontSize: globalHeight * .020),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
