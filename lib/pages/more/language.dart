import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:together_online/app_localizations.dart';
import 'package:together_online/models/language.dart';
import 'package:together_online/providers/auth.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/main.dart';
import 'package:together_online/providers/localstorage.dart';
import 'dart:ui' as ui;

class LanguagePage extends StatefulWidget {
  static const routeName = '/languagePage';

  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  var _binding = DataBindingBase.getInstance();

  changeLanguageTo(Language l) async {
    _binding.selectedLanguage = l;
    _binding.session?.auth?.language = l.language;
    await server?.editUser();
    await server?.getMissions();

    AppLocalizations.delegate.load(Locale(l.language!, "US")).then((value) {
      MyAppState state = context.findAncestorStateOfType<MyAppState>()!;
      state.setState(() {});
    });

    LocalStorageProvider.setLocale(l);
  }

  @override
  void initState() {
    super.initState();
  }

//  getLocale() async {
//    var l = await LocalStorageProvider.getLocale();
//    if (l == null) {
//      LocalStorageProvider.setLocale('en');
//      l = 'en';
//    }
//    _binding.selectedLanguages = _binding.languages.firstWhere((x)=>x.language == l);
//  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: _binding.selectedLanguage.language == "he"
            ? ui.TextDirection.rtl
            : ui.TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: Container(
            margin: EdgeInsets.only(
              top: 20,
              left: 25,
              right: 25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.translate('language')!,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: globalHeight * .025,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ...(_binding.languages
                    .where((Language) => Language.name != 'Purtogus')
                    .map((Language l) => LanguageItem(
                          language: l,
                          onTap: () {
                            changeLanguageTo(l);
                          },
                        ))
                    .toList())
              ],
            ),
          ),
        ));
  }
}

class LanguageItem extends StatelessWidget {
  final Language? language;
  final Function? onTap;
  var _binding = DataBindingBase.getInstance();

  LanguageItem({this.language, this.onTap});

  @override
  Widget build(BuildContext context) {
    bool isSelected = _binding.selectedLanguage.language == language!.language;

    return Container(
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            onTap: () {
              if (!isSelected) onTap!();
            },
            trailing: isSelected
                ? Icon(
                    Icons.check,
                    color: Color(0xff2a388f),
                  )
                : null,
            title: Text(
              language!.name!,
              style: TextStyle(
                fontSize: globalHeight * .02,
                fontWeight: FontWeight.bold,
                color: isSelected ? Color(0xff2a388f) : null,
              ),
            ),
          ),
          Divider()
        ],
      ),
    );
  }
}
