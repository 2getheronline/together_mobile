import 'package:flutter/material.dart';
import 'package:together_online/pages/home.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/widgets/myFlatButton.dart';

class EnterConfirm extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  enter(context) {
    if (_formKey.currentState!.validate()) {
      localStorage.setItem("confirmed", true);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
    }
  }

  String? getError(s) => s == "963872" ? null : "קוד לא תקין";

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity),
            Text('נא להכניס קוד כניסה'),
            SizedBox(
                width: 250,
                child: Form(
                    key: _formKey,
                    child: TextFormField(
                        controller: textEditingController,
                        validator: getError))),
            FlatButton(onPressed: () => enter(context), title: "היכנס")
          ],
        ),
      );
}
