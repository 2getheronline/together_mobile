import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/database.dart';
import 'package:together_online/providers/storage.dart';
import 'package:together_online/widgets/activity.dart';
import 'package:together_online/widgets/myFlatButton.dart';
import 'package:together_online/widgets/profile.dart';
import 'package:together_online/widgets/profile_bar_icon.dart';
import 'package:together_online/widgets/score.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui' as ui;

import '../../app_localizations.dart';
import '../home.dart';

class UserPage extends StatefulWidget {
  static const routeName = '/UserPage';
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  PageController? _pageController;
  int _selectedIndex = 0;
  final _binding = DataBindingBase.getInstance();


  @override
  void initState() {
    _pageController = PageController();
    server!.loadTopUsers();
    server!.loadTopGroups();
    server!.loadMyActivities();

//    recalculateUserLevel();
    super.initState();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

//  recalculateUserLevel() async {
//    if (_binding.session.auth.points < 200) return;
//
//    dynamic rank = await Database.getRank();
//    int topScore = rank[0].points;
//
//    double ratio = _binding.session.auth.points / topScore;
//
//    print('ratio ' + ratio.toString());
//
//    if (ratio == 1) {
//      setUserLevel(8);
//    } else if (ratio > .875) {
//      setUserLevel(7);
//    } else if (ratio > .75) {
//      setUserLevel(6);
//    } else if (ratio > .625) {
//      setUserLevel(5);
//    } else if (ratio > .5) {
//      setUserLevel(4);
//    } else if (ratio > .375) {
//      setUserLevel(3);
//    } else if (ratio > .25) {
//      setUserLevel(2);
//    }
//  }

//  setUserLevel(int level) async {
//    await Database.changeUserLevel(level);
//    setState(() {});
//  }

  onPageChanged(int pageIndex) {
    print(pageIndex);
    setState(() {
      _selectedIndex = pageIndex;
      _pageController!.animateToPage(_selectedIndex,
          duration: Duration(milliseconds: 300), curve: Curves.easeInCirc);
    });
  }

  manualPageChanged(int pageIndex) {
    print(pageIndex);
    setState(() {
      _selectedIndex = pageIndex;
    });
  }

  pickImageMode() {
    return showModalBottomSheet(
        context: context,
        builder: (bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(AppLocalizations.of(context)!.translate('Camera')!),
                    onTap: () { changeAvatar(ImageSource.camera); Navigator.of(context).pop(); }),
                new ListTile(
                  leading: new Icon(Icons.photo_library),
                  title: new Text(AppLocalizations.of(context)!.translate('Gallery')!), 
                  onTap: () { changeAvatar(ImageSource.gallery); Navigator.of(context).pop(); },
                ),
              ],
            ),
          );
        });
  }

  changeAvatar(ImageSource source) async {
    File image = File((await ImagePicker().pickImage(
        source: source, maxWidth: 512, imageQuality: 75))!.path);
    String url = await Storage.uploadImage(image, _binding.session!.auth!.uid);

    if (url != '') {
      if (!(await Database.changeUserAvatar(url))) {
        print('Error on saving user avatar');
      }
      setState(() {});
    } else {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final formatter = new NumberFormat("#,###");
    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Scaffold(
          resizeToAvoidBottomInset : false,
      // resizeToAvoidBottomInset:
      //     false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        //color: Colors.amber,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          //fit: StackFit.loose,
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: 0,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: PageView(
                    //physics: NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: manualPageChanged,
                    children: <Widget>[Scores(false),Scores(true), Activity(), Profile()],
                  ),
                )
              ],
            ),
            Positioned(
              top: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * .33,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xff000000).withAlpha(70),
                          blurRadius: 15,
                          spreadRadius: 1,
                          offset: Offset(0, -6))
                    ],
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(40))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Stack(
                        children: <Widget>[
                          Center(
                              child: SvgPicture.asset(
                            'assets/icons/levels/level_${_binding.session!.auth!.level != null ? _binding.session!.auth!.level!.icon : '0'}.svg',
                            height: 110,
                          )),
                          Center(
                              child: Container(
                            child: SizedBox(
                              width: 93,
                              height: 93,
                            ),
                            margin: EdgeInsets.only(top: 4, right: 2),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 4),
                              color: Colors.white,//image: DecorationImage(image: NetworkImage(currentUser?.avatar), fit: BoxFit.cover),
                              shape: BoxShape.circle,
                            
                            ),
                          )),
                          Center(
                            child: Container(
                              child: SizedBox(
                                width: 90,
                                height: 90,
                              ),
                              margin: EdgeInsets.only(top: 4, right: 2),
                              decoration: BoxDecoration(
                                //color: Colors.white,
                                image: DecorationImage(
                                  image: _binding.session!.auth!.getAvatar() ,
                                  fit: BoxFit.cover,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xFF9EA9ED).withAlpha(85),
                                    blurRadius: 16,
                                    offset: Offset(0, 10),
                                    spreadRadius: 7,
                                  )
                                ],
                              ),
                            ),
                          ),
                          // Positioned(
                          //   right: MediaQuery.of(context).size.width * .34,
                          //   bottom: 0,
                          //   child: _selectedIndex == 2
                          //       ? GestureDetector(
                          //           onTap: pickImageMode,
                          //           child: Container(
                          //             child: SvgPicture.asset(
                          //                 'assets/icons/edit.svg'),
                          //           ),
                          //         )
                          //       : SizedBox(),
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        _binding.session!.auth!.name ?? "",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height * .022,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: Text( _binding.session!.auth!.level?.name != null ?  AppLocalizations.of(context)!.translate(_binding.session!.auth!.level?.name)! : AppLocalizations.of(context)!.translate('Beginner')!),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: Chip(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                        shadowColor: Color(0xff000000).withAlpha(90),
                        elevation: 4,
                        backgroundColor: Colors.white,
                        label: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _binding.session!.auth!.level == 8 ? SvgPicture.asset('assets/icons/medal.svg') : SvgPicture.asset('assets/icons/diamond.svg'),
                            SizedBox(
                              width: 6,
                            ),
                            Text(
                              _binding.session!.auth?.points != null
                                  ? formatter.format(_binding.session!.auth?.points).toString()
                                  : "0",
                              style: TextStyle(
                                color: Color.fromRGBO(101, 101, 109, 1),
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height * .02,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        ProfileBarIcon(
                          name: (AppLocalizations.of(context)!.translate('GROUPS')),
                          index: 0,
                          selectedIndex: _selectedIndex,
                          onPageChanged: onPageChanged,
                        ),
                        ProfileBarIcon(
                          name: (AppLocalizations.of(context)!.translate('GAINERS')),
                          index: 1,
                          selectedIndex: _selectedIndex,
                          onPageChanged: onPageChanged,
                        ),
                        ProfileBarIcon(
                            name: (AppLocalizations.of(context)!.translate('ACTIVITY')),
                            index: 2,
                            selectedIndex: _selectedIndex,
                            onPageChanged: onPageChanged),
                        ProfileBarIcon(
                            name: (AppLocalizations.of(context)!.translate('PROFILE')),
                            index: 3,
                            selectedIndex: _selectedIndex,
                            onPageChanged: onPageChanged),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget buildBarButton(String name, int index) {
    print(index);
    return FlatButton(
      child: Text(
        name,
        style: TextStyle(
            color: _selectedIndex == index
                ? Color(0xFF2a388f)
                : Color(0xFF92939a)),
      ),
      onPressed: () => onPageChanged(index),
    );
  }
}
