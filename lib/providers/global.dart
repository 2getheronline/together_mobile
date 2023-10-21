import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:together_online/widgets/custom_alert_dialog.dart';
import 'package:together_online/widgets/myRaisedButton.dart';

import '../app_localizations.dart';

late BuildContext globalCtx;

class Global extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    globalCtx = context;
    print('---------->added ctx!<----------');
    return Container();
  }
}

double globalWidth = MediaQuery.of(globalCtx).size.width;
double globalHeight = MediaQuery.of(globalCtx).size.height;

Future<void> showAlert(
    BuildContext context, String title, String content, dynamic onPressed) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return CustomAlertDialog(
        content: content,
        title: title,
        onPressed: () {
          onPressed();
        },
      );
    },
  );
}

Future<void> showWellDone({
  required BuildContext context,
  required int? points,
}) {
  return showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          child: Container(
            height: globalHeight * .65,
            width: globalWidth,
            child: Stack(
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 70,
                    ),
                    Container(
                      width: double.infinity,
                      //height: double.infinity,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 22),
                            child: SvgPicture.asset(
                                'assets/icons/well_done_icon.svg'),
                          ),
                          SizedBox(height: 25),
                          Text(
                            AppLocalizations.of(context)!
                                .translate('Well done!')!,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 8,
                            ),
                            child: Text(
                              AppLocalizations.of(context)!
                                      .translate('You got')! +
                                  ' $points ' +
                                  AppLocalizations.of(context)!
                                      .translate('points')! +
                                  AppLocalizations.of(context)!
                                      .translate(' for this mission')!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 16),
                            ),
                          ),
                          // FloatingActionButton.extended(
                          //   onPressed: () {},
                          //   backgroundColor: Color(0xFF2a388f),
                          //   elevation: 0,
                          //   icon: Icon(Icons.share),
                          //   label: Text(
                          //     AppLocalizations.of(context)!.translate('share mission')!.toUpperCase(),
                          //     style: TextStyle(fontWeight: FontWeight.bold),
                          //   ),
                          // ),
                          SizedBox(
                            height: 36,
                          ),
                          MyRaisedButton(
                            height: 53,
                            width: globalWidth,
                            margin: 25.0,
                            title: (AppLocalizations.of(context)!
                                .translate('NEXT MISSION')),
                            callback: (dynamic a) {
                              Navigator.of(context, rootNavigator: true)
                                ..pop()
                                ..pop();
                              return true;
                            },
                          ),
                          SizedBox(
                            height: 23,
                          ),
                          GestureDetector(
                            onTap: () =>
                                Navigator.of(context, rootNavigator: true)
                                  ..pop()
                                  ..pop(),
                            child: Text(
                              AppLocalizations.of(context)!.translate('Close')!,
                              style: TextStyle(
                                  color: Color.fromRGBO(57, 80, 219, 1),
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                  fontSize: 16),
                            ),
                          ),
                          SizedBox(
                            height: 29,
                          ),
                          // RaisedButton(
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(40))),
                          //   color: Colors.white,
                          //   elevation: 0,
                          //   onPressed: () =>
                          //       Navigator.of(context, rootNavigator: true)
                          //         ..pop()
                          //         ..pop(),
                          //   child: Container(
                          //     padding: EdgeInsets.symmetric(
                          //       vertical: 9,
                          //       horizontal: 32,
                          //     ),
                          //     decoration: BoxDecoration(
                          //         borderRadius:
                          //             BorderRadius.all(Radius.circular(40)),
                          //         border: Border.all(color: Color(0xFF2a388f))),
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       children: <Widget>[
                          //         Icon(Icons.navigate_next), //TODO: change
                          //         Text(
                          //           'next mission'.toUpperCase(),
                          //           style: TextStyle(
                          //             fontWeight: FontWeight.bold,
                          //             color: Color(0xFF2a388f),
                          //           ),
                          //         ),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      });
}
