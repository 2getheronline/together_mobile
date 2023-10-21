// import 'package:clip_shadow/clip_shadow.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/widgets/custom_alert_dialog.dart';
import 'package:together_online/widgets/myRaisedButton.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

import '../../app_localizations.dart';

final FacebookAuthProvider facebookAuth = FacebookAuthProvider();
final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

class Register extends StatefulWidget {
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _binding = DataBindingBase.getInstance();

  Map<String, dynamic> form = {
    'name': null,
    'password': null,
    'email': null,
  };

  bool agreeToTOS = false;

  @override
  void initState() {
    Auth.getCredentials().then((credentials) {
      if (credentials['email'] == null) return;

      form['email'] = credentials['email'];
      form['password'] = credentials['password'];
    });

    super.initState();
  }

  void signUp(String provider) async {
    dynamic res;

    switch (provider) {
      case 'facebook':
        res = await Auth.signInWithFacebook();
        break;
      case 'google':
        res = await Auth.signInWithGoogle();
        break;
      case 'apple':
        // res = await Auth.signInWithApple();
        break;
      default:
        if (!agreeToTOS) return;
        _formKey.currentState!.save();
        res = await Auth.signUp(form['email'], form['password'], form['name']);
    }

    if (res['success']) {
      if (Auth.rememberMe!) {
        if (provider == 'email') {
          Auth.saveCredentials(form['email'], form['password'], provider);
        } else if (provider != null) {
          Auth.saveCredentials(null, null, provider);
        }
      }
      Navigator.pop(context);
    } else {
      if (res['error'] != null) {
        print(res['error']);
        _showErrorAlert(
          title: "Login failed",
          content: res['error'],
          onPressed: () {},
        );
      }
    }
  }

  bool _obscureText = true; // See or not the password

