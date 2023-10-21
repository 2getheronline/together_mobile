import 'package:cloud_firestore/cloud_firestore.dart';

class File {

  String? id;
  String? name;
  String? url;
  String? format;
  DateTime? uploadDate;
  bool isFavorite;

  File({
    this.id,
    this.name,
    this.url,
    this.format,
    this.uploadDate,
    this.isFavorite = false,
  });


  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name' : name,
      'url': url,
      'format': format,
      'uploadDate': uploadDate!.millisecondsSinceEpoch,
      'isFavorite': isFavorite
    };
  }
  
  factory File.fromJson(Map<String, Object?> doc) {
    File file = new File(
      id: doc['id'] as String?,
      name: doc['name'] as String?,
      url: doc['url'] as String?,
      format: doc['format'] as String?,
      isFavorite: doc['isFavorite'] as bool? ?? false
    );

    if (doc['uploadDate'] is Timestamp) {
      file.uploadDate = (doc['uploadDate'] as Timestamp).toDate();
    } else {
      file.uploadDate = Timestamp.fromMicrosecondsSinceEpoch(doc['uploadDate'] as int).toDate();
    }

    return file;
  }

  factory File.fromDocument(DocumentSnapshot doc) {
    return File.fromJson(doc.data() as Map<String, Object?>);
  }
  
}