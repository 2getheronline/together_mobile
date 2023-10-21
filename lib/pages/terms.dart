import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:together_online/app_localizations.dart';
import 'package:together_online/pages/home.dart';
import 'package:together_online/providers/AppGlobalData.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/widgets/myRaisedButton.dart';

class Terms extends StatelessWidget {
  void agreeCallback(context) async {
    AppGlobalData.getInstance().termsAgreed = true;
    localStorage.setItem("TERMS_AGREED", true);
    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Container(
                margin: const EdgeInsets.only(bottom:10.0, top: 10.0),
                child: Column(children: [
                  Expanded(child: Text("Some great text to agree to")),
                  MyRaisedButton(
                    title: (AppLocalizations.of(context)!.translate("I AGREE")),
                    //margin: 92,
                    callback: agreeCallback
                  )
        ]))));
  }
}
