// import 'package:firebase_remote_config/firebase_remote_config.dart';
// import 'package:flutter/services.dart';
// import 'package:together_online/providers/localstorage.dart';
//
// class RemoteConfigProvider {
//
//   static getConfigs() async {
//
//     // final RemoteConfig remoteConfig = await RemoteConfig.instance;
//
//     String facebookScript = await rootBundle.loadString('assets/scripts/facebook.js');
//     String googleScript = await rootBundle.loadString('assets/scripts/google.js');
//     String instagramScript = await rootBundle.loadString('assets/scripts/instagram.js');
//     String twitterScript = await rootBundle.loadString('assets/scripts/twitter.js');
//
//
//     final defaults = <String, String>{'facebook_script': facebookScript, 'google_script': googleScript, 'instagram_script': instagramScript, 'twitter_script': twitterScript};
//
//     try {
//       await remoteConfig.setDefaults(defaults);
//
//       await remoteConfig.fetch();
//       await remoteConfig.activate();
//     } catch(e) {
//       print('Error on getting RemoteConfig $e');
//     }
//
//     LocalStorageProvider.saveScript('facebook', remoteConfig.getString('facebook_script'));
//     LocalStorageProvider.saveScript('google', remoteConfig.getString('google_script'));
//     LocalStorageProvider.saveScript('instagram', remoteConfig.getString('instagram_script'));
//     LocalStorageProvider.saveScript('twitter', remoteConfig.getString('twitter_script'));
//
//     print('Scripts downloaded');
//
//   }
//
//
// }