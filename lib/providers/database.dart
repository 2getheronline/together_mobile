import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:package_info/package_info.dart';
import 'package:together_online/models/category.dart';
import 'package:together_online/models/file.dart';
import 'package:together_online/models/folder.dart';
import 'package:together_online/models/rank.dart';
import 'package:together_online/models/target.dart';
import 'package:together_online/models/user.dart';
import 'package:together_online/models/mission.dart';
import 'package:together_online/models/action.dart' as ActionModel;
import 'package:together_online/pages/home.dart';
import 'package:together_online/providers/localstorage.dart';
import 'dart:io' show Platform;

CollectionReference usersRef = FirebaseFirestore.instance.collection("users");
CollectionReference missionsRef = FirebaseFirestore.instance.collection("missions");
CollectionReference libraryRef = FirebaseFirestore.instance.collection("library");
CollectionReference rankRef = FirebaseFirestore.instance.collection("rank");
CollectionReference reportsRef = FirebaseFirestore.instance.collection("reports");

class Database {
  static final targets = [
    {
      'name': 'facebook',
      'pretty': 'Facebook',
      'icon': 'assets/icons/social_media_icons/facebook-circle.svg',
      'filterIconEnabled':
          'assets/icons/social_media_icons/filter_social_media/facebook_filter_selected.svg',
      'filterIconDisabled':
          'assets/icons/social_media_icons/filter_social_media/facebook_filter.svg',
      'availableActions': [
        ActionModel.Actions['LIKE'],
        ActionModel.Actions['COMMENT'],
        ActionModel.Actions['REPORT']
      ]
    },
    {
      'name': 'twitter',
      'pretty': 'Twitter',
      'icon': 'assets/icons/social_media_icons/twitter.svg',
      'filterIconEnabled':
          'assets/icons/social_media_icons/filter_social_media/twitter_filter_selected.svg',
      'filterIconDisabled':
          'assets/icons/social_media_icons/filter_social_media/twitter_filter.svg',
      'availableActions': [
        ActionModel.Actions['LIKE'],
        ActionModel.Actions['COMMENT'],
        ActionModel.Actions['RETWEET'],
        ActionModel.Actions['REPORT']
      ]
    },
    {
      'name': 'instagram',
      'pretty': 'Instagram',
      'icon': 'assets/icons/social_media_icons/instagram.svg',
      'filterIconEnabled':
          'assets/icons/social_media_icons/filter_social_media/instagram_filter_selected.svg',
      'filterIconDisabled':
          'assets/icons/social_media_icons/filter_social_media/instagram_filter.svg',
      'availableActions': [
        ActionModel.Actions['LIKE'],
        ActionModel.Actions['COMMENT'],
        ActionModel.Actions['REPORT']
      ]
    },
    {
      'name': 'youtube',
      'pretty': 'YouTube',
      'icon': 'assets/icons/social_media_icons/youtube.svg',
      'filterIconEnabled':
          'assets/icons/social_media_icons/filter_social_media/youtube_filter_selected.svg',
      'filterIconDisabled':
          'assets/icons/social_media_icons/filter_social_media/youtube_filter.svg',
      'availableActions': [
        ActionModel.Actions['LIKE'],
        ActionModel.Actions['COMMENT'],
        ActionModel.Actions['REPORT']
      ]
    },
    {
      'name': 'google',
      'pretty': 'Google',
      'icon': 'assets/icons/social_media_icons/google.svg',
      'filterIconEnabled':
          'assets/icons/social_media_icons/filter_social_media/google_filter_selected.svg',
      'filterIconDisabled':
          'assets/icons/social_media_icons/filter_social_media/google_filter.svg',
      'availableActions': [
        ActionModel.Actions['LIKE'],
        ActionModel.Actions['COMMENT'],
      ]
    }
  ];

  static final categoriesObj = [
    {'name': 'Antissemitism'},
    {'name': 'BDS'},
    {'name': 'Terrorism'}
  ];

  static List<Mission> allMissionsList = [];

  static List<Target> platforms =
      targets.map((dynamic t) => Target.fromTarget(t)).toList();
  static List<Category> categories =
      categoriesObj.map((dynamic t) => Category(t)).toList();

  static Future<DocumentSnapshot> getUserDoc(String uid) {
    return usersRef.doc(uid).get();
  }

  static Stream<DocumentSnapshot> userStream(String uid) {
    return usersRef.doc(uid).snapshots();
  }

  static Future<Set<DocumentSnapshot>> getAllMissions(Map<String, bool> tags) async {
    //TODO: Activate for Production
    //String version = (await PackageInfo.fromPlatform()).version;
    String version = '1.1';
    print('Current version $version');
    Query baseQuery = missionsRef.orderBy('version')
                                 .where('version', isLessThanOrEqualTo: version)
                                 .where('tags', arrayContainsAny: tags.keys.toList())
                                 .orderBy("date", descending: true);

    Set<DocumentSnapshot> allMissions = Set<DocumentSnapshot>();

    QuerySnapshot snapshot = await baseQuery.get();

    if (Platform.isIOS) {
      allMissions.addAll(snapshot.docs.where((DocumentSnapshot doc) => (doc.data() as Map )['target'] != 'instagram' && (doc.data() as Map)['target'] != 'google'));
    } else {
      allMissions.addAll(snapshot.docs);
    }

    return allMissions;
  }


