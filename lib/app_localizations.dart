import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:together_online/models/language.dart';
import 'package:together_online/models/translate.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/server.dart';

class AppLocalizations {

  AppLocalizations();

  // Helper method to keep the code in the widgets concise
  // Localizations are accessed using an InheritedWidget "of" syntax
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

    // Static member to have a simple access to the delegate from the MaterialApp
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Translate _localizedStrings;
  var _binding = DataBindingBase.getInstance();

  Future<bool> load() async {

    await Server.getInstance()!.client.getTranslations(_binding.selectedLanguage.language!)
      .then((value) => _localizedStrings = value);

    return true;
  }

  // This method will be called from every widget which needs a localized text
  String? translate(String? key) {
    return _localizedStrings.localizedStrings![key!] ?? key;
  }
}

var _binding = DataBindingBase.getInstance();

// LocalizationsDelegate is a factory for a set of localized resources
// In this case, the localized strings will be gotten in an AppLocalizations object
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  // This delegate instance will never change (it doesn't even have fields!)
  // It can provide a constant constructor.
  const _AppLocalizationsDelegate();



  @override
  bool isSupported(Locale locale) {
    // Include all of your supported language codes here
    return _binding.languages.isEmpty || _binding.languages.contains(Language()..language = locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    // AppLocalizations class is where the JSON loading actually runs
    AppLocalizations localizations = new AppLocalizations();
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => true;
}