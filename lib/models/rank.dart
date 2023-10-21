import 'package:cloud_firestore/cloud_firestore.dart';

class Rank {

  String? id;
  String? name;
  String? avatar;
  int? points;

  Rank({
    this.id,
    this.name,
    this.avatar,
    this.points,
  });


  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name' : name,
      'avatar' : avatar,
      'points': points ?? 0,
    };
  }
  
  factory Rank.fromJson(Map<String, Object> doc) {
    Rank file = new Rank(
      id: doc['id'] as String?,
      name: doc['name'] as String?,
      avatar: doc['avatar'] as String?,
      points: doc['points'] as int? ?? 0,
    );
    return file;
  }

  factory Rank.fromDocument(DocumentSnapshot doc) {
    return Rank.fromJson(doc.data() as Map<String, Object>);
  }
  
}