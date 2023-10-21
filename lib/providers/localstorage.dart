
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:together_online/models/file.dart';
import 'package:together_online/models/language.dart';
final LocalStorage favoritesLocalStorage = new LocalStorage('favorites');
final LocalStorage missionsLocalStorage = new LocalStorage('missions');
final LocalStorage localeLocalStorage = new LocalStorage('locale');
final LocalStorage scriptsLocalStorage = new LocalStorage('scripts');

class LocalStorageProvider {

  static Future<int> getFavoritesCount() async {
    try {
      await favoritesLocalStorage.ready;
      List<dynamic> all = jsonDecode(favoritesLocalStorage.getItem('files') ?? '[]');
      return all.length;
    } catch (e) {
      print('Error on getting favorites count $e');
      return 0;
    }
  }

  static Future<bool> addFileToFavorites(File f) async {
    try {
      await favoritesLocalStorage.ready;
      List<dynamic> all = jsonDecode(favoritesLocalStorage.getItem('files') ?? '[]');
      all.add(f.toJson());
      await favoritesLocalStorage.setItem('files', jsonEncode(all));
      return true;
    } catch (e) {
      print('Error on saving favorite $e');
      return false;
    }
  }

  static Future<bool> removeFileFromFavorites(File? f) async {
    try {
      await favoritesLocalStorage.ready;
      List<dynamic> all = jsonDecode(favoritesLocalStorage.getItem('files') ?? '[]');
      all.removeWhere((dynamic a) { 
        return a['id'] == f!.id;
        });
      await favoritesLocalStorage.setItem('files', jsonEncode(all));
      return true;
    } catch (e) {
      print('Error on deleting favorite $e');
      return false;
    }
  }

  static Future<List<File>> readFavorites() async {
    try {
    await favoritesLocalStorage.ready;
    List<dynamic> all = jsonDecode(favoritesLocalStorage.getItem('files'));
    return all.map((dynamic f) => new File.fromJson({...f, 'isFavorite': true})).toList();
        } catch (e) {
      print('Error on getting favorites $e');
      return [];
    }
  }

  static void setMissionPreferences(String target, bool val) async {
    try {
      await missionsLocalStorage.ready;
      final pref = jsonDecode(missionsLocalStorage.getItem('preferences') ?? '{}');
      pref[target] = val;
      await missionsLocalStorage.setItem('preferences', jsonEncode(pref));
    } catch (e) {
      print('Error on setting preferences $e');
    }
  }  
  
  static Future<Map<String, bool>> getMissionPreferences() async {
    try {
      await missionsLocalStorage.ready;
      Map<String, bool> pref = new Map.from(jsonDecode(missionsLocalStorage.getItem('preferences') ?? '{}'));
      return pref;
    } catch (e) {
      print('Error on getting preferences $e');
      return {};
    }
  } 

  static void setLocale(Language l) async {
    try {
      await localeLocalStorage.ready;
      await localeLocalStorage.setItem('locale', jsonEncode(l.toJson()));
    } catch (e) {
      print('Error on setting locale $e');
    }
  }  

  static Future<Language?> getLocale() async {
    try {
      await localeLocalStorage.ready;

      final json = localeLocalStorage.getItem('locale');
      if (json == null ) return null;
      dynamic locale = Language.fromJson(jsonDecode(json));

      return locale;
    } catch (e) {
      print('Error on getting locale $e');
      return null;
    }
  }  

  static void saveScript(String target, String code) async {
    try {
      await scriptsLocalStorage.ready;
      await scriptsLocalStorage.setItem(target, code);
    } catch (e) {
      print('Error on saving script $e');
    }
  } 

  static Future<String?> getScript(String target) async {
    try {
      await scriptsLocalStorage.ready;
      return scriptsLocalStorage.getItem(target);
    } catch (e) {
      print('Error on getting script $e');
      return null;
    }
  }  


}