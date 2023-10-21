import 'package:mobx/mobx.dart';
import 'package:together_online/models/activity.dart';
import 'package:together_online/models/mission.dart';
import 'package:together_online/models/session.dart';
import 'package:together_online/models/tag.dart';
import 'package:together_online/models/target.dart';
import 'package:together_online/models/user.dart';
import 'package:together_online/models/language.dart';
import 'package:together_online/pages/missions/filter.dart';

part 'dataBinding.g.dart';

class DataBinding = DataBindingBase with _$DataBinding;

abstract class DataBindingBase with Store {
  DataBindingBase() {
    missions = new ObservableList();
    filterMissions = new ObservableList();
    actions = new ObservableList();
    platforms = new ObservableList();
    tags = new ObservableList();

  }

  static DataBinding _instance = DataBinding();

  static DataBinding getInstance() {
    return _instance;
  }

  @observable
  Session? session;

  @observable
  ObservableMap<String, List<dynamic>>? filter;

  @observable
  ObservableList<Mission>? missions;

  @observable
  bool isMissionLoad = false;

  @observable
  ObservableList<Mission>? filterMissions;

  @observable
  ObservableList<User> topUsers = ObservableList();

  @observable
  ObservableList<Group> topGroups = ObservableList();

  @observable
  ObservableList<Activity> activities = ObservableList();

  @computed
  bool get isAuth => this.session != null && this.session!.auth != null;

  @observable
  ObservableList<Language> languages = ObservableList();

  @observable
  Language selectedLanguage = Language(name: "English", language: "en");

  @action
  void setMissions(List<Mission> _missions) {
    _missions = _missions.where((_mission) {
      if(_mission.title!.startsWith("missions.") || _mission.body!.startsWith("missions.")) // If has no translation available
        return false;
      return true;
    }).toList();
    isMissionLoad =true;
    missions = ObservableList<Mission>.of(_missions);
    filterMissions = ObservableList<Mission>.of(_missions);
    actions?..clear()..addAll(_availableActions()) ;
    platforms?..clear()..addAll(_availablePlatforms()) ;
    tags?..clear()..addAll(_availableTag()) ;
  }

  @action
  void setSession(_session) {
    session = _session;
  }
  @observable
  ObservableList<ActionFilter>? actions;
  ObservableList<Target?>? platforms;
  ObservableList<TagFilter>? tags;


  List<Target?> _availablePlatforms() {
    List<Target?> allTargets =
    missions!.map((missionAction) => missionAction.target).toList();
    allTargets = _removeDuplicate(allTargets);
    return allTargets;
  }

  List<TagFilter> _availableTag() {
    List<TagFilter> allTag =[];
    missions!.forEach((mission) {
      mission.tags!.forEach((tag) {
        allTag.add( TagFilter( true, tag.name));
      });
    });
    return allTag;
  }

  List<ActionFilter> _availableActions() {
    List<ActionFilter> _actions = [];
    missions!.forEach((mission) {
      mission.actions!.forEach((action) {
        bool isNew = true;
        _actions.forEach((_action) {
          if (_action.name == action!.name) isNew = false;
        });
        if (isNew)
          _actions.add(new ActionFilter(
            action!.id,
            true,
            action.name,
            action.icon,
          ));
      });
    });
    return _actions;
  }

  List<Target?> _removeDuplicate(List<Target?> allTargets) {
    List<Target?> t = [];
    allTargets.forEach((target) {
      if(!t.contains(target))
        t.add(target);
    });
    return t;

  }
}
