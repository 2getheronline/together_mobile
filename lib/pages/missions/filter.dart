import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:together_online/models/action.dart' as ActionModel;
import 'package:together_online/models/mission.dart';
import 'package:together_online/models/tag.dart';
import 'package:together_online/models/target.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/widgets/my_search_chip.dart';
import 'package:together_online/widgets/raised_button.dart';
import 'dart:ui' as ui;

import '../../app_localizations.dart';
import '../../helper.dart';

class FiltersPage extends StatefulWidget {
  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  final _binding = DataBindingBase.getInstance();

  GlobalKey key = GlobalKey();
  void toggleFilter(String area, dynamic t) {
    setState(() {
      switch (area) {
        case 'target':
          _binding.platforms![_binding.platforms!.indexOf(t)]!
              .filterEnableDisable();
          break;
        case 'category':
          _binding.tags![_binding.tags!.indexOf(t)].filterEnableDisable();
          break;
        case 'action':
          _binding.actions![_binding.actions!.indexOf(t)].filterEnableDisable();
          break;
      }
    });
  }

  void clearFilter() {
    setState(() {
      _binding.platforms!.forEach((Target? t) => t!.filterIsEnabled = true);
      _binding.tags!.forEach((TagFilter tag) => tag.filterIsEnabled = true);
      _binding.actions!.forEach((ActionFilter t) => t.filterIsEnabled = true);
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void filter() {
    List<Mission> list = new List.of(_binding.missions!);
    _binding.missions!.forEach((Mission mission) {
      _binding.platforms!.forEach((platform) {
        if (!platform!.filterIsEnabled!) if (mission.target!.name ==
            platform.name) list.remove(mission);
      });
      _binding.tags!.forEach((tag) {
        if (!tag.filterIsEnabled!) {
          List<String?> missionTags =
              mission.tags!.map((missionTag) => missionTag.name).toList();
          if (missionTags.contains(tag.name)) list.remove(mission);
        }
      });
      _binding.actions!.forEach((t) {
        if (!t.filterIsEnabled!) {
          List<String?> missionActions = mission.actions!
              .map((missionAction) => missionAction!.name)
              .toList();
          if (missionActions.contains(t.name)) list.remove(mission);
        }
      });
    });
    _binding.filterMissions
      ?..clear()
      ..addAll(list);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: LayoutBuilder(
          builder: (context, constrains) {
            final double height = MediaQuery.of(context).size.height;
            final double width = MediaQuery.of(context).size.width;
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.055,
                vertical: height * 0.03,
              ),
              child: Observer(builder: (_) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            AppLocalizations.of(context)!
                                .translate('Filter your missions')!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Color.fromRGBO(49, 49, 54, 1)),
                          ),
                          IconButton(
                            padding: EdgeInsets.all(0),
                            icon: SvgPicture.asset('assets/icons/close.svg'),
                            onPressed: filter,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.02),
                      child: Text(
                        AppLocalizations.of(context)!.translate('PLATFORMS')!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 85,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ..._binding.platforms!
                              .map((Target? p) => GestureDetector(
                                    child: p!.filterIcon(),
                                    onTap: () => toggleFilter('target', p),
                                  ))
                              .toList(),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: height * 0.01),
                      child: Text(
                        AppLocalizations.of(context)!.translate('CATEGORY')!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        top: constrains.maxWidth * 0.03,
                      ),
                      height: constrains.maxHeight * 0.17,
                      child: SingleChildScrollView(
                          child: Wrap(
                        spacing: 13,
                        runSpacing: 10,
                        children: <Widget>[
                          ..._binding.tags!
                              .map((TagFilter tag) => MySearchChip(
                                    selectedCheck: true,
                                    isSelected: tag.filterIsEnabled,
                                    text: AppLocalizations.of(context)!
                                        .translate(tag.name),
                                    onTap: () => toggleFilter('category', tag),
                                  ))
                              .toList(),
                        ],
                      )),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: height * 0.02, bottom: height * 0.01),
                      child: Text(
                        AppLocalizations.of(context)!.translate('TASK TYPE')!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Wrap(
                        spacing: 13,
                        runSpacing: 10,
                        children: <Widget>[
                          ..._binding.actions!
                              .map((ActionFilter a) => MySearchChip(
                                    selectedCheck: true,
                                    isSelected: a.filterIsEnabled,
                                    text: AppLocalizations.of(context)!
                                        .translate(a.name),
                                    hasIcon: true,
                                    icon: a.iconSvg as SvgPicture? ??
                                        "" as SvgPicture?,
                                    onTap: () => toggleFilter('action', a),
                                  ))
                              .toList(),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            AppLocalizations.of(context)!.translate('CLEAR')!,
                            style: TextStyle(
                                fontSize: Helper.normalizePixel(context, 14),
                                fontWeight: FontWeight.bold,
                                color: const Color.fromRGBO(42, 56, 143, 1)),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: Color.fromRGBO(240, 244, 255, 1),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 50),
                          onPressed: clearFilter,
                        ),
                        RaisedButton(
                          child: Text(
                            AppLocalizations.of(context)!.translate('FILTER')!,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: Color.fromRGBO(42, 56, 143, 1),
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 50),
                          onPressed: filter,
                        ),
                      ],
                    )
                  ],
                );
              }),
            );
          },
        ));
  }
}

class FiltersModalDown extends ModalRoute<Map<String, List<dynamic>>> {
  Widget searchPageBuilder(BuildContext context) {
    return SafeArea(child: FiltersPage());
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 400);

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => false;

  @override
  Color get barrierColor => Colors.black.withOpacity(0.8);

  @override
  String? get barrierLabel => null;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    // This makes sure that text and other content follows the material style
    return Material(
      type: MaterialType.transparency,
      elevation: 5,
      // make sure that the overlay content is not cut off
      //child: SafeArea(
      child: _buildOverlayContent(context),
      // ),
    );
  }

  Widget _buildOverlayContent(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.up,
      key: ValueKey('filter'),
      onDismissed: (status) => Navigator.pop(context),
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height:
                  double.infinity, //MediaQuery.of(context).size.height + 1011
              color: Colors.transparent,
            ),
          ),
          Container(
            child: searchPageBuilder(context),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30))),
            //duration: Duration(seconds: 1),
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.8,
          ),
        ],
      ),
    );
  }

//onTap: () => Navigator.pop(context),
  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    Animation<Offset> custom =
        Tween<Offset>(begin: Offset(0.0, -0.5), end: Offset(0.0, 0.0))
            .animate(animation);
    // You can add your own animations for the overlay content
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: custom,
        child: child,
      ),
    );
  }
}

class TagFilter extends Group {
  bool? filterIsEnabled;

  TagFilter(_filterIsEnabled, name) : super(name: name) {
    this.filterIsEnabled = _filterIsEnabled;
  }

  bool? filterEnableDisable() {
    filterIsEnabled = !filterIsEnabled!;
    return filterIsEnabled;
  }
}

class ActionFilter extends ActionModel.ActionModel {
  bool? filterIsEnabled;

  ActionFilter(id, _filterIsEnabled, name, icon)
      : super(id: id, name: name, icon: icon) {
    this.filterIsEnabled = _filterIsEnabled;
  }

  bool? filterEnableDisable() {
    filterIsEnabled = !filterIsEnabled!;
    return filterIsEnabled;
  }
}
