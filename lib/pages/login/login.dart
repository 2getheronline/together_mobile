// impt 'package:clip_shadow/clip_shadow.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:together_online/pages/login/forgot_password.dart';
import 'package:together_online/providers/AppGlobalData.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/widgets/custom_alert_dialog.dart';
import 'package:together_online/widgets/myRaisedButton.dart';
import 'dart:ui' as ui;
import '../../app_localizations.dart';

class Login extends StatefulWidget {
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _binding = DataBindingBase.getInstance();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Map<String, dynamic> form = {
    'password': null,
    'email': null,
  };
  bool _obscureText = true; // See or not the password
  void signIn(String provider) async {
    print('Trying to sign in via $provider');

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
        _formKey.currentState!.save();
        res = await Auth.signIn(form['email'], form['password']);
    }

    if (_binding.session?.auth?.blocked == true) {
      _showAlert(
          title: (AppLocalizations.of(context)!.translate("You have blocked")),
          content: (AppLocalizations.of(context)!
              .translate("Please contact admin")));
      return;
    }

    if (res['success']) {
      if (provider == 'email') {
        Auth.saveCredentials(form['email'], form['password'], provider);
      } else if (provider != null) {
        Auth.saveCredentials(null, null, provider);
      }
      //_binding.session?.auth?.language = AppGlobalData.getInstance().deviceLanguage;
      //await server!.editUser();
      Navigator.pop(context);
    } else {
      if (res['error'] != null) {
        _showAlert(
          title: "Login failed",
          content: res['error'],
          onPressed: () {},
        );
      }
    }
  }

  void openForgotPassword(BuildContext ctx) async {
    final email = await Navigator.push(
        ctx, MaterialPageRoute(builder: (context) => ForgotPassword()));

    if (email == null) return;
    final res = await Auth.forgotPassword(email);

    if (res['success']) {
      _showAlert(
        title: "Email sent!",
        content:
            "Please check your inbox for an email with instructions on how to recover your password.",
        onPressed: () {},
      );
    } else {
      _showAlert(
        title: "Oh oh!",
        content: res['error'] ?? 'Something went terribly wrong...',
        onPressed: () {},
      );
    }
  }

  // Option to see or not the input pasword
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool small_screen = MediaQuery.of(context).size.height < 750;
    print(MediaQuery.of(context).size.height);
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
          body: Observer(
            builder: (_) => SingleChildScrollView(
              child: Container(
                color: Colors.white,
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - 105),
                child:
                    // ClipShadow(
                    //   clipper:
                    //       MyClipper(screenHeight: MediaQuery.of(context).size.height),
                    //   boxShadow: [
                    //     BoxShadow(
                    //         color: Colors.blue[800],
                    //         offset: Offset(0, 1),
                    //         blurRadius: 40.0,
                    //         spreadRadius: 10.0,),
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
                        AppLocalizations.of(context)!
                            .translate("Welcome back")!,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.w700),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 28, right: 28, top: 5),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("Sign in to continue")!,
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
                          top: !small_screen ? 47 : 20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.translate("Email")!,
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: !small_screen ? 10 : 5),
                            TextFormField(
                              style: TextStyle(
                                fontSize: 17,
                              ),
                              onSaved: (val) => form['email'] = val,
                              validator: (val) {
                                return null;
                              },
                              decoration: InputDecoration(
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
                              AppLocalizations.of(context)!
                                  .translate("Password")!,
                              style: TextStyle(
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: !small_screen ? 10 : 5),
                            TextFormField(
                              style: TextStyle(
                                fontSize: 17,
                              ),
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
                                    .translate(
                                        'Must be at least 6 characters')),
                                errorStyle: TextStyle(color: Colors.red),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: !small_screen ? 13 : 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                openForgotPassword(context);
                              },
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('I don’t know my password')!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    decoration: TextDecoration.underline,
                                    fontSize: 15),
                              ),
                            ),
                            SizedBox(height: !small_screen ? 26 : 13),
                            MyRaisedButton(
                              title: (AppLocalizations.of(context)!
                                  .translate('LOG IN')),
                              width: MediaQuery.of(context).size.width - 40,
                              height: 53,
                              margin: 0,
                              callback: (dynamic a) {
                                signIn('email');
                                return true;
                              },
                            ),
                            // SizedBox(height: !small_screen ? 30 : 15),
                            // Container(
                            //     child: Row(
                            //   children: <Widget>[
                            //     Expanded(
                            //       child: new Container(
                            //           margin:
                            //               const EdgeInsets.only(right: 20.0),
                            //           child: Divider(
                            //             color: Colors.grey[400],
                            //             height: 36,
                            //           )),
                            //     ),
                            //     Text(
                            //       AppLocalizations.of(context)!
                            //           .translate("or")!,
                            //       style: TextStyle(
                            //         color: Colors.grey[400],
                            //       ),
                            //     ),
                            //     Expanded(
                            //       child: new Container(
                            //           margin: const EdgeInsets.only(left: 20.0),
                            //           child: Divider(
                            //             color: Colors.grey[400],
                            //             height: 36,
                            //           )),
                            //     ),
                            //   ],
                            // )),
                            // SizedBox(height: !small_screen ? 26 : 13),
                            // Container(
                            //   width: MediaQuery.of(context).size.width - 40,
                            //   height: 53,
                            //   child: TextButton(
                            //       style: TextButton.styleFrom(
                            //           shape: (RoundedRectangleBorder(
                            //             borderRadius:
                            //                 BorderRadius.circular(100),
                            //           )),
                            //           primary: Colors.black,
                            //           backgroundColor:
                            //               Color.fromRGBO(244, 245, 251, 1)),
                            //       onPressed: () {
                            //         signIn('google');
                            //       },
                            //       child: Row(
                            //         mainAxisAlignment: MainAxisAlignment.center,
                            //         children: [
                            //           SvgPicture.asset(
                            //               'assets/icons/social_media_icons/google.svg',
                            //               width: 24),
                            //           SizedBox(width: 5),
                            //           Text(
                            //             AppLocalizations.of(context)!.translate(
                            //                     'Continue with Google') ??
                            //                 "",
                            //             style: TextStyle(
                            //                 fontSize: 17,
                            //                 fontWeight: FontWeight.w400),
                            //           ),
                            //         ],
                            //       )),
                            // ),
                            // SizedBox(height: 14),
                            // if (Platform.isIOS)
                            //   Container(
                            //     width: MediaQuery.of(context).size.width - 40,
                            //     height: 53,
                            //     child: TextButton(
                            //         style: TextButton.styleFrom(
                            //             shape: (RoundedRectangleBorder(
                            //               borderRadius:
                            //                   BorderRadius.circular(100),
                            //             )),
                            //             primary: Colors.black,
                            //             backgroundColor:
                            //                 Color.fromRGBO(244, 245, 251, 1)),
                            //         onPressed: () {
                            //           signIn('apple');
                            //         },
                            //         child: Row(
                            //           mainAxisAlignment:
                            //               MainAxisAlignment.center,
                            //           children: [
                            //             SvgPicture.asset(
                            //                 'assets/icons/social_media_icons/apple.svg',
                            //                 width: 24),
                            //             SizedBox(width: 5),
                            //             Text(
                            //               AppLocalizations.of(context)!
                            //                       .translate(
                            //                           'Continue with Apple') ??
                            //                   "",
                            //               style: TextStyle(
                            //                   fontSize: 17,
                            //                   fontWeight: FontWeight.w400),
                            //             ),
                            //           ],
                            //         )),
                            //   ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          backgroundColor: Color.fromRGBO(243, 244, 248, 1),
        ));
  }

  void _showAlert({String? title, String? content, VoidCallback? onPressed}) {
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
