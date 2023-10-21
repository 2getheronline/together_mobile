import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:together_online/helper.dart';
import 'package:together_online/pages/home/navigator.dart';
import 'package:together_online/pages/login/login.dart';
import 'package:together_online/pages/login/register.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/widgets/myFlatButton.dart';
import 'package:together_online/widgets/myRaisedButton.dart';
import 'dart:ui' as ui;

import '../app_localizations.dart';
import 'join_group/join_group.dart';

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _binding = DataBindingBase.getInstance();

  @override
  void initState() {
    super.initState();

    autoLogin();
    Auth.firebaseAuth.authStateChanges().listen((account) {
      handleSignIn(account);
    });
  }

  autoLogin() async {
    final token = await Auth.getToken();
    if (token != null) {
      server!.addToken(token);
      server!.loadUser();
      return;
    }
    final credentials = await Auth.getCredentials();

    if (credentials['email'] != null &&
        credentials['password'] != null &&
        credentials['preferedProvider'] == 'email') {
      await Auth.signIn(credentials['email'], credentials['password']);
    } else if (credentials['preferedProvider'] != null) {
      switch (credentials['preferedProvider']) {
        case 'facebook':
          await Auth.signInWithFacebook();
          break;
        case 'google':
          await Auth.signInWithGoogle();
          break;
        case 'apple':
          // await Auth.signInWithApple();
          break;
        default:
          break;
      }
    }
  }

  handleSignIn(User? account) async {}

  login(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()))
        .then((a) {
      Auth.firebaseAuth.authStateChanges().listen((account) {
        handleSignIn(account);
      });
    });
  }

  register(context) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => Register()));
    Auth.firebaseAuth.authStateChanges().listen((account) {
      handleSignIn(account);
    });
  }

  joinGroup(context) async {
    final form = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => JoinGroup()));
    if (form != null) {
      Auth.groupId = form['group_id'] ?? null;
      Auth.groupPassword = form['password'];
      register(context);
    }
  }

  Widget buildSplashScreen() {
    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/flag-background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 200,
                        child: Text(
                          AppLocalizations.of(context)!
                                  .translate('Speaking up for Israel') ??
                              '',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 50),
                      MyRaisedButton(
                        title:
                            (AppLocalizations.of(context)!.translate('LOG IN')),
                        width: MediaQuery.of(context).size.width - 40,
                        height: 53,
                        margin: 0,
                        callback: login,
                      ),
                      SizedBox(height: 22),
                      Container(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 53,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              shape: (RoundedRectangleBorder(
                                side: BorderSide(
                                    color: Colors.white,
                                    width: 1,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(100),
                              )),
                              primary: Colors.white),
                          onPressed: () => register(context),
                          child: Text(
                            AppLocalizations.of(context)!
                                    .translate('CREATE ACCOUNT') ??
                                "",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      // MyRaisedButton(
                      //   title: AppLocalizations.of(context)!
                      //       .translate('CREATE ACCOUNT'),
                      //   callback: register,
                      //   width: MediaQuery.of(context).size.width - 40,
                      //   height: 53,
                      //   margin: 0,
                      // ),
                      SizedBox(height: 22),
                      MyRaisedButton(
                        title: AppLocalizations.of(context)!
                            .translate('JOIN GROUP'),
                        callback: joinGroup,
                        width: MediaQuery.of(context).size.width - 40,
                        height: 53,
                        margin: 0,
                      ),
                      SizedBox(height: 22),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    globalCtx = context;
    return Observer(
        builder: (_) =>
            _binding.session != null && _binding.session!.auth != null
                ? HomeNavigator()
                : buildSplashScreen());
  }
}
