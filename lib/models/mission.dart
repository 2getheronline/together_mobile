import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:together_online/app_localizations.dart';
import 'package:together_online/models/action.dart';
import 'package:together_online/models/activity.dart';
import 'package:together_online/models/tag.dart';
import 'package:together_online/models/target.dart';
import 'package:json_annotation/json_annotation.dart';

part 'mission.g.dart';

enum MissionStatus { NOT_ACCEPTED, ACCEPTED, COMPLETED }

@JsonSerializable()
class Mission {
  int? id;
  String? title;
  String? body;

  //@JsonKey(name: 'platform')
  MissionStatus?
      missionStatus; // Campo adicionado apenas offline quando as missões são puxadas do sistema e comparadas com as que o user fez
  String? image;
  String? url;
  String?
      appVersion; // Não será usado dentro do app. Apenas para filtrar as missões que vão ser puxadas do Firestore
  @JsonKey(name: 'publishDate')
  DateTime? date;
  @JsonKey(name: 'deadlineDate')
  DateTime? endDate;
  DateTime? missionCompletedDate;
  bool? hasEndDate;
  bool? happy; // Que cara colocar no card e na missao
  int? expectedTime; // Quanto tempo leva a missão em minutos
  List<Group>? tags = [];
  List<dynamic>? categories = [];
  List<ActionModel?>? actions = []; // Enum declarado acima
  String? screenshot;

  @JsonKey(name: 'platform')
  Target? target;

  @JsonKey(ignore: true)
  List<String> completedActions = []; // Enum declarado acima
  List<String>? proposedComments =
      []; // Lista de comentários pré-prontos definidos pelo admin
  int? limit; // Numero max de pessoas que queremos atingir
  int? current; // Quantas pesoas ja fizeram
  int? level; // Quntas bolinhas preencher do lado da carinha na pag da missaos
  int? points; //
  Mission(
      {this.body,
//      this.id,
        this.image,
        this.url,
        this.endDate,
        this.hasEndDate,
        this.happy,
        this.expectedTime,
        this.points,
        this.limit,
        this.current,
        this.categories,
        this.proposedComments,this.date});

//    this.body = {"he": "כותרת", "en": "title"};
//    this.id = id;
//    this.title = {"he": "כותרת", "en": "title"};
//    this.image = image;
//    this.url = url;
//    this.date =date;
//    this.endDate = endDate;
//    this.hasEndDate = hasEndDate;
//    this.happy = happy;
//    this.expectedTime = expectedTime;
//    this.points = points;
//    this.limit = limit;
//    this.current = current;
//    this.tags = ["tag1", "tag2", "tag3"];
//    this.categories = ["tag1", "tag2", "tag3"];
//    this.proposedComments = ["tag1", "tag2", "tag3"];
//    this.target = Target(
//        name: "FACEBOOK",
//        pretty: "facebook",
//        filterIconEnabled: "assets/icons/faces/sad.svg",
//        filterIconDisabled: "assets/icons/faces/sad.svg",
//        icon: "assets/icons/faces/sad.svg",
//        availableActions: [new Action({"COMMENT", "comment", "assets/icons/faces/sad.svg"})]);
//    this.missionStatus = MissionStatus.ACCEPTED;


  Mission.fromMission([mission]) {

    this.id = mission['id'];

    this.image = mission['image'];
    this.url = mission['url'];
    this.endDate = mission['endDate'];
    this.hasEndDate = mission['hasEndDate'];
    this.happy = mission['happy'];
    this.expectedTime = mission['expectedTime'];
    this.points = mission['points'];
    this.limit = mission['limit'];
    this.current = mission['current'];
    this.tags = List<Group>.from(mission['tags'] ?? []);
    this.categories = mission['categories'];
    this.proposedComments = <String>[];

    if (mission['proposedComments'] != null)
      mission['proposedComments']
          .forEach((c) => this.proposedComments!.add(c.toString()));
//
//    if (mission['target'] is String) {
//      this.target = new Target.fromTarget(
//          Database.targets.firstWhere((d) => d['name'] == mission['target']));
//    } else {
//      this.target = mission['target'];
//    }

    if (mission['missionCompletedDate'] is Timestamp)
      this.missionCompletedDate =
          (mission['missionCompletedDate'] as Timestamp).toDate();
    else
      this.missionCompletedDate = mission['missionCompletedDate'];

    if (mission['date'] is Timestamp)
      this.date = (mission['date'] as Timestamp).toDate();
    else if (mission['date'] is String)
      this.date = DateTime.parse(mission['date']);
    else
      this.date = mission['date'];

    mission['actions'].forEach((action) {
      if (action is String)
        this.actions!.add(actionsMap[action.toString()]);
      else
        this.actions!.add(action);
    });

    this.missionStatus = mission['missionStatus'] == 'ACCEPTED'
        ? MissionStatus.ACCEPTED
        : mission['missionStatus'] == 'COMPLETED'
            ? MissionStatus.COMPLETED
            : MissionStatus.NOT_ACCEPTED;

//    if (missionStatus == MissionStatus.ACCEPTED &&
//        mission['completedActions'] != null) {
//      mission['completedActions'].forEach((action) {
//        if (action is String)
//          this.completedActions.add(actionsMap[action.toString()]);
//        else
//          this.completedActions.add(action);
//      });
//    }
    //print('Mission id: ' + id);
  }

  String timeLeft(context)
  {
    final difference = this.endDate!.difference(DateTime.now());
    int days = difference.inDays;
    int hours = difference.inHours;
    int minutes = difference.inMinutes;

    if(days >= 2) {
      return days.toString()+" "+AppLocalizations.of(context)!.translate("days")!;
    }
    if(hours >= 2) {
      return hours.toString()+" "+AppLocalizations.of(context)!.translate("Hours")!;
    }
    if(minutes >= 2) {
      return minutes.toString()+" "+AppLocalizations.of(context)!.translate("Minutes")!;
    }
    return AppLocalizations.of(context)!.translate("Less than a minute")!;
  }

  Map<String, dynamic> toObj() {
    return {
      'body': this.body,
      'id': this.id,
      'title': this.title,
      'image': this.image,
      'url': this.url,
      'endDate': this.endDate,
      'hasEndDate': this.hasEndDate,
      'missionCompletedDate': this.missionCompletedDate,
      'happy': this.happy,
      'missionStatus': this.missionStatus == MissionStatus.ACCEPTED
          ? 'ACCEPTED'
          : this.missionStatus == MissionStatus.NOT_ACCEPTED
              ? null
              : 'COMPLETED',
      'expectedTime': this.expectedTime,
      'points': this.points,
      'limit': this.limit,
      'current': this.current,
      'tags': this.tags,
      'categories': this.categories,
      'proposedComments': this.proposedComments,
      'date': this.date,
      'actions': this.actions!.map((f) => f!.name).toList()
    };
  }

  factory Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);
  Map<String, dynamic> toJson() => _$MissionToJson(this);
}
