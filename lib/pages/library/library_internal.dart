import 'package:flutter/material.dart';
import 'package:together_online/models/file.dart';
import 'package:together_online/models/folder.dart';
import 'package:together_online/providers/database.dart';
import 'package:together_online/providers/localstorage.dart';
import 'package:together_online/widgets/library_item.dart';

import '../../app_localizations.dart';

class LibraryInside extends StatefulWidget {
  final String? title;
  final Folder? currentFolder;
  final String? path;
  final bool isFavoriteFolder;

  LibraryInside({this.title, this.currentFolder, this.path, this.isFavoriteFolder = false});

  @override
  _LibraryInsideState createState() => _LibraryInsideState();
}

class _LibraryInsideState extends State<LibraryInside> {
  late List<Future<dynamic>> filesAndFolders;

  @override
  void initState() {
    if (widget.isFavoriteFolder) {
      filesAndFolders = [LocalStorageProvider.readFavorites()];
    } else {
    filesAndFolders = [
      Database.getLibraryFiles(widget.path),
      Database.getLibraryFolders(widget.path)
    ];
    }

    super.initState();
  }

  openFile(File f) {
    //TODO
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 15, bottom: 10),
              child: Text(
                widget.title!,
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
                  future: Future.wait(filesAndFolders),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      List<LibraryItem> list = [];
                      if ((snapshot.data as Map)[0].length != 0 && (snapshot.data as Map)[0][0] is Folder) {
                        list += ((snapshot.data as Map)[0] as List<Folder>)
                            .map(
                              (Folder f) => LibraryItem(
                                folder: f,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => LibraryInside(
                                        title: widget.title! + ' > ${f.name}',
                                        path: f.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                            .toList();
                      }
                      if ((snapshot.data as Map).length == 2 && (snapshot.data as Map)[1].length > 0 && (snapshot.data as Map)[1][0] is Folder) {
                        list += ((snapshot.data as Map)[1] as List<Folder>)
                            .map(
                              (Folder f) => LibraryItem(
                                folder: f,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (ctx) => LibraryInside(
                                        title: widget.title! + ' > ${f.name}',
                                        path: f.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                            .toList();
                      }
                      if ((snapshot.data as Map)[0].length != 0 && (snapshot.data as Map)[0][0] is File) {
                        list += ((snapshot.data as Map)[0] as List<File>)
                            .map((File f) => LibraryItem(
                                  file: f,
                                  onTap: () {
                                    print('Open File');
                                  },
                                ))
                            .toList();
                      }

                      if ((snapshot.data as Map).length == 2 && (snapshot.data as Map)[1].length > 0 && (snapshot.data as Map)[1][0] is File) {
                        list += ((snapshot.data as Map)[1] as List<File>)
                            .map((File f) => LibraryItem(
                                  file: f,
                                  onTap: () {
                                    openFile(f);
                                  },
                                ))
                            .toList();
                      }
                      if (list.length == 0) {
                        return Center(child: Text(AppLocalizations.of(context)!.translate('Empty')!));
                      } else {
                                            return ListView(
                                              shrinkWrap: true,
                        children: list,
                      );
                      }

                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
