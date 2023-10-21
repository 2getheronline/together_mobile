import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart' as intl;
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:together_online/models/action.dart' as ActionModel;
import 'package:together_online/models/mission.dart' as Model;
import 'package:together_online/models/target.dart';
import 'package:together_online/pages/mission/platform_login.dart';
import 'package:together_online/pages/mission/webview.dart';
import 'package:together_online/providers/AppGlobalData.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/database.dart';
import 'package:together_online/providers/global.dart' as Global;
import 'package:together_online/providers/global.dart';
import 'package:together_online/providers/missions_provider.dart' as Provider;
import 'package:together_online/widgets/custom_alert_dialog.dart';
import 'package:together_online/widgets/myRaisedButton.dart';
import 'package:flutter_html/flutter_html.dart';
import 'dart:ui' as ui;

import '../../app_localizations.dart';
import '../../helper.dart';

Widget targetWidget(Target target) {
  return SvgPicture.network(
    target.icon!,
    height: 15,
    width: 15,
  );
}

class Mission extends StatelessWidget {
  Mission({Key? key}) : super(key: key);
  var _binding = DataBindingBase.getInstance();
  bool isAfterPlatformLogin = false;
  final Color timeColor = Color(0xB365656d);
  final Color mainColor = Color(0xff65656d);

