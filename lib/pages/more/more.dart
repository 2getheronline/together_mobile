import 'package:flutter/material.dart';
import 'package:together_online/pages/more/language.dart';
import 'package:together_online/pages/more/notifications.dart';
import 'package:together_online/pages/more/security.dart';
import 'package:together_online/providers/dataBinding.dart';
import 'package:together_online/providers/global.dart';
import 'package:together_online/widgets/more_items.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_localizations.dart';

class More extends StatelessWidget {
  More({Key? key}) : super(key: key);
  var _binding = DataBindingBase.getInstance();

  void openPrivacy()
  {
    String file = _binding.selectedLanguage.language == "he" ? "privacy_heb.pdf" : "privacy.pdf";
    launch("https://together.clap.co.il/"+file);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.only(
          top: 20,
          left: 25,
          right: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context)!.translate('more')!,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: globalHeight * .025,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  MoreItem(
                    title: (AppLocalizations.of(context)!.translate('language')),
                    onTap: () =>
                        Navigator.of(context).pushNamed(LanguagePage.routeName),
                  ),
                  MoreItem(
                    title: (AppLocalizations.of(context)!.translate('notifications')),
                    onTap: () => Navigator.of(context)
                        .pushNamed(NotificationsPage.routeName),
                  ),
                  MoreItem(
                    title: (AppLocalizations.of(context)!.translate('security')),
                    onTap: () => Navigator.of(context)
                        .pushNamed(SecurityPage.routeName),
                  ),
                  // MoreItem(
                  //   title: (AppLocalizations.of(context)!.translate('terms of service')),
                  //   // isBlue: true,
                  // ),
                  MoreItem(
                    title: (AppLocalizations.of(context)!.translate('privacy policy')),
                    onTap: () => openPrivacy(),
                    // isBlue: true,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
