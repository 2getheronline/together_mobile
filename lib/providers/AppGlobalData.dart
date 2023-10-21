import 'dart:convert';
import 'package:localstorage/localstorage.dart';
import 'package:together_online/providers/auth.dart';

class AppGlobalData {
  static AppGlobalData _instance = AppGlobalData();

  static AppGlobalData getInstance() {
    return _instance;
  }

  String? userLanguage;
  String? deviceLanguage;
  bool termsAgreed = false;
  LocalStorage _platformLoggedInStorage = new LocalStorage("PLATFORM_LOGIN");
  Map<String, bool> _isPlatformLoggedIn = {};
  Map<String, String> _platformLogInUrl = {
    "facebook": "https://www.facebook.com/login",
    "youtube": "https://accounts.google.com/ServiceLogin?service=youtube",
    "twitter": "https://twitter.com/login",
    "instagram": "https://www.instagram.com/login"
  };

  isPlatfromLoggedIn(String platform) {
    if (_platformLogInUrl.containsKey(platform) == false) return true;

    return _isPlatformLoggedIn.containsKey(platform) &&
        _isPlatformLoggedIn[platform] == true;
  }

  getPlatformLoginUrl(String platform) {
    return _platformLogInUrl[platform];
  }

  setPlatformLoggedIn(String platform) async {
    _isPlatformLoggedIn[platform] = true;
    await _platformLoggedInStorage.setItem(platform, true);
  }

  load() async {
    await _platformLoggedInStorage.ready;
    _platformLogInUrl.forEach((platform, loginUrl) async { 
      bool isLoggedIn = await _platformLoggedInStorage.getItem(platform) ?? false;
      _isPlatformLoggedIn[platform] = isLoggedIn;
    });
    termsAgreed = ((await localStorage.getItem("TERMS_AGREED")) ?? true);
  }
}
