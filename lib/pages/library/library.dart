import 'package:flutter/material.dart';
import 'package:together_online/app_localizations.dart';
import 'package:together_online/models/folder.dart';
import 'package:together_online/pages/library/library_internal.dart';
import 'package:together_online/providers/database.dart';
import 'package:together_online/providers/localstorage.dart';
import 'package:together_online/widgets/library_item.dart';

class Library extends StatefulWidget {
  @override
  _LibraryState createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  

  @override
  Widget build(BuildContext context) {
    String title = AppLocalizations.of(context)!.translate('library')!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * .025,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
                          child: FutureBuilder(
                future: Future.wait([
                  LocalStorageProvider.getFavoritesCount(),
                  Database.getLibraryFolders(null)
                ]),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    List<LibraryItem> children = [
                      LibraryItem(
                        isFavorite: true,
                        folder: new Folder(
                          id: 'favorites',
                          name: AppLocalizations.of(context)!.translate('favorites'),
                          fileCount: ((snapshot.data as Map) as Map)[0] ?? 0,
                          lastUpdated: DateTime.now(),
                        ),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (ctx) => LibraryInside(
                                title: title + ' > Favorites',
                                isFavoriteFolder: true,
                              ),
                            ),
                          );
                        },
                      ),
                    ];
                    children += (((snapshot.data as Map) as Map)[1] as List<Folder>)
                        .map(
                          (Folder f) => LibraryItem(
                            folder: f,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => LibraryInside(
                                    title: AppLocalizations.of(context)!.translate(title)! + ' > ${AppLocalizations.of(context)!.translate(f.name)}',
                                    path: f.id,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                        .toList();
                    return ListView(
                      shrinkWrap: true,
                      children: children,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
