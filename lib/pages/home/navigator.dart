import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:together_online/app_localizations.dart';
import 'package:together_online/models/user.dart';
import 'package:together_online/pages/report/report.dart';
import 'package:together_online/pages/home.dart';
import 'package:together_online/pages/library/library.dart';
import 'package:together_online/pages/missions/missions.dart';
import 'package:together_online/pages/more/more.dart';
import 'package:together_online/pages/search/search.dart';
import 'package:together_online/pages/profile/profile.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/providers/server.dart';
import 'package:together_online/widgets/myRaisedButton.dart';
import '../../widgets/bottom_navy_bar.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:ui' as ui;

class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  PageController? _pageController;
  int _selectedIndex = 0;

  Color _color = Colors.black87;

  bool _upSearchBottomBar = false;
  DataBinding? _binding = DataBindingBase.getInstance();

  closeSerachPage() {
    setState(() {
      _selectedIndex = 0;
      _upSearchBottomBar = false;
    });
  }

  onPageChanged(int pageIndex) {
    // print(pageIndex);
    setState(() {
      _selectedIndex = pageIndex;
    });
  }

  @override
  void initState() {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    globalCtx = context;
    _pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###");
    return Directionality(
        textDirection: _binding!.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Observer(builder: (_) {
                          User? currentUser = _binding!.session?.auth;
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Container(
                                      margin:
                                          _binding!.selectedLanguage.language ==
                                                  "he"
                                              ? EdgeInsets.only(right: 20)
                                              : EdgeInsets.only(left: 20),
                                      child: GestureDetector(
                                        onTap: () => Navigator.of(context)
                                            .pushNamed(UserPage.routeName),
                                        child: CircleAvatar(
                                          radius: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .025,

                                          //heght: MediaQuery.of(context).size.height * .03,
                                          backgroundImage:
                                              currentUser?.getAvatar(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      currentUser?.name ?? '',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color.fromRGBO(88, 88, 95, 1)),
                                    ),
                                  ],
                                ),
                                Container(
                                  margin: _binding!.selectedLanguage.language ==
                                          "he"
                                      ? EdgeInsets.only(left: 20)
                                      : EdgeInsets.only(right: 20),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          Server.getInstance()!.getMissions();
                                        },
                                        icon: Icon(Icons.sync),
                                      ),
                                      currentUser?.level == "expert"
                                          ? SvgPicture.asset(
                                              'assets/icons/medal.svg',
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .024)
                                          : SvgPicture.asset(
                                              'assets/icons/diamond.svg',
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .024),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        currentUser?.points != null
                                            ? formatter
                                                .format(currentUser?.points)
                                                .toString()
                                                .replaceAllMapped(
                                                    RegExp(
                                                        r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                                                    (Match m) => '${m[1]},')
                                            : "0",
                                        style: TextStyle(
                                          color:
                                              Color.fromRGBO(101, 101, 109, 1),
                                          fontWeight: FontWeight.bold,
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .018,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Expanded(
                                //   child: Container(),
                                // ),
                                // _selectedIndex == 0 && false
                                //     ? MyRaisedButton(
                                //         title: AppLocalizations.of(context)!
                                //             .translate('report_button')!,
                                //         width: 60,
                                //         height: 30,
                                //         fontSize: 14,
                                //         withShadow: false,
                                //         margin: 10,
                                //         callback: (context) => {
                                //           Navigator.of(context)
                                //               .pushNamed(AddReport.routeName)
                                //         },
                                //       )
                                //     : SizedBox(),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 34),
                    Expanded(
                      flex: 20,
                      child: PageView(
                        physics: NeverScrollableScrollPhysics(),
                        controller: _pageController,
                        onPageChanged: onPageChanged,
                        children: <Widget>[
                          Missions(),
                          // SearchPage(),
                          //Library(),
                          More(),
                        ],
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: closeSerachPage,
                  child: AnimatedContainer(
                    duration: Duration(microseconds: 500),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: _color,
                    transform: Transform.translate(
                      offset: Offset(
                          0,
                          _upSearchBottomBar
                              ? 0
                              : MediaQuery.of(context).size.height -
                                  MediaQuery.of(context).size.height *
                                      0.09), // Change -100 for the y offset
                    ).transform,
                  ),
                ),
                AnimatedContainer(
                  //SEARCH PAGE
                  padding: EdgeInsets.only(top: 25),
                  child: new SearchPage(closeModal: closeSerachPage),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.76,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  duration: Duration(seconds: 1),
                  transform: Transform.translate(
                    offset: Offset(
                        0,
                        _upSearchBottomBar == true
                            ? MediaQuery.of(context).size.height *
                                0.15 // O quanto sobe o modal
                            : MediaQuery.of(context)
                                    .size
                                    .height - //Posição abaixo da tela
                                MediaQuery.of(context).size.height * 0.09),
                  ).transform,
                  curve: Curves.fastOutSlowIn,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            height: 64,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(231, 234, 255, 1),
                      spreadRadius: 0,
                      blurRadius: 10),
                ],
                border: Border.all(color: Color.fromRGBO(231, 234, 255, 1))),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedLabelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                unselectedLabelStyle:
                    TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Container(
                        margin: EdgeInsets.only(bottom: 3),
                        child: Icon(Icons.house_outlined)),
                    label: AppLocalizations.of(context)!.translate('Missions'),
                  ),
                  BottomNavigationBarItem(
                    icon: Container(
                        margin: EdgeInsets.only(bottom: 3),
                        child: Icon(Icons.more_vert)),
                    label: AppLocalizations.of(context)!.translate('More'),
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Color.fromRGBO(57, 80, 219, 1),
                onTap: (index) => setState(() {
                  _selectedIndex = index;
                  if (false && index == 1) {
                    setState(() {
                      _selectedIndex = 1;
                      _upSearchBottomBar = true;
                    });
                  } else {
                    _upSearchBottomBar = false; // Baixar o modal da pesquiza
                    _pageController!.animateToPage(index,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.ease);
                  }
                }),
              ),
            ),
          ),
        ));
  }
}