  static Future<List<Mission>> getUserMissions() async {
    List<Mission> missions = [];
//    List<DocumentSnapshot> docs = (await usersRef
//        .document(currentUser.uid)
//        .collection("userMissions")
//        .orderBy('endDate', descending: true)
//        .getDocuments()).documents;
//    docs.forEach((d) => missions.add(new Mission.fromMission(d.data)));
    return missions;
  }
//
//  static Future<List<Mission>> getMissions(User user) async {
//    Map<String, bool> tags = {};
//    tags.removeWhere((a, b) => b == false);
//    Set<DocumentSnapshot> allMissions = await getAllMissions(tags);
//
//    QuerySnapshot userMissions = await usersRef
//        .document(user.uid)
//        .collection("userMissions")
//        .getDocuments();
//
//    Map<String, dynamic> allMissionsMap = {};
//
//    allMissions.forEach((mission) {
//      allMissionsMap[mission.documentID] = mission.data;
//      allMissionsMap[mission.documentID]['target'] = Target.fromTarget(targets.firstWhere(
//          (t) => t['name'] == allMissionsMap[mission.documentID]['target'],
//          orElse: () => {}));
//    });
//
//    userMissions.documents.forEach((userMission) {
//      if (allMissionsMap[userMission.documentID] != null) {
//        allMissionsMap[userMission.documentID]["missionStatus"] =
//            userMission.data["missionStatus"];
//        if (userMission.data["missionStatus"] == 'ACCEPTED') {
//          allMissionsMap[userMission.documentID]["completedActions"] =
//              userMission.data["completedActions"];
//        }
//      }
//    });
//
//    allMissionsList = allMissionsMap.values.map((m) => new Mission.fromMission(m)).toList();
//
//    //TODO: Activate from production
//    //allMissionsList.removeWhere((Mission m) => m.missionStatus == MissionStatus.COMPLETED);
//
//    final prefs = await LocalStorageProvider.getMissionPreferences();
//    return filterMissions({
//      'targets': prefs.keys.where((String k) => !prefs[k]).map((String s) => platforms.where((t) => t.name == s).toList()[0]).toList(),
//      'categories': [],
//      'tasks': [],
//    });
//  }

  static List<Mission> filterMissions(Map<String, List<dynamic>> filter) {
    List<Mission> missions = List.of(allMissionsList);
  if (filter == null) return missions;
    allMissionsList.forEach((Mission m) {
      filter['targets']!.forEach((t) {
        if (m.target!.name == t.name) missions.remove(m);
      });
      filter['categories']!.forEach((c) {
        if (m.categories!.contains(c.name)) missions.remove(m);
      });
      filter['tasks']!.forEach((t) {
        if (m.actions!.contains(t)) missions.remove(m);
      });
    });
    return missions;
  }

  static addMission(Mission mission) async {
//    try {
//      mission.missionStatus = MissionStatus.ACCEPTED;
//      return await usersRef
//          .document(currentUser.uid)
//          .collection('userMissions')
//          .document(mission.id)
//          .setData(mission.toObj(), merge: true);
//    } catch (e) {
//      throw e;
//    }
  }

  static saveMission(mission) async {
//    try {
//      return await usersRef
//          .document(currentUser.uid)
//          .collection('userMissions')
//          .document(mission['id'])
//          .setData(mission, merge: true);
//    } catch (e) {
//      throw e;
//    }
  }

  static changeMissionStatus(String missionId, String missionStatus) async {
//    try {
//      return await usersRef
//          .document(currentUser.uid)
//          .collection('userMissions')
//          .document(missionId)
//          .setData({
//        'missionStatus': missionStatus,
//        'missionCompletedDate': Timestamp.now()
//      }, merge: true);
//    } catch (e) {
//      print('Error' + e.toString());
//      throw e;
//    }
  }

  static Future<List<Folder>> getLibraryFolders(String? path) async {
    QuerySnapshot docs;

    if (path == null) {
      docs = await libraryRef.get();
    } else {
      docs =
          await libraryRef.doc(path).collection('folders').get();
    }

    List<Folder> folders = [];
    docs.docs.forEach((DocumentSnapshot s) {
      folders.add(new Folder.fromJson({...(s.data() as Map) as Map<String, Object>, 'id': s.id}));
    });

    return folders;
  }

  static Future<List<File>> getLibraryFiles(String? path) async {
    QuerySnapshot docs =
        await libraryRef.doc(path).collection('files').get();
    List<File> favorites = await LocalStorageProvider.readFavorites();

    List<File> files = [];
    docs.docs.forEach((DocumentSnapshot s) {
      files.add(new File.fromJson({
        ...(s.data() as Map) as Map<String, Object?>,
        'id': s.id,
        'isFavorite':
            favorites.indexWhere((File f) => f.id == s.id) >= 0
      }));
    });

    return files;
  }


  static Future<bool> changeUserName(String name) async {
//    try {
//      await usersRef.document(currentUser.uid).updateData({'name': name});
//      return true;
//    } catch (e) {
//      print('Error on updating name $e');
     return false;
//    }

  }

  static Future<bool> changeUserEmail(String email) async {
//    try {
//      await usersRef.document(currentUser.uid).updateData({'email': email});
//      return true;
//    } catch (e) {
//      print('Error on updating email $e');
     return false;
//    }
  }

  static Future<bool> changeUserAvatar(String avatar) async {
//    try {
//      await usersRef.document(currentUser.uid).updateData({'avatar': avatar});
//      return true;
//    } catch (e) {
//      print('Error on updating avatar $e');
     return false;
//    }
  }


  static Future<bool> changeUserLevel(int level) async {
//    try {
//      await usersRef.document(currentUser.uid).updateData({'level': level});
//      return true;
//    } catch (e) {
//      print('Error on updating level $e');
     return false;
//    }
  }

  static Future<List<Rank>> getRank() async {
    QuerySnapshot docs =
        await rankRef.orderBy('points', descending: true).limit(20).get();
    List<Rank> ranks = [];
    docs.docs.forEach((DocumentSnapshot doc) => ranks.add(Rank.fromDocument(doc)));
    return ranks;
  }



}
