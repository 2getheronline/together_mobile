import 'package:flutter/material.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/widgets/myRaisedButton.dart';
import 'dart:ui' as ui;

import '../../app_localizations.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  var _binding = DataBindingBase.getInstance();

  String? email;

  submit() {
    final form = _formKey.currentState!;
    form.save();
    Navigator.pop(context, email);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Scaffold(
          resizeToAvoidBottomInset:
              false, // Fixes shrinking problem when keyboard shows up
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.grey),
            elevation: 0.0,
          ),
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.symmetric(
                vertical: globalHeight * .05, horizontal: globalHeight * .03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!
                      .translate('reset_password_title')!,
                  style: TextStyle(
                    fontSize: globalHeight * 0.03,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: globalHeight * 0.03),
                Text(
                  AppLocalizations.of(context)!.translate(
                      'Enter the email associated with your account and we\'ll send an email with instructions to reset your password.')!,
                  style: TextStyle(
                      color: Colors.grey, fontSize: globalHeight * .02),
                ),
                SizedBox(height: globalHeight * 0.04),
                Form(
                  key: _formKey,
                  child: TextFormField(
                    onSaved: (val) => email = val,
                    validator: (val) {
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: (AppLocalizations.of(context)!
                          .translate('Email address')),
                      labelStyle: TextStyle(fontSize: 19),
                      errorStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                SizedBox(height: globalHeight * 0.04),
                MyRaisedButton(
                  context: context,
                  title: AppLocalizations.of(context)!
                      .translate('RESET PASSWORD')!,
                  callback: (dynamic a) {
                    submit();
                    return true;
                  },
                )
              ],
            ),
          ),
        ));
  }
}
