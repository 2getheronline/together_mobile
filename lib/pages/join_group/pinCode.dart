import 'package:flutter/services.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:together_online/widgets/myFlatButton.dart';

import '../../helper.dart';

class PinCode extends StatefulWidget {

  final Function? callback;
  final int? pinLength;
  PinCode({this.callback, this.pinLength});

  _PinCodeState createState() => _PinCodeState();
}

class _PinCodeState extends State<PinCode> {

  TextEditingController controller = TextEditingController(text: "");
  String thisText = "";
  bool hasError = false;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Container(
            height: 100.0,
            child: GestureDetector(
              onLongPress: () {
                print("LONG");
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text("Paste clipboard stuff into the pinbox?"),
                        actions: <Widget>[
                          FlatButton(
                              onPressed: () async {
                                var copiedText =
                                    await (Clipboard.getData("text/plain") as Future<ClipboardData>);
                                if (copiedText.text!.isNotEmpty) {
                                  controller.text = copiedText.text!;
                                }
                                Navigator.of(context).pop();
                              },
                              child: Text("YES")),
                          FlatButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("No"))
                        ],
                      );
                    });
              },
              child: PinCodeTextField(
                autofocus: true,
                controller: controller,
                highlight: true,
                highlightColor: Colors.blue,
                defaultBorderColor: pinCodeBorder,
                hasTextBorderColor: Colors.green,
                maxLength: widget.pinLength!,
                hasError: hasError,
                onTextChanged: (text) {
                  setState(() {
                    hasError = false;
                    widget.callback!(text);

                  });
                },
                onDone: (text) {
                  print("DONE $text");
                  print("DONE CONTROLLER ${controller.text}");
                  widget.callback!(text);

                },
                wrapAlignment: WrapAlignment.spaceAround,
                pinBoxDecoration:
                    ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
                pinTextStyle: TextStyle(fontSize: 20.0),
                pinTextAnimatedSwitcherTransition:
                    ProvidedPinBoxTextAnimation.scalingTransition,
//                    pinBoxColor: Colors.green[100],
                pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
//                    highlightAnimation: true,
                keyboardType: TextInputType.number,
                  pinBoxWidth: 50
              ),
            ),
          ),
          Visibility(
            child: Text(
              "Wrong PIN!",
              style: TextStyle(color: Colors.red),
            ),
            visible: hasError,
          ),
        ]);
  }
}
