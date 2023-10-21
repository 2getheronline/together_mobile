// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataBinding.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$DataBinding on DataBindingBase, Store {
  Computed<bool>? _$isAuthComputed;

  @override
  bool get isAuth => (_$isAuthComputed ??=
          Computed<bool>(() => super.isAuth, name: 'DataBindingBase.isAuth'))
      .value;

  final _$sessionAtom = Atom(name: 'DataBindingBase.session');

  @override
  Session? get session {
    _$sessionAtom.reportRead();
    return super.session;
  }

  @override
  set session(Session? value) {
    _$sessionAtom.reportWrite(value, super.session, () {
      super.session = value;
    });
  }

  final _$filterAtom = Atom(name: 'DataBindingBase.filter');

  @override
  ObservableMap<String, List<dynamic>>? get filter {
    _$filterAtom.reportRead();
    return super.filter;
  }

  @override
  set filter(ObservableMap<String, List<dynamic>>? value) {
    _$filterAtom.reportWrite(value, super.filter, () {
      super.filter = value;
    });
  }

  final _$missionsAtom = Atom(name: 'DataBindingBase.missions');

  @override
  ObservableList<Mission>? get missions {
    _$missionsAtom.reportRead();
    return super.missions;
  }

  @override
  set missions(ObservableList<Mission>? value) {
    _$missionsAtom.reportWrite(value, super.missions, () {
      super.missions = value;
    });
  }

  final _$isMissionLoadAtom = Atom(name: 'DataBindingBase.isMissionLoad');

  @override
  bool get isMissionLoad {
    _$isMissionLoadAtom.reportRead();
    return super.isMissionLoad;
  }

  @override
  set isMissionLoad(bool value) {
    _$isMissionLoadAtom.reportWrite(value, super.isMissionLoad, () {
      super.isMissionLoad = value;
    });
  }

  final _$filterMissionsAtom = Atom(name: 'DataBindingBase.filterMissions');

  @override
  ObservableList<Mission>? get filterMissions {
    _$filterMissionsAtom.reportRead();
    return super.filterMissions;
  }

  @override
  set filterMissions(ObservableList<Mission>? value) {
    _$filterMissionsAtom.reportWrite(value, super.filterMissions, () {
      super.filterMissions = value;
    });
  }

  final _$topUsersAtom = Atom(name: 'DataBindingBase.topUsers');

  @override
  ObservableList<User> get topUsers {
    _$topUsersAtom.reportRead();
    return super.topUsers;
  }

  @override
  set topUsers(ObservableList<User> value) {
    _$topUsersAtom.reportWrite(value, super.topUsers, () {
      super.topUsers = value;
    });
  }

  final _$topGroupsAtom = Atom(name: 'DataBindingBase.topGroups');

  @override
  ObservableList<Group> get topGroups {
    _$topUsersAtom.reportRead();
    return super.topGroups;
  }

  @override
  set topGroups(ObservableList<Group> value) {
    _$topUsersAtom.reportWrite(value, super.topGroups, () {
      super.topGroups = value;
    });
  }

  final _$activitiesAtom = Atom(name: 'DataBindingBase.activities');

  @override
  ObservableList<Activity> get activities {
    _$activitiesAtom.reportRead();
    return super.activities;
  }

  @override
  set activities(ObservableList<Activity> value) {
    _$activitiesAtom.reportWrite(value, super.activities, () {
      super.activities = value;
    });
  }

  final _$languagesAtom = Atom(name: 'DataBindingBase.languages');

  @override
  ObservableList<Language> get languages {
    _$languagesAtom.reportRead();
    return super.languages;
  }

  @override
  set languages(ObservableList<Language> value) {
    _$languagesAtom.reportWrite(value, super.languages, () {
      super.languages = value;
    });
  }

  final _$selectedLanguageAtom = Atom(name: 'DataBindingBase.selectedLanguage');

  @override
  Language get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(Language value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  final _$actionsAtom = Atom(name: 'DataBindingBase.actions');

  @override
  ObservableList<ActionFilter>? get actions {
    _$actionsAtom.reportRead();
    return super.actions;
  }

  @override
  set actions(ObservableList<ActionFilter>? value) {
    _$actionsAtom.reportWrite(value, super.actions, () {
      super.actions = value;
    });
  }

  final _$DataBindingBaseActionController =
      ActionController(name: 'DataBindingBase');

  @override
  void setMissions(List<Mission> _missions) {
    final _$actionInfo = _$DataBindingBaseActionController.startAction(
        name: 'DataBindingBase.setMissions');
    try {
      return super.setMissions(_missions);
    } finally {
      _$DataBindingBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSession(dynamic _session) {
    final _$actionInfo = _$DataBindingBaseActionController.startAction(
        name: 'DataBindingBase.setSession');
    try {
      return super.setSession(_session);
    } finally {
      _$DataBindingBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
session: ${session},
filter: ${filter},
missions: ${missions},
isMissionLoad: ${isMissionLoad},
filterMissions: ${filterMissions},
topUsers: ${topUsers},
activities: ${activities},
languages: ${languages},
selectedLanguage: ${selectedLanguage},
actions: ${actions},
isAuth: ${isAuth}
    ''';
  }
}
