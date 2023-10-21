import 'package:cloud_firestore/cloud_firestore.dart';

class Folder {

  String? id;
  String? name;
  int? fileCount;
  DateTime? lastUpdated;
  bool seen = true;

  Folder({
    this.id,
    this.name,
    this.fileCount,
    this.lastUpdated,
    this.seen = true,
  });


  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name' : name,
      'fileCount': fileCount,
      'lastUpdated': lastUpdated,
    };
  }
  
  factory Folder.fromJson(Map<String, Object> doc) {
    Folder folder = new Folder(
      id: doc['id'] as String?,
      name: doc['name'] as String?,
      fileCount: doc['fileCount'] as int?,
      lastUpdated: (doc['lastUpdated'] as Timestamp).toDate(),
    );


    return folder;
  }

  factory Folder.fromDocument(DocumentSnapshot doc) {
    return Folder.fromJson(doc.data() as Map<String, Object>);
  }
  
}