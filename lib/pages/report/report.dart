import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:together_online/models/message.dart';
import 'package:together_online/pages/home.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/database.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/widgets/custom_alert_dialog.dart';
import 'package:together_online/widgets/raised_button.dart';
import 'dart:ui' as ui;

import '../../app_localizations.dart';

class AddReport extends StatefulWidget {
  static const routeName = '/addReport';

  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  final _formKey = GlobalKey<FormState>();
  final _binding = DataBindingBase.getInstance();

  TextEditingController _linkController = TextEditingController();

  String? url;
  String? observations;

  bool loading = false;

  sendReport() async {
    _formKey.currentState!.save();

    server!
        .sendReport(Message(link: url, content: observations))
        .then((_) => result('Success', "Thanks about report")
        .catchError((onError) => result('Error', "Error while sending report")));
  }

  result(title, content) => showDialog(
      barrierDismissible: false,
      context: context,
      builder: (c) => CustomAlertDialog(
        content: AppLocalizations.of(context)!.translate(content),
        title: AppLocalizations.of(context)!.translate(title),
        onPressed: () => Navigator.of(context).pop(),
      ));

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child:  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.close,
              size: 30,
              color: Colors.grey,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Text(
                  AppLocalizations.of(context)!.translate(
                      'Have you found a post against Israel and you want to tell us about it?')!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: globalHeight * .028),
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: TextFormField(
                  controller: _linkController,
                  onSaved: (_) => url = _,
                  decoration: InputDecoration(
                    hintText:
                        (AppLocalizations.of(context)!.translate("paste link")),
                    hintStyle: TextStyle(
                      fontSize: globalHeight * .025,
                      color: Color(0xff313136).withOpacity(.55),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        ClipboardData data =
                            await (Clipboard.getData('text/plain') as Future<ClipboardData>);
                        _linkController.value =
                            TextEditingValue(text: data.text!);
                      },
                      child: Icon(
                        Icons.content_copy,
                        size: globalHeight * .03,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                child: TextFormField(
                  onSaved: (_) => observations = _,
                  decoration: InputDecoration(
                    hintText: (AppLocalizations.of(context)!
                        .translate("observations")),
                    hintStyle: TextStyle(
                      fontSize: globalHeight * .025,
                      color: Color(0xff313136).withOpacity(.55),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 85),
                child: RaisedButton(
                  elevation: 0,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35)),
                  color: Color(0xff2a388f),
                  onPressed: loading ? null : sendReport,
                  child: Text(
                    AppLocalizations.of(context)!.translate("send us")!
                        .toUpperCase(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: globalHeight * .020),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
