import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:together_online/models/activity.dart';
import 'package:together_online/models/mission.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/database.dart';

const endpoints = {
  'youtube': {
    'like': 'https://www.googleapis.com/youtube/v3/videos/rate/',
    'dislike': 'https://www.googleapis.com/youtube/v3/videos/rate/',
    'comment': 'https://www.googleapis.com/youtube/v3/commentThreads',
    'createChannel': 'https://m.youtube.com/create_channel?chromeless=1&next=/channel_creation_done',
    'createChannelDone': 'https://m.youtube.com/channel_creation_done',
    'report': 'https://www.googleapis.com/youtube/v3/videos/reportAbuse'
  }
};

const googleApiKey = 'AIzaSyB8cFTUsogmejl1TcgHM6unIazhw5CV8K8';

class Youtube {
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static String? googleAccessToken;

  static Future<bool> getYoutubeAuthorization() async {
    try {
      final GoogleSignIn googleSignIn = new GoogleSignIn(
          scopes: ['https://www.googleapis.com/auth/youtube.force-ssl']);

      GoogleSignInAccount? account = await (googleSignIn.signIn());
      print('account $account');
      GoogleSignInAuthentication? googleAuth = await account?.authentication;
      print('account $googleAuth');
      googleAccessToken = googleAuth?.accessToken;
      
      return true;
    } catch (e) {
      print('Error: ' + e.toString());
      return false;
    }
  }

  static Future<bool> likeVideo(String? videoId) async {
    http.Response res = await http.post(
         Uri.parse(endpoints['youtube']!['like']! +
            "?id=$videoId&rating=like&key=$googleApiKey"),
        headers: {'Authorization': 'Bearer $googleAccessToken'});
    if (res.statusCode == 204) {
      return true;
    } else if (res.statusCode == 401 && res.body.contains('youtubeSignupRequired')) {
      throw 'youtubeSignupRequired';
    } else {
      throw res.body;
    }
  }

  static Future<bool> dislikeVideo(String? videoId) async {
    http.Response res = await http.post(
        Uri.parse(endpoints['youtube']!['dislike']! +
            "?id=$videoId&rating=dislike&key=$googleApiKey"),
        headers: {'Authorization': 'Bearer $googleAccessToken'});

    if (res.statusCode == 204) {
      return true;
    } else if (res.statusCode == 401 && res.body.contains('youtubeSignupRequired')) {
      throw 'youtubeSignupRequired';
    }  else {
      throw res.body;
    }
  }

  static Future<bool> commentVideo(String? videoId, String? comment) async {
    final body = {
      'snippet': {
        "videoId": videoId,
        "topLevelComment": {
          "snippet": {"textOriginal": comment}
        }
      }
    };
    final res = await http.post(Uri.parse(
        endpoints['youtube']!['comment']! + "?part=snippet&key=$googleApiKey"),
        headers: {'Authorization': 'Bearer $googleAccessToken', 'Content-Type': 'application/json'},
        body: jsonEncode(body));

    if (res.statusCode == 403 && res.body.contains('ineligibleAccount')) {
      print(res.body);
      throw 'ineligibleAccount';
    } else if (res.statusCode == 401 && res.body.contains('youtubeSignupRequired')) {
      throw 'youtubeSignupRequired';
    } else {
      print('worked');
      return true;
    }
  }

  static reportVideo(String? videoId, int secondaryReasonId) async {
    final body = {
      'videoId': videoId,
      'reasonId': 'V',
      'secondaryReasonId': secondaryReasonId
    };
    final res = await http.post(Uri.parse(
        endpoints['youtube']!['report']! + "?key=$googleApiKey"),
        headers: {'Authorization': 'Bearer $googleAccessToken', 'Content-Type': 'application/json'},
        body: jsonEncode(body));

    if (res.statusCode == 403) {
      throw res.body;
    } else if (res.statusCode == 401 && res.body.contains('youtubeSignupRequired')) {
      throw 'youtubeSignupRequired';
    }  else {
      return true;
    }
  }



}


class Facebook {

  static getFacebookAuthorization() async {

  }

  static likePost(String url) {

  }

  static commentPost(String? url, String? comment) {
    
  }

}


  missionCompleted(Mission mission) async {

      await server!.client.createActivity(Activity(
          missionId: mission.id
      ));
      server!.loadUser();
      return {'success': true, 'message': null};

  }