  // Option to see or not the input pasword
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget build(BuildContext context) {
    bool small_screen = MediaQuery.of(context).size.height < 750;

    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Scaffold(
          resizeToAvoidBottomInset:
              false, // Fixes shrinking problem ehn keyboard shows up
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.grey),
            elevation: 0.0,
          ),
          body: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 105),
              color: Colors.white,
              child:
                  // ClipShadow(
                  //   clipper:
                  //       MyClipper(screenHeight: MediaQuery.of(context).size.height),
                  //   boxShadow: [
                  //     BoxShadow(
                  //         color: Colors.blue[800],
                  //         offset: Offset(0, 1),
                  //         blurRadius: 40.0,
                  //         spreadRadius: 10.0),
                  //   ],
                  //   child: Container(
                  //     decoration: BoxDecoration(color: Colors.white),
                  //   ),
                  // ),
                  Column(
                //mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 28, right: 28),
                    child: Text(
                      AppLocalizations.of(context)!.translate("Welcome")!,
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 28, right: 28, top: 5),
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate("Sign up to continue")!,
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        bottom: 30,
                        right: 20,
                        left: 20,
                        top: !small_screen ? 42 : 15),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!
                                .translate("Username")!,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: !small_screen ? 10 : 5),
                          TextFormField(
                            style: TextStyle(fontSize: 17),
                            textCapitalization: TextCapitalization.words,
                            onSaved: (val) => form['name'] = val,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return null;
                              } else if (val.trim().length < 2) {
                                return "Name too short";
                              } else if (val.trim().length > 12) {
                                return "Name too long";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              // suffix: IconButton(
                              //   icon: Icon(Icons.ac_unit,
                              //       color: Colors.transparent),
                              //   onPressed: null,
                              // ), //So para cada campó ter o mesmo tamanho, afinal o icone aumenta o tamanho do icone
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(230, 232, 240, 1),
                                ),
                              ),
                              errorStyle: TextStyle(color: Colors.red),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: !small_screen ? 24 : 12),
                          Text(
                            AppLocalizations.of(context)!.translate("Email")!,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: !small_screen ? 10 : 5),
                          TextFormField(
                            style: TextStyle(fontSize: 17),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (val) => form['email'] = val,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(230, 232, 240, 1),
                                ),
                              ),
                              // suffix: IconButton(
                              //   icon: Icon(Icons.ac_unit,
                              //       color: Colors.transparent),
                              //   onPressed: null,
                              // ), //So para cada campó ter o mesmo tamanho, afinal o icone aumenta o tamanho do icone
                              labelStyle: TextStyle(fontSize: 19),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: !small_screen ? 24 : 12),
                          Text(
                            AppLocalizations.of(context)!
                                .translate("Password")!,
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: !small_screen ? 10 : 5),
                          TextFormField(
                            style: TextStyle(fontSize: 17),
                            obscureText: _obscureText, // Password Style
                            onSaved: (val) => form['password'] = val,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return null;
                              } else if (val.trim().length < 6) {
                                return "Password too short";
                              } else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              // icon:
                              //suffix:
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromRGBO(230, 232, 240, 1),
                                ),
                              ),
                              suffixIcon: IconButton(
                                icon: _obscureText
                                    ? Icon(
                                        Icons.visibility,
                                        color: Colors.grey,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey,
                                      ),
                                onPressed: _toggle,
                              ),
                              hintText: (AppLocalizations.of(context)!
                                  .translate('Must be at least 6 characters')),
                              errorStyle: TextStyle(color: Colors.red),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(children: [
                            SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Checkbox(
                                value: agreeToTOS,
                                onChanged: (b) =>
                                    setState(() => agreeToTOS = b!),
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            RichText(
                                text: TextSpan(
                                    style: TextStyle(fontSize: 14),
                                    children: [
                                  TextSpan(
                                      text: AppLocalizations.of(context)!
                                              .translate("tos.i_agree")! +
                                          " ",
                                      style: TextStyle(color: Colors.black87)),
                                  TextSpan(
                                    text: AppLocalizations.of(context)!
                                        .translate("tos.link")!,
                                    style: new TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                    recognizer: new TapGestureRecognizer()
                                      ..onTap = () {
                                        launch(_binding.selectedLanguage
                                                    .language ==
                                                "he"
                                            ? 'https://together.clap.co.il/privacy_heb.pdf'
                                            : 'https://together.clap.co.il/privacy.pdf');
                                      },
                                  )
                                ]))
                          ]),
                          SizedBox(height: !small_screen ? 20 : 10),
                          MyRaisedButton(
                            title: (AppLocalizations.of(context)!
                                .translate('CREATE ACCOUNT')),
                            width: MediaQuery.of(context).size.width - 40,
                            height: 53,
                            margin: 0,
                            callback: (dynamic a) {
                              signUp('email');
                              return true;
                            },
                          ),
                          SizedBox(height: !small_screen ? 15 : 7),
                          Container(
                              child: Row(
                            children: <Widget>[
                              Expanded(
                                child: new Container(
                                    margin: const EdgeInsets.only(right: 20.0),
                                    child: Divider(
                                      color: Colors.grey[400],
                                      height: 36,
                                    )),
                              ),
                              Text(
                                AppLocalizations.of(context)!.translate("or")!,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                ),
                              ),
                              Expanded(
                                child: new Container(
                                    margin: const EdgeInsets.only(left: 20.0),
                                    child: Divider(
                                      color: Colors.grey[400],
                                      height: 36,
                                    )),
                              ),
                            ],
                          )),
                          SizedBox(height: !small_screen ? 12 : 6),
                          Container(
                            width: MediaQuery.of(context).size.width - 40,
                            height: 53,
                            child: TextButton(
                                style: TextButton.styleFrom(
                                    shape: (RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                    )),
                                    primary: Colors.black,
                                    backgroundColor:
                                        Color.fromRGBO(244, 245, 251, 1)),
                                onPressed: () {
                                  signUp('google');
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                        'assets/icons/social_media_icons/google.svg',
                                        width: 24),
                                    SizedBox(width: 5),
                                    Text(
                                      AppLocalizations.of(context)!.translate(
                                              'Continue with Google') ??
                                          "",
                                      style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                )),
                          ),
                          SizedBox(height: !small_screen ? 8 : 4),
                          if (Platform.isIOS)
                            Container(
                              width: MediaQuery.of(context).size.width - 40,
                              height: 53,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      shape: (RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      )),
                                      primary: Colors.black,
                                      backgroundColor:
                                          Color.fromRGBO(244, 245, 251, 1)),
                                  onPressed: () {
                                    signUp('apple');
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/social_media_icons/apple.svg',
                                          width: 24),
                                      SizedBox(width: 5),
                                      Text(
                                        AppLocalizations.of(context)!.translate(
                                                'Continue with Apple') ??
                                            "",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  )),
                            ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: Color.fromRGBO(243, 244, 248, 1),
        ));
  }

  void _showErrorAlert(
      {String? title, String? content, VoidCallback? onPressed}) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          content: content,
          title: title,
          onPressed: onPressed,
        );
      },
    );
  }
}

class MyClipper extends CustomClipper<Path> {
  double? screenHeight = 1000;
  final ratio = .45;

  MyClipper({screenHeight}) {
    this.screenHeight = screenHeight;
  }
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, screenHeight! * ratio);
    path.quadraticBezierTo(size.width / 2, screenHeight! * ratio + 100,
        size.width, screenHeight! * ratio);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(MyClipper oldClipper) => true;
}
