import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:together_online/app_localizations.dart';
import 'package:together_online/models/mission.dart';
import 'package:together_online/pages/mission/webview.dart';
import 'package:together_online/pages/mission/mission.dart' as Page;
import 'package:together_online/providers/AppGlobalData.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/widgets/myRaisedButton.dart';
import 'dart:ui' as ui;

class PlatformLogin extends StatefulWidget {
  final Mission mission;

  const PlatformLogin({Key? key, required this.mission}) : super(key: key);

  @override
  _PlatformLoginState createState() => new _PlatformLoginState();
}

loginHandler(context, Mission mission) async {
  await AppGlobalData.getInstance().setPlatformLoggedIn(mission.target!.name!);
  Navigator.of(context).pop(true);
  Navigator.of(context).pop(true);
  // await Navigator.of(context).pushNamed('mission',
  //                   arguments: {'mission': mission});

  // await AppGlobalData.getInstance().setPlatformLoggedIn(mission.target!.name!);
  // Navigator.of(context).pop();
  // var missionPage = Page.Mission(fromPlatformLogin: true);
  // missionPage.acceptChallenge(context, mission);
  
  // await Navigator.pushAndRemoveUntil(
  //           context,
  //           MaterialPageRoute(builder: (context) => Page.Mission(fromPlatformLogin: true)),
  //           (Route<dynamic> route) => false,
  //         );
}

confirmLogin(parentContext, Mission mission) {
  var _binding = DataBindingBase.getInstance();
  showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child:  AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text((AppLocalizations.of(context)!.translate("Are you sure?"))!),
            content: Text(
              AppLocalizations.of(context)!.translate("Are you sure you have successfully logged in to the platform?")!),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    (AppLocalizations.of(context)!.translate("No, go back to login")!),
                    style: TextStyle(
                      color: Colors.redAccent,
                    ),
                  )),
              TextButton(
                onPressed: () => loginHandler(parentContext, mission),
                child: Text(
                  (AppLocalizations.of(context)!.translate("Yes, I'm done")!),
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ]));
      });
}

class _PlatformLoginState extends State<PlatformLogin> {
  var _binding = DataBindingBase.getInstance();
  late InAppWebViewController webView;
  bool doneLoading = false;

  @override
  Widget build(BuildContext context) {
    //(AppLocalizations.of(context)!.translate("Still loading...")!)
    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Container(
                child: Column(
      children: [
        Expanded(
            child: InAppWebView(
              
          initialUrlRequest: URLRequest(url: Uri.parse('about:blank')),
          initialOptions: InAppWebViewGroupOptions(
            android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
            ),
            crossPlatform: InAppWebViewOptions(
              userAgent: Platform.isAndroid ?
                  "Mozilla/5.0 (Linux; Android 10; SM-G981B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.162 Mobile Safari/537.36":
                  "Mozilla/5.0 (iPhone; CPU iPhone OS 15_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.5 Mobile/15E148 Safari/604.1"

            ),
          ),
          onWebViewCreated: (InAppWebViewController controller) {
            webView = controller;
            webView.loadUrl(
                urlRequest: URLRequest(
                    url: Uri.parse(AppGlobalData()
                        .getPlatformLoginUrl(widget.mission.target!.name!))));
          },
          onLoadStop: (InAppWebViewController controller, Uri? url) async {
            Future.delayed(const Duration(seconds: 2), () {
              doneLoading = true;
              setState(() {});
            });
          },
        )),
        Container(
          child: MyRaisedButton(
            title: doneLoading ? (AppLocalizations.of(context)!.translate("I'm done")!) : (AppLocalizations.of(context)!.translate("Still loading...")!),
            isEnabled: doneLoading,
            callback: (dynamic a) {
              confirmLogin(context, widget.mission);
              return;
            },
          ),
          margin: EdgeInsets.symmetric(vertical: 20),
        )
      ],
    )))));
  }
}