  _showAlert(
      BuildContext context, String title, String content, dynamic onPressed) {
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

  finalizeMission(
      context, Model.Mission mission, Map<String, bool> actions) async {
    return missionCompleted(context, mission);
//    bool allCompleted = true;
//    try {
//      mission.actions.forEach((f) {
//        print('${f.name} - ${actions[f.name]}');
//        if (actions[f.name] == false || actions[f.name] == null)
//          allCompleted = false;
//      });
//    } catch (e) {
//      allCompleted = false;
//    }
//
//    if (!allCompleted && actions != null) {
//      saveOngoingMission(mission, actions);
//      actions.removeWhere((k, v) => v == true);
//      List<String> list = actions.keys.toList();
//      String l = '';
//      list.forEach((f) => l += '$f, ');
//      _showAlert(
//          context, 'Opsie!', 'There are a few things left to do: \n $l', () {});
//      return;
//    } else if (actions == null) {
//      print('Actions null');
//      _showAlert(context, 'Error', 'Something went wrong...', () {});
//    } else {
//      try {
//        await missionCompleted(context, mission);
//      } catch (e) {
//        print('An error occured');
//        _showAlert(context, 'Error', 'Something went wrong...', () {});
//      }
//    }
  }

  Future<bool> missionCompleted(
      BuildContext context, Model.Mission mission) async {
    dynamic res;
    try {
      res = await Provider.missionCompleted(mission);

      if (res['success']) {
        await Global.showWellDone(context: context, points: mission.points);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print('$e');
      _showAlert(context, 'Uh oh!', 'Something went wrong...', () {});
      return false;
    }
  }

  saveOngoingMission(Model.Mission mission, Map<String, bool> actions) async {
    final a = Map.from(actions);
    a.removeWhere((k, v) => v == null || v == false);
    await Database.saveMission(
        {...mission.toObj(), 'completedActions': a.keys.toList()});
  }

  Future<bool> handleYoutubeCreateChannel(
      BuildContext context, Model.Mission mission) async {
    final channelCreated = await Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) => Webview(
              createYoutubeChannel: true,
            )));
    print('Channel Created? ' + channelCreated.toString());
    if (channelCreated != null && channelCreated) {
      return true;
    } else {
      _showAlert(
          context,
          'Uh oh!',
          'You must create a YouTube Channel to be able to complete this mission',
          () {});
      return false;
    }
  }

  Future<Map<String, bool>?> navigateToMission(
      context, Model.Mission mission, args) async {
    Map<String, bool>? result;

    result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Webview(
          mission: mission,
          args: args,
        ),
      ),
    );

    return result;
  }

  Future<String?> commentDialog(context, List<String> cs) {
    final comments = cs.map((c) {
      return ListTile(
        title: Text(c),
        onTap: () {
          Navigator.pop(context, c);
        },
      );
    }).toList();

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
              width: Global.globalWidth * .6,
              height: Global.globalHeight * .7,
              child: Column(
                children: comments,
              )),
          title: Text(
              AppLocalizations.of(context)!.translate('Choose a comment')!),
        );
      },
    );
  }

  Future<dynamic> handleYoutubeComment(
      BuildContext context, Model.Mission mission) async {
    String? selectedComment;

    if (mission.proposedComments != null) {
      selectedComment = await commentDialog(context, mission.proposedComments!);
    } else {
      print('No comments provided');
      selectedComment = '';
    }

    try {
      final r =
          await Provider.Youtube.commentVideo(mission.url, selectedComment);
      return r;
    } catch (e) {
      print('error -> $e');
      if (e == 'ineligibleAccount') {
        final r = await handleYoutubeCreateChannel(context, mission);
        return r;
      } else if (e == 'youtubeSignupRequired') {
        throw 'youtubeSignupRequired';
      } else {
        print('Error on CommentVideo: $e');
        return false;
      }
    }
  }

  Future<dynamic> handleFacebookComment(
      BuildContext context, Model.Mission mission) async {
    String? selectedComment;

    if (mission.proposedComments != null) {
      selectedComment = await commentDialog(context, mission.proposedComments!);
    } else {
      print('No comments provided');
      selectedComment = '';
    }

    try {
      final r =
          await Provider.Facebook.commentPost(mission.url, selectedComment);
      return r;
    } catch (e) {
      print('Error on CommentPost: $e');
      return false;
    }
  }

  handleGoogleChallenge(context, Model.Mission mission) async {
    final bool hasRate =
        mission.actions!.contains(ActionModel.actionsMap['rate']) &&
            !mission.completedActions.contains(ActionModel.actionsMap['rate']);
    final bool hasComment = mission.actions!
            .contains(ActionModel.actionsMap['comment']) &&
        !mission.completedActions.contains(ActionModel.actionsMap['comment']);

    Map<String, bool>? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Webview(
            mission: mission,
            args: {'hasRate': hasRate, 'hasComment': hasComment}),
      ),
    );

    if (result == null) return;

    finalizeMission(context, mission, result);
  }

  handleYoutubeChallenge(context, Model.Mission mission) async {
    final bool hasLike =
        mission.actions!.contains(ActionModel.actionsMap['like']) &&
            !mission.completedActions.contains(ActionModel.actionsMap['like']);
    final bool hasComment = mission.actions!
            .contains(ActionModel.actionsMap['comment']) &&
        !mission.completedActions.contains(ActionModel.actionsMap['comment']);
    final bool hasReport = mission.actions!
            .contains(ActionModel.actionsMap['report']) &&
        !mission.completedActions.contains(ActionModel.actionsMap['report']);
    final bool hasShare =
        mission.actions!.contains(ActionModel.actionsMap['share']) &&
            !mission.completedActions.contains(ActionModel.actionsMap['share']);
    final bool hasDislike = mission.actions!
            .contains(ActionModel.actionsMap['dislike']) &&
        !mission.completedActions.contains(ActionModel.actionsMap['dislike']);

    Map<String, bool>? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Webview(
          mission: mission,
          args: {
            'hasReport': hasReport,
            'hasLike': hasLike,
            'hasComment': hasComment,
            'hasShare': hasShare,
            'hasDislike': hasDislike
          },
        ),
      ),
    );

    if (result == null) return;

    finalizeMission(context, mission, result);
  }

  handleFacebookChallenge(context, Model.Mission mission) async {
    final bool hasLike =
        mission.actions!.contains(ActionModel.actionsMap['like']) &&
            !mission.completedActions.contains(ActionModel.actionsMap['like']);
    final bool hasComment = mission.actions!
            .contains(ActionModel.actionsMap['comment']) &&
        !mission.completedActions.contains(ActionModel.actionsMap['comment']);
    final bool hasReport = mission.actions!
            .contains(ActionModel.actionsMap['report']) &&
        !mission.completedActions.contains(ActionModel.actionsMap['report']);

    Map<String, bool>? result = await navigateToMission(context, mission, {
      'hasReport': hasReport,
      'hasLike': hasLike,
      'hasComment': hasComment,
    });

    if (result == null) return;

    finalizeMission(context, mission, result);
  }

  handleTwitterChallenge(context, Model.Mission mission) async {
    final bool hasLike =
        mission.actions!.contains(ActionModel.actionsMap['like']) &&
            !mission.completedActions.contains(ActionModel.actionsMap['like']);
    final bool hasComment = mission.actions!
            .contains(ActionModel.actionsMap['comment']) &&
        !mission.completedActions.contains(ActionModel.actionsMap['comment']);
    final bool hasReport = mission.actions!
            .contains(ActionModel.actionsMap['report']) &&
        !mission.completedActions.contains(ActionModel.actionsMap['report']);
    final bool hasRetweet = mission.actions!
            .contains(ActionModel.actionsMap['retweet']) &&
        !mission.completedActions.contains(ActionModel.actionsMap['retweet']);

    Map<String, bool>? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Webview(
          mission: mission,
          args: {
            'hasReport': hasReport,
            'hasLike': hasLike,
            'hasComment': hasComment,
            'hasRetweet': hasRetweet
          },
        ),
      ),
    );

    if (result == null) return;

    finalizeMission(context, mission, result);
  }

  handleInstagramChallenge(context, Model.Mission mission) async {
    final bool hasLike =
        mission.actions!.contains(ActionModel.actionsMap['like']) &&
            !mission.completedActions.contains(ActionModel.actionsMap['like']);
    final bool hasComment = mission.actions!
            .contains(ActionModel.actionsMap['comment']) &&
        !mission.completedActions.contains(ActionModel.actionsMap['comment']);
    final bool hasReport = mission.actions!
            .contains(ActionModel.actionsMap['report']) &&
        !mission.completedActions.contains(ActionModel.actionsMap['report']);

    Map<String, bool>? result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => Webview(
          mission: mission,
          args: {
            'hasReport': hasReport,
            'hasLike': hasLike,
            'hasComment': hasComment,
          },
        ),
      ),
    );

    if (result == null) return;

    finalizeMission(context, mission, result);
  }

  platformLogin(context, Model.Mission mission) {
    showGeneralDialog(
        context: context,
        barrierLabel: "bLabel",
        barrierDismissible: true,
        barrierColor: Colors.black.withOpacity(.3),
        transitionDuration: Duration(milliseconds: 500),
        transitionBuilder: (ctx, anim1, anim2, child) => BackdropFilter(
              filter: ui.ImageFilter.blur(
                  sigmaX: 3 * anim1.value, sigmaY: 3 * anim1.value),
              child: FadeTransition(
                child: child,
                opacity: anim1,
              ),
            ),
        pageBuilder: (_, __, ___) {
          return Center(
              child: Container(
                  height: 315,
                  clipBehavior: Clip.hardEdge,
                  margin: EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: Material(
                      child: Column(
                    children: [
                      Container(
                          // margin: EdgeInsets.symmetric(vertical: 30),
                          margin: EdgeInsets.only(top: 40, bottom: 20),
                          child: Image.asset('assets/icons/click_pointer.png')),
                      Container(
                          margin: EdgeInsets.only(bottom: 10),
                          child: AutoSizeText(
                            (AppLocalizations.of(context)!
                                .translate("Only once"))!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: globalHeight * .04,
                            ),
                          )),
                      Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Center(
                              child: Container(
                                  margin: EdgeInsets.symmetric(horizontal: 20),
                                  child: AutoSizeText(
                                    (AppLocalizations.of(context)!.translate(
                                        "You need to login to this mission's platform in order to continue"))!,
                                    //"You need to login to this mission's platform in order to continue",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: globalHeight * .02,
                                    ),
                                  )))),
                      Container(
                        child: MyRaisedButton(
                          title: (AppLocalizations.of(context)!
                              .translate("CONTINUE"))!,
                          callback: (dynamic a) async {
                            bool loginResult =
                                await platformLoginNavigate(context, mission);
                            if (loginResult == true) {
                              isAfterPlatformLogin = true;
                              Navigator.of(context).pop();
                              acceptChallenge(context, mission);
                            }
                            return;
                          },
                        ),
                        margin: EdgeInsets.symmetric(vertical: 20),
                      ),
                    ],
                  ))));
        });
  }

  Future<bool> platformLoginNavigate(context, Model.Mission mission) async {
    // await Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => PlatformLogin(mission: mission)),
    //   (Route<dynamic> route) => false,
    // );

    bool result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (ctx) => PlatformLogin(mission: mission)),
    );

    return result;

    // await Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => PlatformLogin(mission: mission)));
  }

  acceptChallenge(context, Model.Mission mission) async {
    //await Database.addMission(mission);
    if (!AppGlobalData.getInstance()
        .isPlatfromLoggedIn(mission.target!.name!)) {
      platformLogin(context, mission);
      return;
    }
    switch (mission.target!.id) {
      case 1:
        handleFacebookChallenge(context, mission);
        break;
      case 2:
        handleGoogleChallenge(context, mission);
        break;
      case 3:
        handleYoutubeChallenge(context, mission);
        break;
      case 4:
        handleInstagramChallenge(context, mission);
        break;
      case 5:
        handleTwitterChallenge(context, mission);
        break;
      default:
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => Webview(
              mission: mission,
            ),
          ),
        );
    }
  }

  showHow(context, Model.Mission mission) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
            content: Container(
                width: Global.globalWidth * .6,
//              height: Global.globalWidth * .5,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Image.network(mission.screenshot!),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: MyRaisedButton(
                        title: (AppLocalizations.of(context)!
                            .translate("I GOT IT")),
                        margin: 30,
                        callback: (dynamic a) {
                          acceptChallenge(context, mission);
                          return;
                        },
                      ))
                ])));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as dynamic;
    Model.Mission mission = args['mission'];
    //print('args ' + mission.url);

    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: CustomScrollView(
            slivers: <Widget>[
              buildSliverAppBar(mission, context),
              buildSliverFillRemaining(mission, context)
            ],
          ),
        ));
  }

  SliverFillRemaining buildSliverFillRemaining(
      Model.Mission mission, BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        children: <Widget>[
          Container(
            //height: globalHeight * .2,
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: AutoSizeText(
              mission.title!,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: globalHeight * .03,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25),
            height: Global.globalHeight * 0.03,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat.yMMMd(_binding.selectedLanguage.language == "he"
                          ? "he_IL"
                          : "en_US")
                      .format(mission.date!),
                  style: buildTextStyleTimeLine(context),
                ),
                SizedBox(
                  width: 15,
                ),
                Icon(
                  Icons.access_time,
                  size: 15,
                  color: timeColor,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  mission.timeLeft(context) +
                      " " +
                      AppLocalizations.of(context)!.translate("time_left")!,
                  style: buildTextStyleTimeLine(context),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 13),
            height: 26,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: mission.actions?.map((act) {
                    return Container(
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        height: 26,
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                            color: Color.fromRGBO(241, 241, 241, 1),
                            borderRadius: BorderRadius.circular(6)),
                        //act!.iconSvg
                        child: Row(mainAxisSize: MainAxisSize.min, children: [
                          act!.iconSvg,
                          Container(
                              child: Text(AppLocalizations.of(context)!
                                  .translate(act.name!)!),
                              margin: EdgeInsets.symmetric(horizontal: 5))
                        ]));
                  }).toList() ??
                  [],
            ),
          ),
          mission.current != null
              ? Container(
                  // margin: EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                  width: 150,
                  height: 140,
                  child: CircularPercentIndicator(
                    radius: 110.0,
                    animation: true,
                    animationDuration: 1500,
                    //reverse: true,
                    //startAngle: 30,
                    lineWidth: 10.0,
                    percent: mission.current! / mission.limit!,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/icons/faces/man_user.svg',
                            ),
                            Text(
                              "${mission.current}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: Helper.normalizePixel(context, 22)),
                            ),
                          ],
                        ),
                        Text(
                          "/${mission.limit}",
                          style: TextStyle(
                              fontWeight: FontWeight.w200,
                              fontSize: Helper.normalizePixel(context, 12)),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Colors.grey[200]!,
                    //progressColor: Colors.red
                    linearGradient: LinearGradient(colors: [
                      Color.fromRGBO(185, 225, 226, 1),
                      Color.fromRGBO(0, 239, 141, 1),
                    ], begin: Alignment.topCenter, end: Alignment.bottomLeft),
                  ),
                )
              : SizedBox(
                  height: 0,
                ),
          Expanded(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: Html(data: mission.body!)
                // child: AutoSizeText(
                //   mission.body!,
                //   style: TextStyle(color: mainColor),
                // ),
                ),
          ),
          /*GestureDetector(
            onTap: () => showHow(context, mission),
            child: Container(
              alignment:_binding.selectedLanguage.language == "he" ? Alignment.bottomRight : Alignment.bottomLeft,
              padding: EdgeInsets.all(30),
              child: Text(
                AppLocalizations.of(context)!.translate("Show me how")!,
                style: TextStyle(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline)
              ),
            ),
          ),*/
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            //width: 225,
            child: MyRaisedButton(
              title:
                  (AppLocalizations.of(context)!.translate("MISSION_CONTINUE")),
              //margin: 92,
              callback: (dynamic a) {
                acceptChallenge(context, mission);
                return;
              },
            ),
          ),
        ],
      ),
    );
  }

  SliverAppBar buildSliverAppBar(Model.Mission mission, BuildContext context) {
    return SliverAppBar(
      floating: true,
      backgroundColor: Colors.blueGrey,
      iconTheme: IconThemeData(color: Colors.white),
      expandedHeight: globalHeight * .3,
      // title: Container(
      //   child: Text(
      //     mission.getTitle(Localizations.localeOf(context).toLanguageTag()),
      //     maxLines: 1,
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   width: globalWidth * .5,
      // ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        stretchModes: [StretchMode.blurBackground, StretchMode.fadeTitle],
        background: Stack(
          children: <Widget>[
            Container(
              child: Hero(
                tag: mission.id!,
                child: Image.network(
                  mission.image ?? "",
                  //  height: globalHeight * .3,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color(0xae000000),
                Color(0x00000000),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              height: globalHeight * .4,
            ),
//            Positioned(
//                top: MediaQuery.of(context).size.height * 0.07,
//                right: 25,
//                child: LevelFace(happy: mission.happy, level: mission.level)),
            Directionality(
                textDirection: ui.TextDirection.ltr,
                child: Positioned(
                  bottom: 0,
                  left: 0,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        targetWidget(mission.target!),
                        Text(
                          mission.target!.getPretty(context)!,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    height: 40,
                    width: 150,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 40.0,
                          spreadRadius: 01.5,
                          color: Colors.grey[300]!,
                        )
                      ],
                      color: Colors.white,
                      borderRadius: intl.Bidi.isRtlLanguage(
                              Localizations.localeOf(context).languageCode)
                          ? BorderRadius.only(topLeft: Radius.circular(15))
                          : BorderRadius.only(topRight: Radius.circular(15)),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  TextStyle buildTextStyleTimeLine(BuildContext context) {
    return TextStyle(
        fontSize: Helper.normalizePixel(context, 12),
        color: timeColor,
        fontWeight: FontWeight.bold);
  }

  TextStyle buildTextStyleActions(BuildContext context) =>
      TextStyle(color: mainColor, fontSize: Helper.normalizePixel(context, 13));
}
