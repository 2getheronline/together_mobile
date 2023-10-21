import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

FirebaseStorage storage = FirebaseStorage.instance;

class Storage {
  static Future<String> uploadImage(File image, String? uid) async {
    try {
      UploadTask task = storage.ref().child('/avatars/$uid').putFile(image);

      TaskSnapshot snap = task.snapshot;

      return await snap.ref.getDownloadURL();
    } catch (e) {
      print('Error on uploading image: $e');
      return '';
    }
  }
}
