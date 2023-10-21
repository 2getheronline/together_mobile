import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:together_online/app_localizations.dart';
import 'package:together_online/pages/join_group/pinCode.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/widgets/myFlatButton.dart';
import 'package:together_online/widgets/myRaisedButton.dart';
import '../../helper.dart';
import 'RScanCameraDialog.dart';
import 'dart:ui' as ui;

class JoinGroup extends StatefulWidget {
  _JoinGroupState createState() => _JoinGroupState();
}

class _JoinGroupState extends State<JoinGroup> {
  final _binding = DataBindingBase.getInstance();
  TextEditingController textEditingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, dynamic> form = {
    'password': null,
    'group_id': null,
  };

  @override
  void initState() {
    super.initState();
    textEditingController.addListener(() {
      setState(() => form['group_id'] = textEditingController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: DefaultTabController(
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomInset:
              false, // Fixes shrinking problem ehn keyboard shows up
          appBar: AppBar(
            automaticallyImplyLeading: true,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.grey),
            elevation: 0.0,
          ),
          body: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                      blurRadius: 2.0,
                      spreadRadius: 0.0,
                      color: shadow,
                      offset:
                          Offset(2.0, 2.0), // shadow direction: bottom right
                    )
                  ]),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .025),
                        Align(
                          alignment: _binding.selectedLanguage.language == "he" ? Alignment.centerRight : Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              AppLocalizations.of(context)!.translate('JOIN GROUP')!,
                              style: TextStyle(
                                  fontSize: Helper.normalizePixel(context, 30),
                                  color: black),
                            ),
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * .025),
                        TabBar(
                            indicatorColor: tabSelectColor,
                            labelStyle: TextStyle(
                                height: 2,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                            //For Selected tab
                            labelColor: tabSelectColor,
                            unselectedLabelStyle:
                                TextStyle(height: 2, fontSize: 15.0),
                            unselectedLabelColor: grey.withOpacity(.62),
                            tabs: [
//                      new Container(
//                        width: 50.0,
//                        child: new Tab(      child: Align(
//                            alignment: Alignment.centerLeft,
//                            child: Container(child: Text("QR Code", style: tabStyle(context)))),
//                        )),
//                      ),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        AppLocalizations.of(context)!.translate('QR Code')!,
                                        //     style: tabStyle(context),
                                      ))),
                              Align(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      AppLocalizations.of(context)!.translate('Number Code')!,
                                      //  style: tabStyle(context)
                                    ),
                                  ))
                            ]),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: TabBarView(children: [
                  FlatButton(
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  RScanCameraDialog()));
                      print(jsonDecode(result));
                      setState(() {
                        form['group_id'] = jsonDecode(result)['id'].toString();
                        form['password'] =
                            jsonDecode(result)['password'].toString();
                      });
                      joinUp();
                    },
                    child: Text(AppLocalizations.of(context)!.translate('Open camera')!),
                  ),
                  buildNumberCodeForm()
                ]),
              ),
            ],
          )),
    ));
  }

  TextStyle tabStyle(BuildContext context) {
    return TextStyle(fontSize: 15, height: 2);
  }

  Widget buildNumberCodeForm() {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * .02,
            ),
            Text(AppLocalizations.of(context)!.translate('Number Code')!),
            SizedBox(
                width: 100, child: TextField(controller: textEditingController, keyboardType: TextInputType.number, textAlign: TextAlign.center,)),
            SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.translate('Password')!),
            PinCode(
                pinLength: 6,
                callback: (val) =>
                    val != null ? setState(() => form['password'] = val) : ""),
            SizedBox(height: 4),
            MyRaisedButton(
              title: AppLocalizations.of(context)!.translate('JOIN UP')!,
              margin: 92,
              callback: (dynamic a) {
                joinUp();
              },
            )
          ],
        ),
      ),
    );
  }

  void joinUp() async {
    Navigator.of(context).pop(this.form);
  }
}
