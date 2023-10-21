import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:together_online/main.dart';
import 'package:together_online/models/mission.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/providers/restClient.dart';
import 'package:together_online/providers/server.dart';
import 'package:together_online/widgets/mission_card.dart';
import '../../app_localizations.dart';
import '../missions/filter.dart';
import 'package:dio/dio.dart';

reloadMissions() async {
//  final missions = await Database.getMissions(currentUser);
//  Missions.streamController.add(missions);

  final dio = Dio(); // Provide a dio instance
  dio.options.headers["Demo-Header"] =
      "demo header"; // config your dio headers globally
  final client = RestClient(dio);

  client.getMissions().then((it) {
    Missions.streamController.add(it);
  });
}

class Missions extends StatefulWidget {
  static StreamController<dynamic> streamController =
      StreamController<dynamic>.broadcast();

  _MissionsState createState() => _MissionsState();
}

class _MissionsState extends State<Missions> {
  final _binding = DataBindingBase.getInstance();
  final _server = Server.getInstance();
  int currentItem = 0;
  final PageController ctrl = PageController(viewportFraction: 0.8);

  StreamController<dynamic> streamController = Missions.streamController;
  List<Mission>? missionsList;

  @override
  void initState() {
    super.initState();
    _server!.getMissions();
    ctrl.addListener(() {
      int pos = ctrl.page!.round();
      if (currentItem != pos) {
        setState(() {
          currentItem = pos;
          // print("Updated state from ctrl, item: " + currentItem.toString());
        });
      }
    });
  }

  @override
  void dispose() {
    //streamController.close();
    super.dispose();
  }

  openFilter() async {
    //  final Map<String, List<dynamic>> filter =
    await Navigator.of(context).push(FiltersModalDown());
    // streamController.add(Database.filterMissions(filter));
  }

  @override
  Widget build(BuildContext context) {
    // if(_binding.session?.auth?.language != _binding.selectedLanguage.language) {
    //   _binding.session?.auth?.language = _binding.selectedLanguage.language;
    //   _server!.editUser();
    //   sleep(Duration(seconds: 4));
    //   _binding.setMissions([]);
    //   _server!.getMissions();
    //   sleep(Duration(seconds: 2));
    //   AppLocalizations.delegate.load(Locale(_binding.selectedLanguage.language!, "US")).then((value) {
    //     MyAppState state = context.findAncestorStateOfType<MyAppState>()!;
    //     state.setState(() {});
    //   });
    // }

    return Observer(
      builder: (_) => Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.05),
          child: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    AppLocalizations.of(context)!.translate('Missions')!,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.of(context).size.height * .028,
                    ),
                  ),
                ),
                IconButton(
                  icon: SvgPicture.asset(hasMissions(_binding.missions)!
                      ? "assets/icons/filter.svg"
                      : "assets/icons/filter-opacity.svg"),
                  //onPressed: widget.closeFilter,
                  onPressed:
                      hasMissions(_binding.missions)! ? openFilter : null,
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Container(
            //margin: EdgeInsets.only(bottom: 20),
            //padding: EdgeInsets.only(bottom: 20),f
            child: (!_binding.isMissionLoad)
                ? Container(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(),
                  )
                : hasMissions(_binding.missions)!
                    ? buildSwiper(_binding.filterMissions!)
                    : buildNoMissions(context)),
      ),
    );
  }

  Row buildNoMissions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SizedBox(height: globalHeight * .13),
            SvgPicture.asset(
              "assets/icons/app_Icon/missions_page/shield.svg",
              height: globalHeight * .1,
            ),
            SizedBox(height: globalHeight * .02),
            Text(
              AppLocalizations.of(context)!.translate("Wow!")!,
              style: TextStyle(
                fontSize: globalHeight * .0375,
                color: Color(0xff2a388f),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: globalHeight * .01),
            Text(
              AppLocalizations.of(context)!
                  .translate("You have completed all missions.")!,
              style: TextStyle(
                fontSize: globalHeight * .025,
                color: Color(0xff2a388f),
              ),
            ),
            SizedBox(height: globalHeight * .05),
          ],
        ),
      ],
    );
  }

  Widget buildSwiper(List<Mission> missions) {
    return PageView.builder(
        controller: ctrl,
        itemBuilder: (BuildContext context, int index) {
          final c = missions[index];
          final bool isActive = (index == currentItem);
          return AnimatedPadding(
            duration: const Duration(milliseconds: 300),
            padding:
                EdgeInsets.symmetric(vertical: isActive ? 0 : 10.0),
            child: Opacity(
              opacity: isActive ? 1.0 : 0.7,
              child: MissionCard(mission: c),
            ),
          );
          // return MissionCard(mission: c, isActive: (index == currentItem),);
        },
        itemCount: missions.length);
  }

  bool? hasMissions(missions) {
    return missions.length > 0;
  }
}
