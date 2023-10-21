import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:together_online/helper.dart';
import 'package:together_online/models/mission.dart' as Model;
import 'package:together_online/models/target.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/server.dart';
import 'package:flutter_html/flutter_html.dart';

import '../app_localizations.dart';

class MissionCard extends StatelessWidget {
  final Model.Mission? mission;
  var _binding = DataBindingBase.getInstance();

  MissionCard({
    this.mission,
  });

  Widget targetWidget(Target target) {
    return SvgPicture.network(
      target.icon!,
      height: 15,
      width: 15,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constr) {
      return Container(
        padding: EdgeInsets.only(bottom: 20, top: 6),
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(31, 87, 169, 0.15),
                      offset: Offset(0, 7),
                      blurRadius: 21.0,
                      spreadRadius: 10.0),
                ],
              ),
              margin: EdgeInsets.only(bottom: 25, left: 10, right: 10, top: 15),
              child: LayoutBuilder(builder: (context, constrains) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildHeaderImage(constrains, context),
                    buildTitle(context),
                    buildTimeLine(constrains, context),
                    buildTextBody(context),
                    mission!.current != null
                        ? buildCircularPercentIndicator(constrains, context)
                        : SizedBox(
                            height: 10,
                          ),
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 12, bottom: 17),
                        child: Text(
                          //DateFormat.yMMMd(_binding.selectedLanguage.language == "he" ? "he_IL" : "en_US").format(mission!.date!),
                          mission!.timeLeft(context) +
                              " " +
                              AppLocalizations.of(context)!
                                  .translate("time_left")!,
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 0, 0),
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.016),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    )
                  ],
                );
              }),
            ),
            buildPositionedButton(context, constr)
          ],
        ),
      );
    });
  }

  Expanded buildCircularPercentIndicator(
      BoxConstraints constrains, BuildContext context) {
    return Expanded(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: constrains.maxHeight * 0.45,
              child: Center(
                child: Stack(
                  children: <Widget>[
                    Container(
                      //Coloquei este contaoner aspenas para usar a margem dele
                      margin: EdgeInsets.only(
                          top: constrains.maxHeight * 0.018 / 3,
                          left: constrains.maxHeight * 0.018 / 5),
                      child: CircularPercentIndicator(
                        //Ela quer que tenha uma linha mais curta em baixo do spinner verde... entao adiconei este circulo em baixo
                        radius: (constrains.maxHeight * 0.44) / 2,
                        lineWidth: constrains.maxHeight * 0.01,
                        backgroundColor: Color(0xFFF7F7F7),
                      ),
                    ),
                    CircularPercentIndicator(
                      radius: (constrains.maxHeight * 0.45) / 2,
                      animation: true,
                      animationDuration: 2500,
                      lineWidth: constrains.maxHeight * 0.018,
                      percent: mission!.current! / mission!.limit!,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 4),
                                child: SvgPicture.asset(
                                  'assets/icons/faces/man_user.svg',
                                  color: Color(0xffbcbcbf),
                                  height: constrains.maxHeight * 0.022,
                                ),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              AutoSizeText(
                                "${mission!.current.toString()}",
                                style: TextStyle(
                                  // fontWeight:
                                  //     FontWeight.w200,
                                  color: Color(0xff313136),
                                  fontSize: Helper.normalizePixel(context, 22),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 3.5,
                          ),
                          AutoSizeText(
                            "/ ${mission!.limit.toString()}",
                            style: TextStyle(
                                // fontWeight:
                                //     FontWeight.w200,
                                color: Color(0xff3e4a59),
                                fontSize: Helper.normalizePixel(context, 12)),
                          ),
                        ],
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      backgroundColor: Colors.transparent,
                      //Color(0xFFF7F7F7),
                      //progressColor: Colors.red
                      linearGradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(185, 255, 226, 1),
                          Color.fromRGBO(0, 239, 141, 1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildTextBody(BuildContext context) {
    var bodyContent = "";
    if (mission!.body!.contains("<p>")) {
      bodyContent = mission!.body!;
    } else {
      bodyContent = mission!.body!.replaceAll('\n', "<br />");
    }
    return Container(
        height: 30,
        padding: EdgeInsets.symmetric(horizontal: 28),
        child: Html(data: bodyContent));
  }

  Container buildTimeLine(BoxConstraints constrains, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: constrains.maxHeight * 0.02,
      ),
      height: constrains.maxHeight * 0.05,
      width: 200,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: [
              SizedBox(
                width: 14,
              ),
              Row(
                children: mission!.actions?.map((act) {
                      return Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 26,
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(241, 241, 241, 1),
                              borderRadius: BorderRadius.circular(6)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              act!.iconSvg,
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                AppLocalizations.of(context)!
                                        .translate(act.name)! ??
                                    '',
                              )
                            ],
                          ));

                      // if (act.name == "comment") {
                      //   return Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 5),
                      //       child: ActionModel.Actions['COMMENT'].iconSvg);
                      // } else if (act.name == "like") {
                      //   return Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 5),
                      //       child:
                      //           SvgPicture.asset(ActionModel.Actions['LIKE'].icon));
                      // } else if (act.name == "dislike") {
                      //   return Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 5),
                      //       child: SvgPicture.asset(
                      //           ActionModel.Actions['DISLIKE'].icon));
                      // } else if (act.name == "report") {
                      //   return Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 5),
                      //       child:
                      //           SvgPicture.asset(ActionModel.Actions['REPORT'].icon));
                      // } else if (act == ActionModel.Actions['RATE']) {
                      //   return Container(
                      //       margin: EdgeInsets.symmetric(horizontal: 5),
                      //       child:
                      //           SvgPicture.asset(ActionModel.Actions['RATE'].icon));
                      // } else {
                      //   return Text('Missing');
                      // }
                    })?.toList() ??
                    [],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Container buildTitle(BuildContext context) {
    return Container(
      width: 260,
      margin: EdgeInsets.only(right: 20, left: 20, top: 10),
      child: Text(
        mission!.title!,
        maxLines: 4,
        softWrap: true,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * .025,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Container buildHeaderImage(BoxConstraints constrains, BuildContext context) {
    return Container(
      height: constrains.maxHeight * 0.3,
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Container(
              constraints: BoxConstraints(
                minHeight: constrains.maxHeight * 0.3,
              ),
              child: Hero(
                tag: mission!.id!,
                child: CachedNetworkImage(
                  imageUrl: mission!.image ?? '',
                  //height: 134,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
//          Positioned(top: 17, right: 17, child:  mission.happy
//              ? SvgPicture.asset(
//            'assets/icons/faces/happy.svg',
//          )
//              : SvgPicture.asset('assets/icons/faces/sad.svg'),),

          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  targetWidget(mission!.target!),
                  AutoSizeText(mission?.target?.getPretty(context) ?? ''),
                ],
              ),
              height: 30,
              width: 110,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff9F9F9F).withOpacity(.26),
                    offset: Offset(0, 7),
                    blurRadius: 40.0,
                    spreadRadius: 15.0,
                  ),
                ],
                border: Border.all(
                    color: Colors.white, width: 2, style: BorderStyle.solid),
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Positioned buildPositionedButton(
      BuildContext context, BoxConstraints constr) {
    return Positioned(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width * .46,
        //width: 200,
        height: MediaQuery.of(context).size.height * .06,
        //height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(70),
          color: Color(0xff3950DB),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              borderRadius: BorderRadius.circular(70),
              onTap: () {
                Navigator.of(context).pushNamed('mission',
                    arguments: {'mission': mission}).then((a) {
                  Server.getInstance()!.getMissions();
                });
              },
              child: Center(
                child: Text(
                  mission!.missionStatus == Model.MissionStatus.ACCEPTED
                      ? AppLocalizations.of(context)!.translate('CONTINUE')!
                      : mission!.missionStatus == Model.MissionStatus.COMPLETED
                          ? AppLocalizations.of(context)!
                              .translate('COMPLETED')!
                          : AppLocalizations.of(context)!.translate(
                              'START MISSION')!, // TODO: Debugging only
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: MediaQuery.of(context).size.height * .02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )),
        ),
      ),
      //child: FlatButton(child: Text('OIEE'),),
      bottom: 0,
      right: constr.maxWidth / 8,
    );
  }
}
